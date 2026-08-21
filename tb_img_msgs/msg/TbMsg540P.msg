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

# Physical address of data[] inside the FastDDS dmabuf-backed shared
# segment. Hardware consumers (PP/encoder) wrap it into an fd via
# LOOKUP_BY_PHYS and skip the copy. 0 = not available.
uint64 phys_addr

uint32 MAX_SIZE=1555200
