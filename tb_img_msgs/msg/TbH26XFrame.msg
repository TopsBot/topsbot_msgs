# TOPSBOT shared-memory H.264/H.265 frame (max 1 MiB per access unit).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.
# Sized for 1920x1080 @ general-purpose bitrates (see README codec envelope).
# Frame payload includes NAL start codes (00 00 00 01 or 00 00 01).

uint32 index
builtin_interfaces/Time dts
builtin_interfaces/Time pts
uint8[12] encoding
uint32 height
uint32 width
uint8[1048576] data
uint32 data_size
uint32 MAX_SIZE=1048576
