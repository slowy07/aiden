MULTIBOOT_HEADER_MAGIC equ 0x1BADB002

MULTIBOOT_HEADER_FLAG_align equ 1 << 0
MULTIBOOT_HEADER_FLAG_memory_map equ 1 << 1
MULTIBOOT_HEADER_FLAG_video equ 1 << 2
MULTIBOOT_HEADER_FLAG_header equ 1 << 16
MULTIBOOT_HEADER_FLAG_default equ MULTIBOOT_HEADER_FLAG_align | MULTIBOOT_HEADER_FLAG_memory_map | MULTIBOOT_HEADER_FLAG_video | MULTIBOOT_HEADER_FLAG_header

MULTIBOOT_HEADER_CHECKSUM equ -(MULTIBOOT_HEADER_FLAG_default + MULTIBOOT_HEADER_MAGIC)

struc         MULTIBOOT_HEADER
.flags        resb 4
.unsupported0 resb 40
.mmap_length resb 4
.mmap_addr resb 4
.unsupported1 resb 36
.framebuffer_addr resb 8
.framebuffer_pitch resb 4
.framebuffer_width resb 4
.framebuffer_height resb 4
.framebuffer_bpp resb 1
.framebuffer_type resb 1
.color_info resb 6
endstruc

align 0x04

multiboot_header:
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAG_default
	dd MULTIBOOT_HEADER_CHECKSUM
	dd multiboot_header
	dd init
	dd STATIC_EMPTY
	dd STATIC_EMPTY
	dd init
	dd STATIC_EMPTY
	dd MULTIBOOT_VIDEO_WIDTH_pixel
	dd MULTIBOOT_VIDEO_HEIGHT_pixel
	dd KERNEL_VIDEO_DEPTH_bit

	align 0x10

header_end:
