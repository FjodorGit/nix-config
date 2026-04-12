#!/usr/bin/env python3
import mmap
import sys

# (search_pattern, replacement for last 4 bytes)
PATCHES = [
    (
        bytes([0x50, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xBB, 0x88, 0x00, 0x00]),
        bytes([0xE0, 0x84, 0x00, 0x00]),
    ),
    (
        bytes([0x4E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xD0, 0x84, 0x00, 0x00]),
        bytes([0xE1, 0x84, 0x00, 0x00]),
    ),
]


def find_unique(mm, pattern):
    """Find pattern in mmap, return offset. Abort if not found or found more than once."""
    off = mm.find(pattern)
    if off == -1:
        return None, "not found"
    second = mm.find(pattern, off + 1)
    if second != -1:
        return None, f"multiple matches (at 0x{off:X} and 0x{second:X})"
    return off, None


def main():
    path = sys.argv[1]
    with open(path, "r+b") as f:
        mm = mmap.mmap(f.fileno(), 0)
        for pattern, new in PATCHES:
            old_tail = pattern[-4:]
            patched_pattern = pattern[:-4] + new

            # Check if already patched
            off_patched, _ = find_unique(mm, patched_pattern)
            if off_patched is not None:
                print(f"SKIP 0x{off_patched:X}: already patched ({pattern.hex(' ')})")
                continue

            off, err = find_unique(mm, pattern)
            if err:
                print(f"FAIL: pattern {pattern.hex(' ')}: {err}")
                mm.close()
                return 1

            write_off = off + len(pattern) - 4
            mm[write_off : write_off + 4] = new
            print(
                f"OK   0x{off:X}: {old_tail.hex()} -> {new.hex()} (pattern {pattern[:8].hex(' ')}...)"
            )

        mm.close()
    return 0


sys.exit(main())
