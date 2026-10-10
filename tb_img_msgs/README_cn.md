# tb_img_msgs

[English](README.md)

TOPSBOT 共享内存图像与 H26x 码流消息，语义对齐 d-robotics 生态中的 `hbm_img_msgs`。

配合 `borrow_loaned_message()` 与 Fast DDS Data Sharing，用于板端**零拷贝**图像传输。

# 消息列表

| 消息 | 最大载荷 | 典型分辨率 | 说明 |
| ---- | -------- | ---------- | ---- |
| `TbMsg480P` | 921600 B (640×480×3) | 640×480 | NV12 等原始像素 |
| `TbMsg540P` | 1555200 B (960×540×3) | 960×540 | NV12 等原始像素 |
| `TbMsg1080P` | 6220800 B (1920×1080×3) | 1920×1080 | NV12 等原始像素 |
| `TbJpegFrame` | 3145728 B (3 MiB) | 1920×1080 | USB MJPEG / JPEG 单帧码流 |
| `TbH26XFrame` | 1048576 B (1 MiB) | 1920×1080 | H.264 / H.265 单 AU 码流 |

> `TbMsg*` 的 `data[]` 上限按 RGB24 满幅估算，**仅用于 NV12 等未压缩格式**（`encoding=nv12`）。MJPEG / H26x 使用专用消息 `TbJpegFrame` / `TbH26XFrame`，**不按分辨率分档**（变长码流由 `MAX_SIZE` + 编码包络约束）。

## 消息分档策略（设计原则）

| 数据形态 | 是否按分辨率分消息 | 原因 |
| -------- | ------------------ | ---- |
| 未压缩像素（NV12 等） | ✅ `TbMsg480P/540P/1080P` | 载荷大小由 `W×H×bpp` 确定 |
| JPEG / MJPEG | ❌ 统一 `TbJpegFrame` | 变长码流；分辨率不决定单帧大小 |
| H.264 / H.265 | ❌ 统一 `TbH26XFrame` | 变长码流；I 帧大小取决于码率/GOP |

Topic 区分业务（如 `/tbmem_jpeg`、`/tbmem_h264`），消息类型区分数据形态，**不要用分辨率档命名压缩消息**。

## 编码包络（Codec Envelope）

发布者编码参数应落在此包络内，订阅方可假定无需改消息类型即可互通：

| 消息 | `MAX_SIZE` | 分辨率上限 | 编码假设 |
| ---- | ---------- | ---------- | -------- |
| `TbJpegFrame` | 3 MiB (`3145728`) | 1920×1080 | 每消息 **一帧完整 JPEG**；常规 MJPEG / 软编 quality |
| `TbH26XFrame` | 1 MiB (`1048576`) | 1920×1080 | 每消息 **一个 access unit**；H.264 ≤4 Mbps 或 H.265 ≤2 Mbps；GOP ≤60 |

发布前必须校验 `data_size ≤ MAX_SIZE`；超限应丢帧或告警，不得静默截断。`width`/`height` 为标称分辨率元数据，**不用于**选择消息类型。

# 字段说明

## TbMsg480P / TbMsg540P / TbMsg1080P

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `index` | int32 | 帧序号 |
| `time_stamp` | Time | 采集时间戳 |
| `height` | uint32 | 图像高度 |
| `width` | uint32 | 图像宽度 |
| `data_size` | uint32 | **有效载荷字节数**（≤ `data` 数组长度） |
| `step` | uint32 | 行步长（字节） |
| `encoding` | uint8[12] | 像素格式，如 `nv12`（C 字符串） |
| `data` | uint8[N] | 固定长度缓冲区 |

## TbJpegFrame

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `index` | int32 | 帧序号 |
| `time_stamp` | Time | 采集时间戳 |
| `height` / `width` | uint32 | 标称分辨率（解码后以 JPEG 头为准） |
| `encoding` | uint8[12] | 固定 `jpeg` |
| `data` | uint8[3145728] | 单帧 JPEG 码流（上限 3 MiB，覆盖 1080p MJPEG） |
| `data_size` | uint32 | 有效码流字节数 |

## TbH26XFrame

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `index` | uint32 | 帧序号 |
| `dts` / `pts` | Time | 解码 / 显示时间戳 |
| `encoding` | uint8[12] | 码流类型，如 `h264`、`h265` |
| `height` / `width` | uint32 | 帧分辨率 |
| `data` | uint8[1048576] | 码流数据（含 NAL 起始码，上限 1 MiB） |
| `data_size` | uint32 | 有效码流字节数 |

# 使用约定

1. **读有效数据**：始终使用 `data_size`，不要按 `MAX_SIZE` 全量拷贝。
2. **解析格式**：读取 `encoding` 字符串，结合各节点文档（如 `topsbot_usb_cam` preset）。
3. **零拷贝发布**：优先 `borrow_loaned_message()`。
4. **话题类型匹配**：NV12 按分辨率选 `TbMsg480P/540P/1080P`；JPEG → `TbJpegFrame`；H26x → `TbH26XFrame`（topic 如 `/tbmem_jpeg`、`/tbmem_h264`）。

# 编译

```bash
colcon build --packages-select tb_img_msgs
source install/setup.bash
```

交叉编译：

```bash
topsbot_ws/tools/scripts/build.sh -p MES20 -s tb_img_msgs
```

# C++ 示例

```cpp
#include "tb_img_msgs/msg/tb_msg480_p.hpp"

auto loaned_msg = publisher_->borrow_loaned_message();
auto & msg = loaned_msg.get();
msg.width = 640;
msg.height = 480;
msg.data_size = nv12_size;
std::memcpy(msg.encoding.data(), "nv12", 5);
publisher_->publish(std::move(loaned_msg));
```

# 命名规则

消息文件 PascalCase（`TbMsg480P.msg`），C++ 头文件 snake_case（`tb_msg480_p.hpp`）。

# 相关功能包

| 功能包 | 角色 |
| ------ | ---- |
| topsbot_usb_cam | 发布 `/tbmem_img`（NV12）或 `/tbmem_jpeg`（MJPEG） |
| topsbot_yolo_det | 订阅 NV12 输入做检测 |
| topsbot_cv | 订阅 / 发布，做 crop、resize 等 |
