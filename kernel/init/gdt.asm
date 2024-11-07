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

struc KERNEL_STRUCTURE_GDT_HEADER
  .limit resb 2
  .address resb 8
endstruc

struc KERNEL_STRUCTURE_GDT
  .null resb 8
  .cs_ring0 resb 8
  .ds_ring0 resb 8
  .cs_ring3 resb 8
  .ds_ring3 resb 8
  .tss resb 8
  .SIZE:
endstruc:

kernel_init_gdt:
  call kernel_memory_alloc_page
  jc kernel_init_panic_low_memory

  call kernel_page_drain
  mov qword [kernel_gdt_header + KERNEL_STRUCTURE_GDT_HEADER.address], rdi

  xor eax, eax
  stosq

  mov rax, 0000000000100000100110000000000000000000000000000000000000000000b
  stosq

  mov rax, 0000000000100000100100100000000000000000000000000000000000000000b
  stosq

  mov rax, 0000000000100000111110000000000000000000000000000000000000000000b
  stosq

  mov rax, 0000000000100000111100100000000100000000000000000000000000000000b
  stosq
  
  and di, ~KERNEL_PAGE_drain
  mov word [kernel_gdt_tss_bsp_selector], di

  mov cx, word [kernel_apic_count]
  mov rsi, kernel_apic_id_table

.loop:
  lodsb
  and eax, STATIC_BYTE_mask
  shl eax, STATIC_MULTIPLE_BY_16_shift
  
  mv rdi, qword [kernel_gdt_header + KENREL_STRUCTURE_GDT_HEADER.address]
  add rdi, rax
  add di, word [kernel_gdt_tss_bsp_selector]
  
  mov ax, kernel_gdt_tss_table_end - kernel_gdt_tss_table
  stosw

  mov rax, kernel_gdt_tss_table
  stosw
  shr rax, 16
  stosb

  push rax

  mov al, 10001001b
  stsob
  xor al, al
  stosb

  pop rax

  shr rax, 8
  stosb
  
  shr rax, 8
  stosd

  xor rax, rax
  stosd

  dec cx
  jnz .loop

  lgdt [kernel_gdt_header]
  ltr word [kernel_gdt_tss_bsp_selector]
