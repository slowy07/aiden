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

  call aiden_line_a20_check
  jz .unlocked

  mov ax, 0x2401
  int 0x15

  call aiden_line_a20_check
  jz .unlocked

  in al, 0x92
  or al, 2
  out 0x92, al

  call aiden_line_a20_check
  jz .unlocked

  in al, 0xEE

  call aiden_line_a20_check
  jz .unlocked

  cli

  call aiden_ps2_keyboard_in

  mov al, 0xAD
  out 0x64, al

  call aiden_ps2_keyboard_in
  
  mov al, 0xD0
  out 0x64, al

  call aiden_ps2_keyboard_out

  in al, 0x60

  push ax

  call aiden_ps2_keyboard_in

  mov al, 0xD1
  out 0x64, al

  call aiden_ps2_keyboard_in

  pop ax

  or al, 2
  out 0x60, al

  call aiden_ps2_keyboard_in

  mov al, 0xAE
  out 0x64, al

  call aiden_ps2_keyboard_in

  sti

  mov si, STATIC_AIDEN_ERROR_a20

  call aiden_line_a20_check
  jnz aiden_panic

.unlocked:
  mov ax, 0x0003
  int 0x10

  mov ah, 0x42
  mov si, aiden_table_disk_address_packet
  int 0x13

  mov si, STATIC_AIDEN_ERROR_disk
  
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

  mov ax, 0x4F00
  mov si, STATIC_AIDEN_ERROR_video
  mov di, STATIC_AIDEN_video_vga_info_block
  int 0x10

  test ax, 0x4F00
  jnz aiden_panic
  
  mov esi, dword [di + STATIC_AIDEN_VIDEO_STRUCTURE_VGA_INFO_BLOCK.video_mode_ptr]

.loop:
  cmp word [esi], 0xFFFF
  je .error

  mov ax, 0x4F01
  mov cx, word [esi]
  moc di, STATIC_AIDEN_video_mode_info_block
  int 0x10

  cmp word [di + STATIC_AIDEN_VIDEO_STRUCTURE_MODE_INFO_BLOCK.x_resolution], STATIC_AIDEN_VIDEO_WIDTH_pixel
  jne .next

  cmp word [di + STATIC_AIDEN_VIDEO_STRUCTURE_MODE_INFO_BLOCK.y_resolution], STATIC_AIDEN_VIDEO_HEIGHT_pixel
  jne .next

  cmp byte [di + STATIC_AIEDN_VIDEO_STRUCTURE_MODE_INFO_BLOCK.bits_per_pixel], STATIC_AIDEN_VIDEO_DEPTH_bit
  je .found

.next:
  add esi, STATIC_WORD_SIZE_byte
  jmp .loop

.error:
  mov si, STATIC_AIDEN_ERROR_video
  jmp aiden_panic

.found:
  mov ax, 0x4F02
  mov bx, word [esi]
  or bx, STATIC_AIDEN_VIDEO_MODE_linear | STATIC_AIDEN_VIDEO_MODE_clean
  int 0x10

  test ah, ah
  jnz .error

  cli

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

aiden_line_a20_check:
  push ds

  mov ax, 0xFFFF
  mov ds, ax

  mov ebx, dword [ds:STATIC_AIDEN_address + 0x10]
  pop ds
  test ebx, dword [ds:STATIC_AIDEN_address]
  ret

aiden_ps2_keyboard_in:
  in al, 0x64
  test al, 2
  jnz aiden_ps2_keyboard_in
  ret

aiden_ps2_keyboard_out:
  in al, 0x64
  test al, 1
  jnz aiden_ps2_keyboard_out
  ret

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

  mov ebx, STATIC_AIDEN_multiboot_header
  jmp STATIC_AIDEN_kernel_address << STATIC_SEGMENT_to_pointer << STATIC_SEGMENT_to_pointer

align 0x04
aiden_table_disk_address_packet:
  db 0x10
  db STATIC_EMPTY
  dw (file_kernel_end - file_kernel) / STATIC_SECTOR_SIZE_byte
  dw 0x0000
  dw STATIC_AIDEN_kernel_address
  dq 0x0000000000000001

align 0x10
aiden_table_gdt_32bit:
  dq STATIC_EMPTY
  dq 0000000011001111100110000000000000000000000000001111111111111111b
  dq 0000000011001111100100100000000000000000000000001111111111111111b
aiden_table_gdt_32bit_end:

aiden_header_gdt_32bit:
  dw aiden_table_gdt_32bit_end - aiden_table_gdt_32bit - 0x01
  dd aiden_table_gdt_32bit

times 510 - ($ - $$) db STATIC_EMPTY
                     dw STATIC_AIDEN_magic

file_kernel:
  incbin "build/kernel"
  align STATIC_SECTOR_SIZE_byte
file_kernel_end:
