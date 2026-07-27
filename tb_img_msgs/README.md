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
| `TbJpegFrame` | 3145728 B (3 MiB) | 1920×1080 | JPEG / MJPEG bitstream (one frame) |
| `TbH26XFrame` | 1048576 B (1 MiB) | 1920×1080 | H.264 / H.265 bitstream (one AU) |

> `TbMsg*` capacity is sized for full RGB24 (NV12 etc.). JPEG / H26x use dedicated types — **not** split by resolution (VBR streams use `MAX_SIZE` + codec envelope).

## Message tiering (design)

| Payload | Split by resolution? | Rationale |
| ------- | -------------------- | --------- |
| Uncompressed pixels | Yes — `TbMsg480P/540P/1080P` | Size is `W×H×bpp` |
| JPEG / MJPEG | No — `TbJpegFrame` only | VBR; resolution ≠ frame size |
| H.264 / H.265 | No — `TbH26XFrame` only | VBR; I-frame size depends on bitrate/GOP |

Use **topics** for business paths (`/tbmem_jpeg`, `/tbmem_h264`); use **message types** for payload shape.

## Codec envelope

Publishers should stay within this envelope so subscribers need no message-type changes:

| Message | `MAX_SIZE` | Max resolution | Encoding assumptions |
| ------- | ---------- | -------------- | -------------------- |
| `TbJpegFrame` | 3 MiB | 1920×1080 | One complete JPEG per message |
| `TbH26XFrame` | 1 MiB | 1920×1080 | One AU per message; H.264 ≤4 Mbps or H.265 ≤2 Mbps; GOP ≤60 |

Always validate `data_size ≤ MAX_SIZE` before publish. `width`/`height` are metadata, not message selection keys.

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

### TbJpegFrame

| Field | Type | Description |
| ----- | ---- | ----------- |
| `index` | int32 | Frame index |
| `time_stamp` | Time | Capture timestamp |
| `height` / `width` | uint32 | Nominal resolution |
| `encoding` | uint8[12] | `jpeg` |
| `data` | uint8[3145728] | JPEG bitstream (max 3 MiB, up to 1080p MJPEG) |
| `data_size` | uint32 | Valid bitstream bytes |

### TbH26XFrame

| Field | Type | Description |
| ----- | ---- | ----------- |
| `index` | uint32 | Frame index |
| `dts` / `pts` | Time | Decode / presentation timestamps |
| `encoding` | uint8[12] | Stream type, e.g. `h264`, `h265` |
| `height` / `width` | uint32 | Frame resolution |
| `data` | uint8[1048576] | Bitstream (NAL start codes, max 1 MiB) |
| `data_size` | uint32 | Valid bitstream bytes |

## Conventions

1. **Read valid bytes only** — use `data_size`, not `MAX_SIZE`.
2. **Parse format** — read `encoding`; see node docs (e.g. `topsbot_usb_cam` presets).
3. **Zero-copy publish** — prefer `borrow_loaned_message()`.
4. **Matching types** — NV12: `TbMsg480P/540P/1080P`; JPEG: `TbJpegFrame`; H26x: `TbH26XFrame`.

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
