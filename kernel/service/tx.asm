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

service_tx_pid dq STATIC_EMPTY

service_tx_ipc_message:
  times KERNEL_IPC_STRUCTURE_LIST.SIZE db STATIC_EMPTY

service_tx:
  call kernel_task_active
  mov rax, qword [rdi + KERNEL_STRUCTURE_TASK.pid]
  mov qword [service_tx_pid], rax

.loop:
  mov rdi, service_tx_ipc_message
  call kernel_ipc_receive
  jc .loop

  mov rcx, qword [rdi + KERNEL_IPC_STRUCTURE_LIST.size]

  test rcx, rcx
  jz .loop

  mov rax, rcx
  mov rdi, qword [rdi + KERNEL_IPC_STRUCTURE_LIST.pointer]
  call driver_nic_i82540em_transfer
  
  call library_page_from_size
  call kernel_memory_release
  jmp .loop

  macro_debug "service_tx"
