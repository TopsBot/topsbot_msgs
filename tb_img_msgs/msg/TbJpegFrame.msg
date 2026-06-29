# TOPSBOT shared-memory JPEG/MJPEG frame (max 3 MiB per access unit).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.
# Sized for 1920x1080 MJPEG: V4L2 compressed frames + high-quality margin.
# Each message carries one complete JPEG bitstream (typical USB MJPEG capture).

int32 index
builtin_interfaces/Time time_stamp
uint32 height
uint32 width
uint8[12] encoding
uint8[3145728] data
uint32 data_size
uint32 MAX_SIZE=3145728
