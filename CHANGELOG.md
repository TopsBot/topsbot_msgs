# Changelog

All notable changes to this repository are documented here.

## 0.2.0 (2026-06-29)

### Added

- `TbJpegFrame` message: JPEG/MJPEG zero-copy frame (max 3 MiB, 1080p envelope).
- `tb_img_msgs` CMakeLists: register `TbJpegFrame.msg`.

### Changed

- `TbH26XFrame`: increase `MAX_SIZE` from 512 KiB to 1 MiB for 1080p H.264/H.265 access units.
- `tb_img_msgs` README (EN/CN): document message tiering policy and codec envelope.
- Root `README.md` / `README_cn.md`: v0.2.0 overview, message tables, downstream integration.

## 0.1.0 (2026-06-21)

- Initial release of `tb_img_msgs`: `TbMsg480P`, `TbMsg540P`, `TbMsg1080P`, `TbH26XFrame`.
- Initial release of `tb_det_msgs`: `TbPerceptionTargets`, `TbTarget`, `TbRoi`, `TbPerf`, `TbPerceptionInfo`.
- Apache-2.0 license declared in package manifests.
