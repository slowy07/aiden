service_render_event:
	push rax
	push rbx
	push rcx
	push rsi
	push r8
	push r9
	push r10
	push r11

	call service_render_keyboard

	mov r8d, dword [driver_ps2_mouse_x]
	mov r9d, dword [driver_ps2_mouse_y]

	mov r14, r8
	sub r14, qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]

	mov r15, r9
	sub r15, qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]

	bt  word [driver_ps2_mouse_state], DRIVER_PS2_DEVICE_MOUSE_PACKET_LMB_bit
	jnc .no_mouse_button_left_action

	cmp byte [service_render_mouse_button_left_semaphore], STATIC_TRUE
	je  .no_mouse_button_left_action

	mov byte [service_render_mouse_button_left_semaphore], STATIC_TRUE

	;    INFO: DEBUG MODE
	;cmp qword [service_render_object_selected_pointer], STATIC_EMPTY
	;jne .no_mouse_button_left_action

	call service_render_object_find
	jc   .no_mouse_button_left_action

	mov qword [service_render_object_selected_pointer], rsi

	mov  cl, SERVICE_RENDER_IPC_MOUSE_BUTTON_LEFT_press
	call service_render_ipc_mouse

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_fixed_z
	jnz  .fixed_z

	mov  rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid]
	call service_render_object_up

	mov qword [service_render_object_selected_pointer], rsi

	or qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

	or qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

.fixed_z:
	call service_render_object_hide

.no_mouse_button_left_action:
	bt word [driver_ps2_mouse_state], DRIVER_PS2_DEVICE_MOUSE_PACKET_LMB_bit
	jc .no_mouse_button_left_release

.no_mouse_button_left_action_release:
	mov byte [service_render_mouse_button_left_semaphore], STATIC_FALSE

.no_mouse_button_left_action_release_selected:
	;    INFO: DEBUG mode
	;mov qword [service_render_object_selected_pointer], STATIC_EMPTY

.no_mouse_button_left_release:
	bt  word [driver_ps2_mouse_state], DRIVER_PS2_DEVICE_MOUSE_PACKET_RMB_bit
	jnc .no_mouse_button_right_action

	cmp byte [service_render_mouse_button_right_semaphore], STATIC_TRUE
	je  .no_mouse_button_right_action

	mov byte [service_render_mouse_button_right_semaphore], STATIC_TRUE

	call service_render_object_find
	jc   .no_mouse_button_right_action

	call service_render_object_hide

	mov  cl, SERVICE_RENDER_IPC_MOUSE_BUTTON_RIGHT_press
	call service_render_ipc_mouse

.no_mouse_button_right_action:
	bt word [driver_ps2_mouse_state], DRIVER_PS2_DEVICE_MOUSE_PACKET_RMB_bit
	jc .no_mouse_button_right_release

	mov byte [service_render_mouse_button_right_semaphore], STATIC_FALSE

.no_mouse_button_right_release:
	test r14, r14
	jnz  .move

	test r15, r15
	jz   .end

.move:
	mov  rsi, service_render_object_cursor
	call service_render_zone_insert_by_object

	add qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x], r14
	add qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y], r15

	or qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

	cmp byte [service_render_mouse_button_left_semaphore], STATIC_FALSE
	je  .end

	cmp qword [service_render_object_selected_pointer], STATIC_EMPTY
	je  .end

	call service_render_object_move

.end:
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "service_render_event"
