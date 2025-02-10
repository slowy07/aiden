service_tx_pid dq STATIC_EMPTY

service_tx_ipc_message:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY

service_tx:
	call kernel_task_active
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	mov qword [service_tx_pid], rax

.loop:
	mov  rdi, service_tx_ipc_message
	call kernel_ipc_receive
	jc   .loop

	mov rcx, qword [rdi + KERNEL_IPC_STRUCTURE.size]

	test rcx, rcx
	jz   .loop

	mov  rax, rcx
	mov  rdi, qword [rdi + KERNEL_IPC_STRUCTURE.pointer]
	call driver_nic_i82540em_transfer

	call include_page_from_size
	call kernel_memory_release

	jmp .loop

macro_debug "service_tx"
