service_date_ipc_render:
	mov rax, qword [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.id]
	mov r8, qword [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.value0]
	mov r9, qword [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.value1]

	cmp byte [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.type], SERVICE_RENDER_IPC_MOUSE_BUTTON_RIGHT_press
	je  .right_mouse_button

	cmp rax, qword [service_date_window_menu + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.id]
	jne .end

	mov  rsi, service_date_window_menu
	call include_unit_element
	jc   .end

	cmp qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.event], STATIC_EMPTY
	je  .end

	push qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.event]
	ret

.left_mouse_button_no_menu:
	jmp .end

.right_mouse_button:
	cmp rax, qword [service_date_window_taskbar + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.id]
	je  .end

	cmp rax, qword [service_date_window_workbench + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.id]
	jne .end

	mov  rbx, qword [service_date_window_menu + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.id]
	call service_render_object_by_id

	mov rax, r8
	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	cmp rax, qword [service_date_window_workbench + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	jl  .y

	sub r8, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]

.y:
	mov rax, r9
	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	cmp rax, qword [service_date_window_taskbar + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	jl  .visible

	mov r9, qword [service_date_window_taskbar + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	sub r9, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	dec r9

.visible:
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], r8
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], r9

	or qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.flags], INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush

.end:
	ret
