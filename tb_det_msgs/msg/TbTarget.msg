# TOPSBOT logical target (aligned with ai_msgs/Target nesting).
# One target may contain multiple rois and landmark sets.

string type
uint64 track_id
TbRoi[] rois
TbPoint[] points
