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

KERNEL_INIT_LONG_MODE_PML4_TABLE_address equ 0x0000A000
KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte equ 0x1000
KERNEL_INIT_LONG_MODE_PAGE_SIZE_2MiB_byte equ 0x00200000
  
KERNEL_INIT_LONG_MODE_PAGE_FLAG_available equ 00000001b
KERNEL_INIT_LONG_MODE_PAGE_FLAG_writeable equ 00000010b
KERNEL_INIT_LONG_MODE_PAGE_FLAG_2MiB_size equ 10000000b
KERNEL_INIT_LONG_MODE_PAGE_FLAG_default equ KERNEL_INIT_LONG_MODE_PAGE_FLAG_available | KERNEL_INIT_LONG_MODE_PAGE_FLAG_writeable

[BITS 32]

  xor eax, eax
  mov ecx, (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x06) / 0x04
  mov edi, KERNEL_INIT_LONG_MODE_PML4_TABLE_address
  rep stosd

  mov dword [KERNEL_INIT_LONG_MODE_PML4_TABLE_address], KERNEL_INIT_LONG_MODE_PML4_TABLE_address + KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte + KERNEL_INIT_LONG_MODE_PAGE_FLAG_default

  mov dword [KERNEL_INIT_LONG_MODE_PML4_TABLE_address + KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte], KERNEL_INIT_LONG_MODE_PML4_TABLE_address + (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x02) + KERNEL_INIT_LONG_MODE_PAGE_FLAG_default
  mov dword [KERNEL_INIT_LONG_MODE_PML4_TABLE_address + KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte + 0x08],	KERNEL_INIT_LONG_MODE_PML4_TABLE_address + (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x03) + KERNEL_INIT_LONG_MODE_PAGE_FLAG_default
  mov dword [KERNEL_INIT_LONG_MODE_PML4_TABLE_address + KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte + 0x10],	KERNEL_INIT_LONG_MODE_PML4_TABLE_address + (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x04) + KERNEL_INIT_LONG_MODE_PAGE_FLAG_default
  mov dword [KERNEL_INIT_LONG_MODE_PML4_TABLE_address + KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte + 0x18], KERNEL_INIT_LONG_MODE_PML4_TABLE_address + (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x05) + KERNEL_INIT_LONG_MDE_PAGE_FLAG_default

  mov eax, KERNEL_INIT_LONG_MODE_PAGE_FLAG_default + KERNEL_INIT_LONG_MODE_PAGE_FLAG_2MiB_size
  mov ecx, 512 * 0x04
  mov edi, KERNEL_INIT_LONG_MODE_PML4_TABLE_address + (KERNEL_INIT_LONG_MODE_PAGE_SIZE_4KiB_byte * 0x02)

.next:
  stosd
  add edi, 0x04

  add eax, KERNEL_INIT_LONG_MODE_PAGE_FLAG_2MiB_size
  dec ecx
  jnz .next

  lgdt [kernel_init_header_gdt_64bit]
  mov eax, 1010100000b
  mov cr4, eax

  mov eax, KERNEL_INIT_LONG_MODE_PML4_TABLE_address
  mov cr3, eax

  mov ecx, 0xC0000080
  rdmsr
  or eax, 100000000b
  wrmsr

  mov eax, cr0
  or eax, 0x80000001
  mov cr0, eax

  jmp 0x0008:kernel_init_long_mode

align 0x08
kernel_init_table_gdt_64bit:
  dq STATIC_EMPTY
  dq 0000000000100000100110000000000000000000000000000000000000000000b
  dq 0000000000100000100100100000000000000000000000000000000000000000b
kernel_init_table_gdt_64bit_end:

kernel_init_header_gdt_64_bit:
  dw kernel_init_table_gdt_64bit_end - kernel_init_table_gdt_64bit
  dd kernel_init_table_gdt_64bit
