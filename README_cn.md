# topsbot_msgs

[English](README.md)

TOPSBOT 平台的 **ROS 2 自定义消息仓库**，集中维护板端感知链路所需的接口定义。本仓库**不包含可执行节点**，仅提供消息类型供其他功能包依赖。

**当前版本：0.4.1** — 详见 [CHANGELOG.md](./CHANGELOG.md)。

## 子包

| 子包 | 版本 | 文档 |
| ---- | ---- | ---- |
| [tb_img_msgs](./tb_img_msgs/) | 0.4.1 | [README.md](./tb_img_msgs/README.md) · [README_cn.md](./tb_img_msgs/README_cn.md) |
| [tb_det_msgs](./tb_det_msgs/) | 0.4.1 | [README.md](./tb_det_msgs/README.md) · [README_cn.md](./tb_det_msgs/README_cn.md) |
| [tb_cls_msgs](./tb_cls_msgs/) | 0.4.1 | [README_cn.md](./tb_cls_msgs/README_cn.md) |
| [tb_seg_msgs](./tb_seg_msgs/) | 0.4.1 | — |

各子包 README 中有字段说明、使用示例与常见问题；下文为仓库级速览。

## 消息速览

### tb_img_msgs（零拷贝图像与码流）

| 消息 | 最大载荷 | 典型用途 |
| ---- | -------- | -------- |
| `TbMsg480P` / `TbMsg540P` / `TbMsg1080P` | 按分辨率 | NV12 等未压缩像素 |
| `TbJpegFrame` | 3 MiB | USB MJPEG / JPEG 单帧码流（**0.2.0 新增**） |
| `TbH26XFrame` | 1 MiB | H.264 / H.265 单 AU（**0.2.0 起 1 MiB**，原 512 KiB） |

未压缩格式按分辨率分档；JPEG / H26x 使用专用消息（变长码流，不能按 `W×H` 选类型）。分档策略与编码包络见 [tb_img_msgs README](./tb_img_msgs/README_cn.md)。

### tb_det_msgs（感知输出）

| 消息 | 作用 |
| ---- | ---- |
| `TbPerceptionTargets` | 检测/感知发布（如 `topsbot_yolo_det` → `/detections`） |
| `TbTarget`、`TbRoi`、`TbPoint`、`TbPerf`、`TbPerceptionInfo` | 组成字段（`TbPoint` / `track_id` 自 **0.3.0**） |

### tb_cls_msgs（分类）

| 消息 | 作用 |
| ---- | ---- |
| `TbClassification` / `TbClassifications` | 图像分类结果（**0.4.0 新增**） |

### tb_seg_msgs（分割）

| 消息 | 作用 |
| ---- | ---- |
| `TbSegmentation` | 逐帧语义分割（`class_map`、尺寸、性能）（**0.4.1 新增**） |

## 仓库结构

```
topsbot_msgs/
├── CHANGELOG.md
├── README.md / README_cn.md
├── tb_img_msgs/
├── tb_det_msgs/
├── tb_cls_msgs/
└── tb_seg_msgs/
```

## 安装与编译

### 依赖

- ROS 2 Humble（或兼容的 ROS 2 发行版）
- `rosidl_default_generators` / `rosidl_default_runtime`
- `builtin_interfaces`、`std_msgs`、`sensor_msgs`（`tb_det_msgs` 需要）
- `tb_det_msgs`（`tb_cls_msgs`、`tb_seg_msgs` 需要）

### 源码编译

将本仓库放入工作空间 `src/` 后：

```bash
colcon build --packages-select tb_img_msgs tb_det_msgs tb_cls_msgs tb_seg_msgs
source install/setup.bash
```

### apt 安装

```bash
sudo apt install -y \
  tbros-humble-tb-img-msgs \
  tbros-humble-tb-det-msgs \
  tbros-humble-tb-cls-msgs \
  tbros-humble-tb-seg-msgs
```

## 在其他包中使用

### package.xml

```xml
<depend>tb_img_msgs</depend>
<!-- 若需要检测 / 分类 / 分割结果消息 -->
<depend>tb_det_msgs</depend>
<depend>tb_cls_msgs</depend>
<depend>tb_seg_msgs</depend>
```

### CMakeLists.txt

```cmake
find_package(tb_img_msgs REQUIRED)
find_package(tb_det_msgs REQUIRED)  # 可选
find_package(tb_cls_msgs REQUIRED)  # 可选
find_package(tb_seg_msgs REQUIRED)  # 可选

ament_target_dependencies(your_node
  tb_img_msgs tb_det_msgs tb_cls_msgs tb_seg_msgs)
```

修改 `.msg` 文件后，需重新编译消息包及所有依赖它的功能包。

## 下游集成（典型）

| 功能包 | 使用的消息 |
| ------ | ---------- |
| `topsbot_usb_cam` | `TbMsg480P`、`TbJpegFrame` |
| `topsbot_yolo_det` | `TbMsg480P`、`TbPerceptionTargets` |
| `topsbot_webviz` | `TbMsg480P`、`TbJpegFrame`、`TbPerceptionTargets` |
| `topsbot_cv` | `TbMsg480P`、`TbJpegFrame` |

---

## 许可

Apache License 2.0 — 见 [LICENSE](./LICENSE) 与 [NOTICE](./NOTICE)。

欢迎贡献，请参阅 [CONTRIBUTING.md](./CONTRIBUTING.md)。
