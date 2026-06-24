# tb_img_msgs

[English](README.md)

TOPSBOT 共享内存图像与 H26x 码流消息，语义对齐 d-robotics 生态中的 `hbm_img_msgs`。

配合 `borrow_loaned_message()` 与 Fast DDS Data Sharing，用于板端**零拷贝**图像传输。

# 消息列表

| 消息 | 最大载荷 | 典型分辨率 | 说明 |
| ---- | -------- | ---------- | ---- |
| `TbMsg480P` | 921600 B (640×480×3) | 640×480 | 原始 / 压缩图像 |
| `TbMsg540P` | 1555200 B (960×540×3) | 960×540 | 原始 / 压缩图像 |
| `TbMsg1080P` | 6220800 B (1920×1080×3) | 1920×1080 | 原始 / 压缩图像 |
| `TbH26XFrame` | 512000 B (500 KiB) | 任意 | H.264 / H.265 编码帧 |

> `data[]` 上限按 RGB24 满幅估算，实际格式由 `encoding` + `data_size` 决定。NV12 等格式的有效字节数通常小于 `MAX_SIZE`。

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
| `encoding` | uint8[12] | 像素格式，如 `nv12`、`mjpeg`（C 字符串） |
| `data` | uint8[N] | 固定长度缓冲区 |

## TbH26XFrame

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `index` | uint32 | 帧序号 |
| `dts` / `pts` | Time | 解码 / 显示时间戳 |
| `encoding` | uint8[12] | 码流类型，如 `h264`、`h265` |
| `height` / `width` | uint32 | 帧分辨率 |
| `data` | uint8[512000] | 码流数据（含 NAL 起始码） |
| `data_size` | uint32 | 有效码流字节数 |

# 使用约定

1. **读有效数据**：始终使用 `data_size`，不要按 `MAX_SIZE` 全量拷贝。
2. **解析格式**：读取 `encoding` 字符串，结合各节点文档（如 `topsbot_usb_cam` preset）。
3. **零拷贝发布**：优先 `borrow_loaned_message()`。
4. **话题类型匹配**：480p 链路使用 `TbMsg480P`，订阅端类型须一致。

# 编译

```bash
colcon build --packages-select tb_img_msgs
source install/setup.bash
```

交叉编译：

```bash
topsbot_ws/tools/build.sh -p MES20 -s tb_img_msgs
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
| topsbot_usb_cam | 发布 `/tbmem_img`（零拷贝模式） |
| topsbot_yolo_det | 订阅 NV12 输入做检测 |
| topsbot_cv | 订阅 / 发布，做 crop、resize 等 |
