# Per-frame semantic segmentation result.
# class_map contains one int32 class ID per pixel, in row-major order.
# width * height == len(class_map).

std_msgs/Header header
string model_name
int32 device_id
uint32 width
uint32 height
int32[] class_map
tb_det_msgs/TbPerf[] perfs
