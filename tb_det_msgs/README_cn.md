# tb_det_msgs

[English](README.md)

TOPSBOT 感知与目标检测相关的 ROS 2 消息定义，用于结构化输出检测框、类别、置信度及性能统计。

# 消息列表

| 消息 | 说明 |
| ---- | ---- |
| `TbPerceptionTargets` | **主输出**：一帧内所有目标 + FPS + 性能数据 |
| `TbTarget` | 逻辑目标（可含多个 ROI 与关键点组，对齐 `ai_msgs/Target`） |
| `TbRoi` | 单个检测框（对齐 `ai_msgs/Roi` 语义） |
| `TbPoint` | 关键点组（对齐 `ai_msgs/Point`：body_kps / face_kps / hand_kps） |
| `TbPerf` | 各阶段耗时（preprocess / infer / postprocess 等） |
| `TbPerceptionInfo` | 低频元数据（分辨率、类别名列表等，可选） |

# 消息结构

```
TbPerceptionTargets
├── header          (std_msgs/Header)
├── fps             (int16)
├── perfs[]         (TbPerf[])
└── targets[]       (TbTarget[])
        ├── type       (string，类别名)
        ├── track_id   (uint64，无跟踪时为 0)
        ├── rois[]     (TbRoi[])
        │       ├── type / rect / confidence
        └── points[]   (TbPoint[])
                ├── type         (body_kps / face_kps / hand_kps)
                ├── point[]      (geometry_msgs/Point32)
                └── confidence[] (与 point 等长)
```

# 字段说明

## TbPerceptionTargets

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `header` | Header | 时间戳与坐标系 |
| `fps` | int16 | 输出帧率（可选，默认 0） |
| `perfs` | TbPerf[] | 各阶段性能埋点 |
| `targets` | TbTarget[] | 本帧检测到的目标列表 |

## TbTarget

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `type` | string | 目标类别，如 `person`、`hand`、`face`、`car` |
| `track_id` | uint64 | 跟踪 ID；无跟踪时填 0 |
| `rois` | TbRoi[] | 该目标关联的 ROI 列表（如 body/hand/face） |
| `points` | TbPoint[] | 关键点组；YOLO 等可留空 |

## TbPoint

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `type` | string | `body_kps` / `face_kps` / `hand_kps` |
| `point` | Point32[] | 像素坐标（x/y；z 可选相对深度） |
| `confidence` | float32[] | 与 `point` 等长；Pose 可将 visibility 写入此字段 |

## TbRoi

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `type` | string | ROI 类型 / 类别 |
| `rect` | RegionOfInterest | 矩形框 |
| `confidence` | float32 | 置信度 0.0 ~ 1.0 |

## TbPerf

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `type` | string | 如 `yolo_preprocess`、`yolo_infer`、`yolo_postprocess`、`yolo_viz` |
| `stamp_start` / `stamp_end` | Time | 起止时间（可选） |
| `time_ms_duration` | float64 | 耗时（毫秒） |

## TbPerceptionInfo

低频辅助信息，适合单独话题发布：

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `header` | Header | 时间戳 |
| `height` / `width` | uint32 | 输入图像尺寸 |
| `class_names` | string[] | 模型类别名列表 |

# 典型话题

| 话题 | 消息类型 | 发布者 | 说明 |
| ---- | -------- | ------ | ---- |
| `/detections` | `TbPerceptionTargets` | topsbot_yolo_det | 默认关闭，需 `publish_detections:=true` |

# 编译

```bash
colcon build --packages-select tb_det_msgs
source install/setup.bash
```

交叉编译：

```bash
topsbot_ws/tools/build.sh -p MES20 -s tb_det_msgs
```

# 使用示例

## 启用 YOLO 结构化输出

```bash
ros2 launch topsbot_yolo_det yolo_det.launch.py \
  --ros-args -p publish_detections:=true

ros2 topic echo /detections --once
```

## C++ 订阅

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

## 命令行

```bash
ros2 interface show tb_det_msgs/msg/TbPerceptionTargets
ros2 interface show tb_det_msgs/msg/TbRoi
```

# 与可视化话题的关系

`topsbot_yolo_det` 默认发布 `/yolo_viz`（`sensor_msgs/Image`）用于预览。

`TbPerceptionTargets` 面向下游业务逻辑（告警、跟踪、上报等），两者可同时开启。
