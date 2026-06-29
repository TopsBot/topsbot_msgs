# TOPSBOT shared-memory image message (640x480 RGB24 max).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.
# Read payload by encoding + data_size; supports NV12 and other formats.

int32 index
builtin_interfaces/Time time_stamp
uint32 height
uint32 width
uint32 data_size
uint32 step
uint8[12] encoding
uint8[921600] data

uint32 MAX_SIZE=921600
