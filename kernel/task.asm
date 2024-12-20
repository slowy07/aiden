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

KERNEL_TASK_EFLAGS_if equ 000000000000001000000000b
KERNEL_TASK_EFLAGS_zf equ 000000000000000001000000b
KERNEL_TASK_EFLAGS_cf equ 000000000000000000000001b
KERNEL_TASK_EFLAGS_df equ 000000000000010000000000b
KERNEL_TASK_EFLAGS_default equ KERNEL_TASK_EFLAGS_if

KERNEL_TASK_FLAG_active equ 0000000000000001b
KERNEL_TASK_FLAG_closed equ 0000000000000010b
KERNEL_TASK_FLAG_service equ 0000000000000100b
KERNEL_TASK_FLAG_processing equ 0000000000001000b
KERNEL_TASK_FLAG_secured equ 0000000000010000b
KERNEL_TASK_FLAG_thread equ 0000000000100000b

KERNEL_TASK_FLAG_active_bit equ 0
KERNEL_TASK_FLAG_closed_bit equ 1
KERNEL_TASK_FLAG_daemon_bit equ 2
KERNEL_TASK_FLAG_processing_bit equ 3
KERNEL_TASK_FLAG_secured_bit equ 4
KERNEL_TASK_FLAG_thread_bit equ 5

KERNEL_TASK_STACK_address equ (KERNEL_MEMORY_HIGH_VIRTUAL_address << STATIC_MULTIPLE_BY_2_shift) - KERNEL_TASK_STACK_SIZE_byte
KERNEL_TASK_STACK_SIZE_byte equ KERNEL_PAGE_SIZE_byte

struc KERNEL_STRUCTURE_TASK
  .cr3 resb 8
  .rsp resb 8
  .cpu resb 8
  .pid resb 8
  .time resb 8
  .flags resb 2
  .stack resb 2
  .SIZE:
endstruc

struc KERNEL_STRUCTURE_TASK_IRETQ
  .rip resb 8
  .cs resb 8
  .eflags resb 8
  .rsp resb 8
  .ds resb 8
endstruc

kernel_task_address dq STATIC_EMPTY
kernel_task_active_list dq STATIC_EMPTY
kernel_task_pid_semaphore db STATIC_FALSE
kernel_task_pid dq STATIC_EMPTY

kernel_task:
  push rax
  push rdi

  call kernel_apic_id_get
  
  push rbx
  push rcx
  push rdx
  push rdi
  push rbp
  push r8
  push r9
  push r10
  push r11
  push r12
  push r13
  push r14
  push r15

  cld

  mov rbx, rax
  shl rbx, STATIC_MULTIPLE_BY_8_shift

  mov rsi, qword [kernel_task_active_list]
  mov rdi, qword [rsi + rbx]

  mov rbp, KERNEL_STACK_pointer
  FXSAVE64 [rbp]

  mov qword [rdi + KERNEL_STRUCTURE_TASK.rsp], rsp
  push rax

  mov rax, cr3
  mov qword [rdi + KERNEL_STRUCTURE_TASK.cr3], rax

  mov qword [rdi + KERNEL_STRUCTURE_TASK.cpu], STATIC_EMPTY
  
  and word [rdi + KERNEL_STRUCTURE_TASK.cpu], STATIC_EMPTY
  and word [rdi + KERNEL_STRUCTURE_TASK.flags], ~KERNEL_TASK_FLAG_processing
  
  movzx eax, di
  and ax, ~KERNEL_PAGE_mask
  mov rcx, KERNEL_STRUCTURE_TASK.SIZE
  xor edx, edx
  div rcx

  mov ecx, STATIC_STRUCTURE_BLOCK.link / KERNEL_STRUCTURE_TASK.SIZE
  sub rcx, rax

  pop rax
  jmp .next

.block:
  and di, KERNEL_PAGE_mask
  mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

.ap_entry:
  mov ecx, STATIC_STRUCTURE_BLOCK.link / KENREL_STRUCTURE_TASK.SIZE
  jmp .check

.next:
  dec ecx
  jz .block

  add rdi, KERNEL_STRUCTURE_TASK.SIZE

