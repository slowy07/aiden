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

kernel_init_page:
  call kernel_memory_alloc_page
  jc kernel_init_panic_low_memory
  
  call kernel_page_drain
  mov qword [kernel_page_pml4_address], rdi

  inc qword [kernel_page_paged_count]

  mov eax, KERNEL_BASE_address
  mov bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
  mov rcx, qword [kernel_page_total_count]
  mov r11, rdi
  call kernel_page_map_pyhsical
  jc kernel_init_panic_low_memory
  
  mov rax, KERNEL_STACK_address
  mov ecx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
  call kernel_page_map_logical
  jc kernel_init_panic_low_memory
  
  mov rax, KERNEL_VIDEO_BASE_address
  or bx, KERNEL_PAGE_FLAG_write_through | KERNEL_PAGE_FLAG_cache_disable
  mov ecx, KERNEL_VIDEO_SIZE_byte
  call library_page_from_size
  call kernel_page_map_pyhsical
  jc kernel_init_panic_low_memory

  mov rax, qword [kernel_apic_base_address]
  mov bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
  mov ecx, dword [kernel_apic_size]
  call library_page_from_size
  call kernel_page_map_pyhsical
  jc kernel_init_panic_low_memory

  mov eax, dword [kernel_io_apic_base_address]
  mov ecx, KERNEL_PAGE_SIZE_byte >> KERNEL_PAGE_SIZE_shift
  call kernel_page_map_pyhsical
  jc kernel_init_panic_low_memory

  mov rax, rdi
  mov cr3, rax

  mov rsp, KERNEL_STACK_pointer
