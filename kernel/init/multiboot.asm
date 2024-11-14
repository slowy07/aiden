;MIT License
;
;Copyright (c) 2024 arfy slowy
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

HEADER_MAGIC equ 0x1BADB002
HEADER_FLAG_align equ 1 << 0
HEADER_FLAG_memory_map equ 1 << 1
HEADER_FLAG_header equ 1 << 16
HEADER_FLAG_default equ HEADER_FLAG_align | HEADER_FLAG_memory_map | HEADER_FLAG_header

HEADER_CHECKSUM equ -(HEADER_FLAG_default + HEADER_MAGIC)

struc HEADER_multiboot
  .flags resb 4
  .unsupported0 resb 40
  .mmap_length resb 4
  .mmap_addr resb 4
  .unsupported1 resb 36
  .framebuffer_addr resb 8
  .framebuffer_pitch resb 4
  .framebuffer_width resb 4
  .framebuffer_height resb 4
  .framebuffe_bpp resb 1
  .framebuffer_type resb 1
  .color_info resb 6
endstruc

align 0x04
header:
  dd HEADER_MAGIC
  dd HEADER_FLAG_default
  dd HEADER_CHECKSUM
  dd header
  dd init
  dd STATIC_EMPTY
  dd STATIC_EMPTY
  dd init
  dd STATIC_EMPTY
  dd KERNEL_VIDEO_WIDTH_pixel
  dd KERNEL_VIDEO_HEIGHT_pixel
  dd KERNEL_VIDEO_DEPTH_bit
align 0x10
header_end:
