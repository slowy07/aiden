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

  %include "aiden/config.asm"

[BITS 16]
[ORG STATIC_AIDEN_address]

aiden:
  cli
  jmp 0x0000:.repair_cs

.repair_cs:
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax

  mov sp, STATIC_AIDEN_stack
  cld

  mov al, STATIC_EMPTY
  out DRIVER_PIT_PORT_comamnd, al

  sti

  mov ax, 0x2401
  int 0x15

  in al, 0x92
  or al, 2
  out 0x92, al

  mov ax, 0x003
  int 0x10

  mov ah, 0x42
  mov si, aiden_table_disk_address_packet
  int 0x13

  mov si, STATIC_AIDEN_ERROR_device
  
  jc aiden_panic

  xor ebx, ebx
  mov edx, 0x534D4150
  
  mov si, STATIC_AIDEN_ERROR_memory
  mvo edi, STATIC_AIDEN_memory_map

.memory:
  mov eax, 0x14
  stosd

  mov eax, 0xE820
  mov ecx, 0x14
  int 0x15

  jc aiden_panic

  add edi, 0x14

  test ebx, ebx
  jnz .memory

  mov al, 0xFF
  out DRIVER_PIC_PORT_SLAVE_data, al
  out DRIVER_PIC_PORT_MASTER_data, al

  cli

%if STATIC_AIDEN_bit_mode = 16
  mov ax, STATIC_AIDEN_kernel_address
  mov ds, ax
  mov es, ax
  sti
  mov ebx, STATIC_AIDEN_memory_map

  jmp STATIC_AIDEN_kernel_address:0x0000
%endif

  lgdt [aiden_header_gdt_32bit]
  mov eax, cr0
  bts eax, 0
  mov cr0, eax

  jmp long 0x0008:aiden_protected_mode

aiden_panic:
  mov ax, 0xB800
  mov ds, ax
  
  mov word [ds:0x0000], si
  jmp $

[BITS 32]

aiden_protected_mode:
  mov ax, 0x10
  mov ds, ax
  mov es, ax
  mov ss, ax

  mov ecx, edi
  sub ecx, STATIC_AIDEN_memory_map
  
  mov edi, STATIC_AIDEN_multiboot_header

  mov dword [edi + STATIC_MULTIBOOT_header.flags], STATIC_MULTIBOOT_HEADER_FLAG_memory_map

  mov dword [edi + STATIC_MULTIBOOT_header.mmap_header], ecx
  mov dword [edi + STATIC_MULTIBOOT_header.mmap_addr], STATIC_AIDEN_memory_map

  mov esi, STATIC_AIDEN_kernel_address << STATIC_SEGMENT_to_pointer
  mov edi, STATIC_AIDEN_kernel_address << STATIC_SEGMENT_to_pointer << STATIC_SEGMENT_to_pointer
  mov ecx, (file_kernel_end - file_kernel) / 0x04
  rep movsd

%if STATIC_AIDEN_bit_mode = 32
  mov ebx, STATIC_AIDEN_multiboot_header
  jmp STATIC_AIDEN_kernel_address << STATIC_SEGMENT_to_pointer << STATIC_SEGMENT_to_pointer
%endif

  xor eax, eax
  mov ecx, (STATIC_PAGE_SIZE_4KiB_byte * 0x06) / 0x04
  mov edi, STATIC_PML4_TABLE_address
  rep stosd

  mov dword [STATIC_PML4_TABLE_address], STATIC_PML4_TABLE_address + STATIC_PAGE_SIZE_4KiB_byte + STATIC_PAGE_FLAG_default

  mov dword [STATIC_PML4_TABLE_address + STATIC_PAGE_SIZE_4KiB_byte], STATIC_PML4_TABLE_address + (STATIC_PAGE_SIZE_4KiB_byte * 0x02) + STATIC_PAGE_FLAG_default
  mov dword [STATIC_PML4_TABLE_address + STATIC_PAGE_SIZE_4KiB_byte + 0x08], STATIC_PML4_TABLE_address + (STATIC_PAGE_SIZE_4KiB_byte * 0x03) + STATIC_PAGE_FLAG_default
  mov dword [STATIC_PML4_TABLE_address + STATIC_PAGE_SIZE_4KiB_byte + 0x10], STATIC_PML4_TABLE_address + (STATIC_PAGE_SIZE_4KiB_byte * 0x04) + STATIC_PAGE_FLAG_default
  mov dword [STATIC_PML4_TABLE_address + STATIC_PAGE_SIZE_4KiB_byte + 0x18], STATIC_PML4_TABLE_address + (STATIC_PAGE_SIZE_4KiB_byte * 0x05) + STATIC_PAGE_FLAG_default

  mov eax, STATIC_PAGE_FLAG_default + STATIC_PAGE_FLAG_2MiB_size
  mov ecx, 512 * 0x04
  mov edi, STATIC_PML4_TABLE_address + (STATIC_PAGE_SIZE_4KiB_byte * 0x02)
  
.next:
  stosd
  add edi, 0x04

  add eax, STATIC_PAGE_FLAG_2MiB_size
  dec ecx
  jnc .next

  lgdt [aiden_header_gdt_64bit]
  mov eax, 1010100000b

  mov cr4, eax

  mov eax, STATIC_PML4_TABLE_address
  mov cr3, eax
  
  mov ecx, 0xC0000080
  rdmsr
  or eax, 100000000b
  wrmsr

  mov eax, cr0
  or eax, 0x80000001
  mov cr0, eax

  jmp 0x0008:aiden_long_mode

[BITS 64]

aiden_long_mode:
  mov ebx, STATIC_AIDEN_multiboot_header
  jmp STATIC_AIDEN_kernel_address << STATIC_SEGMENT_to_pointer << STATIC_SEGMENT_to_pointer
  ret

align 0x04
aiden_table_disk_address_packet:
  db 0x10
  db STATIC_EMPTY
  dw (file_kernel_end - file_kernel) / STATIC_SECTOR_SIZE_byte
  dw 0x0000
  dw STATIC_AIDEN_kernel_address
  dq 0x0000000000000001

align 0x04
aiden_table_gdt_32bit:
  dw aiden_table_gdt_32bit_end - aiden_table_gdt_32bit - 0x01
  dd aiden_table_gdt_32bit
aiden_table_gdt_32bit_end:

align 0x08
aiden_table_gdt_64bit:
  dq STATIC_EMPTY
  dq 0000000000100000100110000000000000000000000000000000000000000000b
  dq 0000000000100000100100100000000000000000000000000000000000000000b
aiden_table_gdt_64bit_end:

aiden_header_gdt_64bit:
  dw aiden_table_gdt_64bit_end - aiden_table_gdt_64bit - 0x01
  dd aiden_table_gdt_64bit

times 510 - ($ - $$) db STATIC_EMPTY
                     dw STATIC_AIDEN_magic

file_kernel:
  incbin "build/kernel"
  align STATIC_SECTOR_SIZE_byte
file_kernel_end:
