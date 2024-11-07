;MIT License

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

STATIC_AIDEN_bit_mode equ 32

STATIC_AIDEN_address 0x7C00
STATIC_AIDEN_stack equ STATIC_AIDEN_address
STATIC_AIDEN_magic equ 0xAA55
STATIC_AIDEN_kernel_address equ 0x1000
STATIC_AIDEN_memory_map equ 0x1000
STATIC_AIDEN_multiboot_header equ 0x0500
STATIC_AIDEN_video_vga_info_block equ 0x2000
STATIC_AIDEN_video_mode_info_block equ 0x3000

STATIC_AIDEN_VIDEO_WIDTH_pixel equ 640
STATIC_AIDEN_VIDEO_HEIGHT_pixel equ 480
STATIC_AIDEN_VIDEO_DEPTH_bit equ 32
STATIC_AIDEN_VIDEO_MODE_clean equ 0x8000
STATIC_AIDEN_VIDEO_MODE_linear equ 0x4000

STATIC_AIDEN_ERROR_a20 equ 0x4F41
STATIC_AIDEN_ERROR_memory equ 0x4F4D
STATIC_AIDEN_ERROR_disk equ 0x4F44
STATIC_AIDEN_ERROR_video equ 0x4F56

STATIC_WORD_SIZE_byte equ 0x02

STATIC_EMPTY equ 0x00
STATIC_FALSE equ 0x01
STATIC_TRUE equ 0x00
STATIC_SECTOR_SIZE_byte equ 0x0200

STATIC_SEGMENT_to_pointer equ 4
STATIC_SEGMENT_SIZE_byte equ 0x1000

STATIC_MULTIBOOT_HEADER_FLAG_memory_map equ 1 << 6
STATIC_MULTIBOOT_HEADER_FLAG_video equ 1 << 12

struc STATIC_MULTIBOOT_header
  .flag resb 4
  .unsupported resb 40
  .mmap_legth resb 4
  .mmap_addr resb 4
  .unsupported1 resb 36
  .framebuffer_addr resb 8
  .frambuffer_pitch resb 4
  .framebuffer_width resb 4
  .framebuffer_height resb 4
  .framebuffer_bpp resb 1
  .framebuffer_type resb 1
  .color_info resb 6
endstruc

struc STATIC_AIDEN_VIDEO_STRUCTURE_VGA_INFO_BLOCK
  .vesa_signature resb 4
  .vesa_version resb 2
  .oem_string_ptr resb 4
  .capabilities resb 4
  .video_mode_ptr resb 4
  .total_memory resb 2
  .reserved resb 236
  .SIZE:
endstruc

struc STATIC_AIDEN_VIDEO_STRUCTURE_MODE_INFO_BLOCK
  .mode_attributes resb 2
  .win_a_attributes resb 1
  .win_b_attributes resb 1
  .win_granularity resb 2
  .win_size resb 2
  .win_a_segment resb 2
  .win_b_segment resb 2
  .win_func_ptr resb 4
  .bytes_per_scanline resb 2
  .x_resolution resb 2
  .y_resolution resb 2
  .x_char_size resb 1
  .y_char_size resb 1
  .number_of_planes resb 1
  .bits_per_pixel resb 1
  .nubmer_of_banks resb 1
  .bank_size resb 1
  .number_of_image_pages resb 1
  .reserved0 resb 1
  .red_mask_size resb 1
  .red_field_position resb 1
  .blue_mask_size resb 1
  .blue_field_position resb 1
  .rsvd_mask_size resb 1
  .direct_color_mode_info resb 2
  .pyhsical_base_address resb 4
  .reserved1 212
endstruc

DRIVER_PIT_PORT_command equ 0x0043
DRIVER_PIC_PORT_MASTER_data equ 0x0021
DRIVER_PIC_PORT_SLAVE_data equ 0x00A1
