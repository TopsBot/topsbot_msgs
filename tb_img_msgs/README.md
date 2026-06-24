# tb_img_msgs

[中文文档](README_cn.md)

Shared-memory image and H26x stream messages for TOPSBOT, aligned with d-robotics `hbm_img_msgs`.

Designed for **zero-copy** transport via `borrow_loaned_message()` and Fast DDS Data Sharing.

## Messages

| Message | Max payload | Typical resolution | Description |
| ------- | ----------- | ------------------ | ----------- |
| `TbMsg480P` | 921600 B (640×480×3) | 640×480 | Raw / compressed image |
| `TbMsg540P` | 1555200 B (960×540×3) | 960×540 | Raw / compressed image |
| `TbMsg1080P` | 6220800 B (1920×1080×3) | 1920×1080 | Raw / compressed image |
| `TbH26XFrame` | 512000 B (500 KiB) | any | H.264 / H.265 encoded frame |

> `data[]` capacity is sized for full RGB24. Actual format is defined by `encoding` + `data_size`. NV12 payloads are usually smaller than `MAX_SIZE`.

## Fields

### TbMsg480P / TbMsg540P / TbMsg1080P

| Field | Type | Description |
| ----- | ---- | ----------- |
| `index` | int32 | Frame index |
| `time_stamp` | Time | Capture timestamp |
| `height` | uint32 | Image height |
| `width` | uint32 | Image width |
| `data_size` | uint32 | **Valid payload bytes** (≤ `data` length) |
| `step` | uint32 | Row stride (bytes) |
| `encoding` | uint8[12] | Pixel format, e.g. `nv12`, `mjpeg` (C string) |
| `data` | uint8[N] | Fixed-size buffer |

### TbH26XFrame

| Field | Type | Description |
| ----- | ---- | ----------- |
| `index` | uint32 | Frame index |
| `dts` / `pts` | Time | Decode / presentation timestamps |
| `encoding` | uint8[12] | Stream type, e.g. `h264`, `h265` |
| `height` / `width` | uint32 | Frame resolution |
| `data` | uint8[512000] | Bitstream (includes NAL start codes) |
| `data_size` | uint32 | Valid bitstream bytes |

## Conventions

1. **Read valid bytes only** — use `data_size`, not `MAX_SIZE`.
2. **Parse format** — read `encoding`; see node docs (e.g. `topsbot_usb_cam` presets).
3. **Zero-copy publish** — prefer `borrow_loaned_message()`.
4. **Matching types** — 480p pipelines use `TbMsg480P`; subscriber type must match.

## Build

```bash
colcon build --packages-select tb_img_msgs
source install/setup.bash
```

## C++ example

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

## Naming

Message files use PascalCase (`TbMsg480P.msg`). C++ headers are snake_case: `tb_msg480_p.hpp`.

## Related packages

| Package | Role |
| ------- | ---- |
| topsbot_usb_cam | Publishes `/tbmem_img` (zero-copy mode) |
| topsbot_yolo_det | Subscribes NV12 for detection |
| topsbot_cv | Subscribe / publish for crop, resize, etc. |
