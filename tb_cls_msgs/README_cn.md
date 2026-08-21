# tb_cls_msgs

TOPSBOT 图像分类结果消息。

`TbClassifications.results` 按置信度从高到低排列；每个结果包含
`class_id`、`label` 和 `score`。`perfs` 复用 `tb_det_msgs/TbPerf`，用于携带
排队、前处理、推理与后处理耗时。

默认话题：`/classifications`。
