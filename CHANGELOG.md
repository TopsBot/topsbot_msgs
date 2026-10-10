# Changelog

All notable changes to this repository are documented here.

## 0.4.1 (2026-09-24)

### Added

- `tb_seg_msgs`: segmentation results (`TbSegmentation`).

### Changed

- Update script location for release tooling.
- Align all packages (`tb_img_msgs`, `tb_det_msgs`, `tb_cls_msgs`, `tb_seg_msgs`) to repository version 0.4.1.
- Root `README.md` / `README_cn.md`: document all four packages for 0.4.1.
- `release.yaml`: `version` / `release` → 0.4.1; export `tb_seg_msgs/`.

## 0.4.0 (2026-08-20)

### Added

- `tb_cls_msgs`: image-classification results (`TbClassification`, `TbClassifications`).
- `phys_addr` (`uint64`) on `TbMsg480P` / `TbMsg540P` / `TbMsg1080P` / `TbJpegFrame` for FastDDS dmabuf LOOKUP by downstream hardware consumers (`0` = not available).

### Changed

- `TbJpegFrame`: place `phys_addr` before `data[]` so `offsetof(data)` matches the `TbMsg*` layout and dmabuf `data_offset`.
- `tb_img_msgs` / `tb_det_msgs` package versions aligned to 0.4.0. New `tb_cls_msgs` remains 0.1.0.

## 0.3.0 (2026-07-24)

### Added

- `TbPoint` message: landmark/keypoint set (`type`, `geometry_msgs/Point32[] point`, `float32[] confidence`).
- `TbTarget.points`: attach landmark sets on each logical target (hands / pose / face keypoints).

### Changed

- `TbTarget`: add `track_id` and nest `rois[]` / `points[]` (aligned with `ai_msgs/Target` nesting).
- `tb_det_msgs` depends on `geometry_msgs`.
- Root `README.md` / `README_cn.md`: v0.3.0 overview for perception landmark fields.

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
