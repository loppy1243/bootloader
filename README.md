# Simpler Booloader
Very simple two stage bootloader written in x86 assembly for NASM. Just prints "Hello,
World!".

To build, have `nasm` in your `$PATH` and run `make`. This creates `boot.bin`, which assumes
the MBR format and must be placed starting at the first sector of the disk to be booted from.
