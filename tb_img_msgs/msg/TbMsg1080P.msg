# TOPSBOT shared-memory image message (1920x1080 RGB24 max).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.

int32 index
builtin_interfaces/Time time_stamp
uint32 height
uint32 width
uint32 data_size
uint32 step
uint8[12] encoding
uint8[6220800] data

uint32 MAX_SIZE=6220800
