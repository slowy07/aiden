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

kernel_thread_exec:
  push rax
  push rbx
  push rcx
  push rdx
  push rdi
  push r8
  push r11

  call kernel_memory_alloc_page
  jc .end

  call kernel_page_drain

  mov rax, KERNEL_STACK_address
  mov ebx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
  mov ecx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
  mov r11, rdi
  call kernel_page_map_logical

  mov rdi, qword [r8]
  and di, KERNEL_PAGE_mask
  add rdi, KERNEL_PAGE_SIZE_byte - (STATIC_QWORD_SIZE_byte * 0x05)

  mov rax, qword [rsp + STATIC_QWORD_SIZE_byte * 0x02]
  stosq

  mov rax, KERNEL_TASK_EFLAGS_default
  stosq

  mov rax, KERNEL_STACK_pointer
  stosq

  mov rax, KERNEL_STACK_pointer
  stosq

  mov rax, KERNEL_STRUCTURE_GDT.ds_ring0
  stosq

  mov qword [rdi - STATIC_QWORD_SIZE_byte * 0x0B], rsi

  mov rsi, cr3
  mov rdi, r11
  call kernel_page_merge
  
  mov bx, KERNEL_TASK_FLAG_active | KERNEL_TASK_FLAG_thread | KERNEL_TASK_FLAG_secured
  call kernel_task_add

.end:
  pop rdi
  pop r8
  pop rdi
  pop rdx
  pop rcx
  pop rbx
  pop rax

  ret
