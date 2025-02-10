service_render_irq:
	cmp byte [service_render_semaphore], STATIC_FALSE
	je  service_render_irq

	push rax

	cld

	cmp al, SERVICE_RENDER_WINDOW_create
	je  .window_create

	cmp al, SERVICE_RENDER_WINDOW_update
	je  .window_update

.error:
	stc

.end:
	pushf
	pop rax

	and ax, KERNEL_TASK_EFLAGS_cf | KERNEL_TASK_EFLAGS_zf
	or  word [rsp + KERNEL_TASK_STRUCTURE_IRETQ.eflags + STATIC_QWORD_SIZE_byte], ax

	pop rax

	iretq

	macro_debug "service_render_irq"

.window_create:
	push rsi
	push rdi

	mov  rcx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size]
	call include_page_from_size
	call kernel_memory_alloc

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

	call kernel_memory_mark

	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	call service_render_object_insert

	pop rdi
	pop rsi

	jmp service_render_irq.end

macro_debug "service_render_irq.window_create"

.window_update:
	push rax
	push rbx
	push rsi

	mov  rbx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id]
	call service_render_object_by_id

	call kernel_task_active_pid

	cmp rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid]
	jne .window_flags_error

	mov rbx, qword [rsp]

	mov rax, qword [rbx + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags]
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], rax

	jmp .window_flags_end

.window_flags_error:
	stc

.window_flags_end:
	pop rsi
	pop rbx
	pop rax

	jmp service_render_irq.end

macro_debug "service_render_irq.window_update"
