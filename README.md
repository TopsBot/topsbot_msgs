# topsbot_msgs

[中文文档](README_cn.md)

ROS 2 custom message repository for the TOPSBOT platform. This repo defines **interface types only** — no executable nodes.

**Current release: 0.2.0** — see [CHANGELOG.md](./CHANGELOG.md).

## Packages

| Package | Version | Documentation |
| ------- | ------- | ------------- |
| [tb_img_msgs](./tb_img_msgs/) | 0.2.0 | [README.md](./tb_img_msgs/README.md) · [README_cn.md](./tb_img_msgs/README_cn.md) |
| [tb_det_msgs](./tb_det_msgs/) | 0.2.0 | [README.md](./tb_det_msgs/README.md) · [README_cn.md](./tb_det_msgs/README_cn.md) |

## Message overview

### tb_img_msgs (zero-copy image & codec)

| Message | Max payload | Typical use |
| ------- | ----------- | ----------- |
| `TbMsg480P` / `TbMsg540P` / `TbMsg1080P` | by resolution | NV12 and other uncompressed pixels |
| `TbJpegFrame` | 3 MiB | USB MJPEG / JPEG bitstream (**new in 0.2.0**) |
| `TbH26XFrame` | 1 MiB | H.264 / H.265 access unit (**1 MiB since 0.2.0**, was 512 KiB) |

Uncompressed formats are split by resolution; JPEG and H26x use dedicated types (VBR — size is not `W×H`). See [tb_img_msgs README](./tb_img_msgs/README.md) for tiering policy and codec envelope.

### tb_det_msgs (perception output)

| Message | Role |
| ------- | ---- |
| `TbPerceptionTargets` | Detection / perception publish (e.g. `topsbot_yolo_det` → `/detections`) |
| `TbTarget`, `TbRoi`, `TbPerf`, `TbPerceptionInfo` | Building blocks |

## Repository layout

```
topsbot_msgs/
├── CHANGELOG.md
├── README.md / README_cn.md
├── tb_img_msgs/
└── tb_det_msgs/
```

## Build

### Dependencies

- ROS 2 Humble (or compatible distro)
- `rosidl_default_generators` / `rosidl_default_runtime`
- `builtin_interfaces`, `std_msgs`, `sensor_msgs` (`tb_det_msgs`)

### From source

Place this repo under your workspace `src/`, then:

```bash
colcon build --packages-select tb_img_msgs tb_det_msgs
source install/setup.bash
```

### apt

```bash
sudo apt install -y ros-humble-tb-img-msgs ros-humble-tb-det-msgs
```

## Use in other packages

### package.xml

```xml
<depend>tb_img_msgs</depend>
<depend>tb_det_msgs</depend>  <!-- optional -->
```

### CMakeLists.txt

```cmake
find_package(tb_img_msgs REQUIRED)
find_package(tb_det_msgs REQUIRED)

ament_target_dependencies(your_node tb_img_msgs tb_det_msgs)
```

After adding a dependency, rebuild message packages and your node when `.msg` files change.

## Downstream integration (typical)

| Package | Messages used |
| ------- | ------------- |
| `topsbot_usb_cam` | `TbMsg480P`, `TbJpegFrame` |
| `topsbot_yolo_det` | `TbMsg480P`, `TbPerceptionTargets` |
| `topsbot_webviz` | `TbMsg480P`, `TbJpegFrame`, `TbPerceptionTargets` |
| `topsbot_cv` | `TbMsg480P`, `TbJpegFrame` |

---

## License

Apache License 2.0 — see [LICENSE](./LICENSE) and [NOTICE](./NOTICE).

Contributions welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md).
