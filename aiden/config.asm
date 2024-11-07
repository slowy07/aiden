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
STATIC_AIDEN_stack equ 0x8000
STATIC_AIDEN_magic equ 0xAA55
STATIC_AIDEN_kernel_address equ 0x1000
STATIC_AIDEN_memory_map equ 0x1000
STATIC_AIDEN_multiboot_header equ 0x0500

STATIC_AIDEN_ERROR_memory equ 0x4F4D
STATIC_AIDEN_ERROR_device equ 0x4F44

STATIC_EMPTY equ 0x00
STATIC_FALSE equ 0x01
STATIC_TRUE equ 0x00
STATIC_SECTOR_SIZE_byte equ 0x0200

STATIC_SEGMENT_to_pointer equ 4

STATIC_PML4_TABLE_address equ 0x0000A000
STATIC_PAGE_SIZE_4KiB_byte equ 0x1000
STATIC_PAGE_SIZE_2MiB_byte equ 0x00200000

STATIC_PAGE_FLAG_available equ 00000001b
STATIC_PAGE_FLAG_writeable equ 00000010b
STATIC_PAGE_FLAG_2MiB_size equ 10000000b
STATIC_PAGE_FLAG_default equ STATIC_PAGE_FLAG_available | STATIC_PAGE_FLAG_writeable

STATIC_MULTIBOOT_HEADER_FLAG_memory_map equ 01000000b

struc STATIC_MULTIBOOT_header
  .flag resb 4
  .unsupported resb 40
  .mmap_legth resb 4
  .mmap_addr resb 4
endstruc

DRIVER_PIT_PORT_command equ 0x0043
DRIVER_PIT_COMMAND_access_low_high equ 0011000b
DRIVER_PIC_PORT_MASTER_data equ 0x0021
DRIVER_PIC_PORT_SLAVE_data equ 0x00A1
