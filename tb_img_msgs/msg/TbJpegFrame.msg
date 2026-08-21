# TOPSBOT shared-memory JPEG/MJPEG frame (max 3 MiB per access unit).
# Fixed-size data array for Fast DDS loaned message / zero-copy transport.
# Sized for 1920x1080 MJPEG: V4L2 compressed frames + high-quality margin.
# Each message carries one complete JPEG bitstream (typical USB MJPEG capture).

int32 index
builtin_interfaces/Time time_stamp
uint32 height
uint32 width
uint8[12] encoding

# Physical address of data[] inside the FastDDS dmabuf-backed shared
# segment. Hardware consumers (e.g. the JPEG decoder) can wrap this phys
# into an fd via LOOKUP_BY_PHYS and skip the copy into a fresh buffer.
# 0 = not available (fall back to copying).
# NOTE: phys_addr must sit BEFORE data[] so that offsetof(data) == 40,
# matching the TbMsg* layout and the dmabuf backend's data_offset
# (4096-4-40) for page-aligned loaned payloads.
uint64 phys_addr

uint8[3145728] data
uint32 data_size
uint32 MAX_SIZE=3145728
