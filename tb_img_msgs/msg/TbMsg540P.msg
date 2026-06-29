# TOPSBOT shared-memory image message (960x540 RGB24 max).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.

int32 index
builtin_interfaces/Time time_stamp
uint32 height
uint32 width
uint32 data_size
uint32 step
uint8[12] encoding
uint8[1555200] data

uint32 MAX_SIZE=1555200
