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

KERNEL_IPC_SIZE_page_default equ 1
KERNEL_IPC_ENTRY_limit equ (KERNEL_IPC_SIZE_page_default << KERNEL_PAGE_SIZE_shift) / KERNEL_IPC_STRUCTURE_LIST.SIZE
; setting info 100ms
KERNEL_IPC_TTL_default equ DRIVER_RTC_Hz / 10

struc KERNEL_IPC_STRUCTURE_LIST
  .ttl resb 8
  .pid_source resb 8
  .pid_destination resb 8
  .data:
  .size resb 8
  .pointer resb 8
  .other resb 24
  .SIZE:
endstruc

kernel_ipc_semaphore db STATIC_FALSE
kernel_ipc_base_address dq STATIC_EMPTY
kernel_ipc_entry_count dq STATIC_EMPTY

kernel_ipc_insert:
  push rax
  push rdx
  push rsi
  push rdi
  push rcx

  call kernel_task_active
  mov rdx, qword [rdi + KERNEL_STRUCTURE_TASK.pid]

  macro_close kernel_ipc_semaphore, 0

.wait:
  cmp qword [kernel_ipc_entry_count], KERNEL_IPC_ENTRY_limit
  je .wait

.reload:
  mov rax, qword [driver_rtc_microtime]
  mov rcx, KERNEL_IPC_ENTRY_limit
  mov rdi, qword [kernel_ipc_base_address]
  
.loop:
  cmp rax, qword [rdi + KERNEL_IPC_STRUCTURE_LIST.ttl]
  ja .found

  add rdi, KERNEL_IPC_STRUCTURE_LIST.SIZE
  dec rcx
  jz .loop

  jmp .reload

.found:
  mov qword [rdi + KERNEL_IPC_STRUCTURE_LIST.pid_source], rdx

  mov qword [rdi + KERNEL_IPC_STRUCTURE_LIST.pid_destination], rbx
  mov rcx, qword [rsp]
  test rcx, rcx
  jz .load

  mov qword [rdi + KERNEL_IPC_STRUCTURE_LIST.size], rcx

  mov qword [rdi + KERNEL_IPC_STRUCTURE_LIST.pointer], rsi
  jmp .end

.load:
  push rdi
  mov ecx, KERNEL_IPC_STRUCTURE_LIST.SIZE - KERNEL_IPC_STRUCTURE_LIST.data
  add rdi, KERNEL_IPC_STRUCTURE_LIST.data
  rep movsb
  pop rdi

.end:
  inc qword [kernel_ipc_entry_count]
  add rax, KERNEL_IPC_TTL_default
  mov qword [rdi + KERNEL_IPC_STRUCTURE_LIST.ttl], rax

  mov byte [kernel_ipc_semaphore], STATIC_FALSE
  pop rcx
  pop rdi
  pop rsi
  pop rdx
  pop rax

  ret

  macro_debug "kernel_ipc_insert"

kernel_ipc_receive:
  push rax
  push rcx
  push rdi

  cmp qword [kernel_ipc_entry_count], STATIC_EMPTY
  je .empty

  call kernel_task_active
  mov rax, qword [rdi + KERNEL_STRUCTURE_TASK.pid]
  
  mov rcx, KERNEL_IPC_ENTRY_limit
  mov rsi, qword [kernel_ipc_base_address]
  mov rdi, qword [driver_rtc_microtime]

.loop:
  cmp qword [rsi + KERNEL_IPC_STRUCTURE_LIST.pid_destination], rax
  jne .next

  cmp rdi, qword [rsi + KERNEL_IPC_STRUCTURE_LIST.ttl]
  jbe .found

.next:
  add rsi, KERNEL_IPC_STRUCTURE_LIST.SIZE
  dec rcx
  jnz .loop

.empty:
  stc
  jmp .error

.found:
  mov ecx, KERNEL_IPC_STRUCTURE_LIST.SIZE
  mov rdi, qword [rsp]
  rep movsb

  mov qword [rsi - KERNEL_IPC_STRUCTURE_LIST.SIZE], STATIC_EMPTY
  dec qword [kernel_ipc_entry_count]
  clc

.error:
  pop rdi
  pop rsi
  pop rcx
  pop rax

  ret

  macro_debug "kernel_ipc_receive"
