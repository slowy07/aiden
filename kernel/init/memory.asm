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

KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_memory_map equ 6

struct KERNEL_INIT_MEMORY_MULTIBOOT_HEADER
  .flags resb 4
  .unsupported resb 4
  .mmap_length resb 4
  .mmap_addr resb 4
endstruc

struc KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP
  .size resb 4
  .address resb 8
  .limit resb 8
  .type resb 4
  .SIZE:
endstruc

kernel_init_memory:
  bt dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.flags], KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_memory_map
  jnc kernel_panic

  mov ecx, dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.mmap_length]
  mov ebx, dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.mmap_addr]

.search:
  cmp qword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.address]
  je .found

  add ebx, KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.SIZE
  jnz .search
  mov ecx, kernel_init_string_error_memory_end - kernel_init_string_error_memory
  mov rsi, kernel_init_string_error_memory
  call kernel_panic

.found:
  mov rcx, qword [rbx + KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.limit]
  shr rcx, STATIC_DIVIDE_BY_PAGE_shift

  mov qword [kernel_page_total_count], rcx
  mov qword [kernel_page_free_count], rcx

  mov rdi, kernel_end
  call library_page_align_up

  mov qword [kernel_memory_map_address], rdi

  shr rcx, STATIC_DIVIDE_BY_8_shift

  push rcx

  call library_page_from_size
  call kernel_page_drain_few

  pop rcx
  mov al, STATIC_MAX_unsigned
  rep stosb

  mov qword [kernel_memory_map_address_end], rdi

  call library_page_align_up
  sub rdi, KERNEL_BASE_address
  shr rdi, STATIC_DIVIDE_BY_PAGE_shift

  mov rcx, rdi
  call kernel_memory_alloc

