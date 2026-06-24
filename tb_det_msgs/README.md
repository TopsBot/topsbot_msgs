# tb_det_msgs

[中文文档](README_cn.md)

ROS 2 messages for TOPSBOT perception and object detection: structured boxes, classes, confidence, and performance spans.

## Messages

| Message | Description |
| ------- | ----------- |
| `TbPerceptionTargets` | **Main output** — all targets per frame + FPS + perf data |
| `TbTarget` | Logical target (may contain multiple ROIs) |
| `TbRoi` | Single detection box (aligned with `ai_msgs/Roi` semantics) |
| `TbPerf` | Stage timing (preprocess / infer / postprocess, etc.) |
| `TbPerceptionInfo` | Low-rate metadata (resolution, class names; optional) |

## Structure

```
TbPerceptionTargets
├── header          (std_msgs/Header)
├── fps             (int16)
├── perfs[]         (TbPerf[])
└── targets[]       (TbTarget[])
        ├── type    (string, class name)
        └── rois[]  (TbRoi[])
                ├── type         (string)
                ├── rect         (sensor_msgs/RegionOfInterest)
                └── confidence   (float32)
```

## Fields

### TbPerceptionTargets

| Field | Type | Description |
| ----- | ---- | ----------- |
| `header` | Header | Timestamp and frame_id |
| `fps` | int16 | Output FPS (optional, default 0) |
| `perfs` | TbPerf[] | Performance spans |
| `targets` | TbTarget[] | Detected targets this frame |

### TbTarget

| Field | Type | Description |
| ----- | ---- | ----------- |
| `type` | string | Class name, e.g. `person`, `car` |
| `rois` | TbRoi[] | ROIs for this target |

### TbRoi

| Field | Type | Description |
| ----- | ---- | ----------- |
| `type` | string | ROI / class type |
| `rect` | RegionOfInterest | Bounding box |
| `confidence` | float32 | Score 0.0 ~ 1.0 |

### TbPerf

| Field | Type | Description |
| ----- | ---- | ----------- |
| `type` | string | e.g. `yolo_preprocess`, `yolo_infer`, `yolo_postprocess`, `yolo_viz` |
| `stamp_start` / `stamp_end` | Time | Optional timestamps |
| `time_ms_duration` | float64 | Duration in milliseconds |

### TbPerceptionInfo

Low-rate auxiliary info on a separate topic:

| Field | Type | Description |
| ----- | ---- | ----------- |
| `header` | Header | Timestamp |
| `height` / `width` | uint32 | Input image size |
| `class_names` | string[] | Model class name list |

## Typical topics

| Topic | Type | Publisher | Notes |
| ----- | ---- | --------- | ----- |
| `/detections` | `TbPerceptionTargets` | topsbot_yolo_det | Off by default; set `publish_detections:=true` |

## Build

```bash
colcon build --packages-select tb_det_msgs
source install/setup.bash
```


## Examples

### Enable structured YOLO output

```bash
ros2 launch topsbot_yolo_det yolo_det.launch.py \
  --ros-args -p publish_detections:=true

ros2 topic echo /detections --once
```

### C++ subscribe

```cpp
#include "tb_det_msgs/msg/tb_perception_targets.hpp"

void on_detections(const tb_det_msgs::msg::TbPerceptionTargets::SharedPtr msg)
{
  for (const auto & target : msg->targets) {
    for (const auto & roi : target.rois) {
      // roi.rect.x_offset, roi.confidence, target.type ...
    }
  }
}
```

### CLI

```bash
ros2 interface show tb_det_msgs/msg/TbPerceptionTargets
ros2 interface show tb_det_msgs/msg/TbRoi
```

## vs visualization topic

`topsbot_yolo_det` publishes `/yolo_viz` (`sensor_msgs/Image`) for preview by default.

`TbPerceptionTargets` is for **downstream logic** (alerts, tracking, cloud upload). Both can be enabled together.
