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

[BITS 16]
[ORG 0x8000]

bott:
  cli
  jmp 0x0000:.repair_cs

.repair_cs:
  xor ax, ax
  mov ds, ax
  mov es, ax
  
  cld

  lgdt [boot_header_gdt_32bit]
  
  mov eax, cr0
  bts eax, 0
  mov cr0, eax

  jmp long 0x0008:boot_protected_mode

[BITS 32]

boot_protected_mode:
  mov ax, 0x10
  mov ds, ax
  mov es, ax

  jmp 0x00100000

align 0x10
boot_table_gdt_32bit:
  dq 0x0000000000000000
  dq 0000000011001111100110000000000000000000000000001111111111111111b
  dq 0000000011001111100100100000000000000000000000001111111111111111b
boot_table_gdt_32bit_end:

boot_header_gdt_32bit:
  dw boot_table_gdt_32bit_end - boot_table_gdt_32bit - 0x01
  dd boot_table_gdt_32bit
boot_end:
