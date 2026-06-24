# TOPSBOT shared-memory H.264/H.265 frame (max 500 KiB per access unit).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.
# Frame payload includes NAL start codes (00 00 00 01 or 00 00 01).

uint32 index
builtin_interfaces/Time dts
builtin_interfaces/Time pts
uint8[12] encoding
uint32 height
uint32 width
uint8[512000] data
uint32 data_size
uint32 MAX_SIZE=512000