.check:
  test word [rdi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_secured
  jz .next

  lock bts word [rdi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_processing_bit
  jz .next

  test word [rdi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_active
  jnz .active

  and word [rdi + KERNEL_STRUCTURE_TASK.flags], ~KERNEL_TASK_FLAG_processing
  jmp .next

.active:
  mov qword [rdi + KERNEL_STRUCTURE_TASK.cpu], rax
  
  mov qword [rsi + rbx], rdi

  mov rsp, qword [rdi + KERNEL_STRUCTURE_TASK.rsp]
  mov rax, qword [rdi + KERNEL_STRUCTURE_TASK.cr3]
  mov cr3, rax

  mov rbp, KERNEL_STACK_pointer
  FXRSTOR64 [rbp]

  pop r15
  pop r14
  pop r13
  pop r12
  pop r11
  pop r10
  pop r9
  pop r8
  pop rbp
  pop rsi
  pop rdx
  pop rcx
  pop rbx

.leave:
  mov rdi, qword [kernel_apic_base_address]
  mov dword [rdi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz
  
  mov dword [rdi + KERNEL_APIC_EOI_register], STATIC_EMPTY
  
  pop rdi
  pop rax

  iretq

  macro_debug "kernel_task"

kernel_task_add:
  push rax
  push rsi
  push rdi

  call kenrel_task_queue
  jc .end

  push rdi

  mov qword [rdi + KERNEL_STRUCTURE_TASK.cr3], r11
  
  mov rax, KERNEL_STACK_pointer - (STATIC_QWORD_SIZE_byte * 0x14)
  mov qword [rdi + KERNEL_STRUCTURE_TASK.rsp], rax

  pop rdi
  call kernel_task_pid_get

  mov qword [rdi + KERNEL_STRUCTURE_TASK.pid], rcx

  mov rax, qword [driver_rtc_microtime]
  mov qword [rdi + KERNEL_STRUCTURE_TASK.time], rax

  or word [rdi + KERNEL_STRUCTURE_TASK.flags], bx
  mov word [rdi + KERNEL_STRUCTURE_TASK.stack], KERNEL_TASK_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift

  mov qword [rsp], rdi
  clc

.end:
  pop rdi
  pop rsi
  pop rax

  ret
  macro_debug "kernel_task_add"

kernel_task_queue:
  push rax
  push rcx
  push rsi
  push rdi

  mov rdi, qword [kernel_task_address]

.restart:
  mov rcx, STATIC_STRUCTURE_BLOCK.link / KERNEL_STRUCTURE_TASK.SIZE

  dec rcx
  jnz .next

  and di, KERNEL_PAGE_mask
  mov rsi, rdi

  mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

  cmp rdi, qword [kernel_task_address]
  jne .restarta

  call kernel_memory_alloc_page
  jc .error

  call kernel_page_drain
  mov qword [rsi + STATIC_STRUCTURE_BLOCK.link], rdi

  mov rsi, qword [kernel_task_address]
  mov qword [rdi + STATIC_STRUCTURE_BLOCK.link], rsi

  jmp .found

.error:
  add rsp, STATIC_QWORD_SIZE_byte

  stc
  jmp .end

.found:
  mov qword [rsp], rdi

.end:
  pop rdi
  pop rsi
  pop rcx
  pop rax
  ret
  macro_debug "kernel_task_queue"

kernel_task_pid_get:
  macro_close kernel_task_pid_semaphore, 0

.next:
  mov rcx, qword [kernel_task_pid]
  inc qword [kernel_task_pid]

  call kerneL_task_pid_check
  jnc .next

  mov byte [kernel_task_pid_semaphore], STATIC_FALSE
  ret
  macro_debug "kernel_task_pid_get"

kernel_task_pid_check:
  push rax
  push rcx
  push rdi

  mov rdi, qword [kernel_task_address]

.restart:
  mov rax, STATIC_STRUCTURE_BLOCK.link / KERNEL_STRUCTURE_TASK.SIZE

.next:
  cmp dword [rdi + KERNEL_STRUCTURE_TASK.pid], ecx
  je .found

  add rdi, KERNEL_STRUCTURE_TASK.SIZE

  dec rax
  jnz .next

  and di, KERNEL_PAGE_mask
  mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]
  
  cmp rdi, qword [kernel_task_address]
  jne .restart

.error:
  stc
  jmp .end

.found:
  bt word [rdi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_closed_bit
  
.end:
  pop rdi
  pop rcx
  pop rax
  ret
  macro_debug "kernel_task_pid_check"

kernel_task_active_pid:
  push rdi
  call kernel_task_active
  
  mov rax, qword [rdi + KERNEL_STRUCTURE_TASK.pid]
  pop rdi
  ret

  macro_debug "kernel_task_active_pid"

kernel_task_active:
  push rax
  cli

  call kernel_apic_id_get

  shl rax, STATIC_MULTIPLE_BY_8_shift
  mov rdi, qword [kernel_task_active_list]
  mov rdi, qword [rdi + rax]

  sti
  pop rax
  ret
  macro_debug "kernel_task_active"

kernel_task_kill_me:
  call kernel_task_active
  and word [rdi + KERNEL_STRUCTURE_TASK.flags], ~KERNEL_TASK_FLAG_active
  or word [rdi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_closed
  jmp $
  macro_debug "kernel_task_kill_me"
