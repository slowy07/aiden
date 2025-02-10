service_date_ipc:
	push rax
	push rsi
	push rdi
	push r8
	push r9

	mov  rdi, service_date_ipc_data
	call kernel_ipc_receive
	jc   .end

	mov rax, qword [service_render_pid]
	cmp qword [rdi + KERNEL_IPC_STRUCTURE.pid_source], rax
	jne .no_render

	call service_date_ipc_render

.no_render:

.end:
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rax

	ret

macro_debug "service_date_ipc"

%include "kernel/service/date/ipc/render.asm"
