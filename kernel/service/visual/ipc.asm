service_render_ipc_mouse:
	push rax
	push rbx
	push rcx
	push rsi

	mov rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id]
	mov rbx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid]

	sub r8, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	sub r9, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]

	mov rsi, service_render_ipc_data

	mov byte [rsi + SERVICE_RENDER_STRUCTURE_IPC.type], cl

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_IPC.id], rax

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_IPC.value0], r8
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_IPC.value1], r9

	xor  ecx, ecx
	call kernel_ipc_insert

	pop rsi
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "service_render_ipc_mouse"

service_render_ipc_keyboard:
  push rbx
  push rcx
  push rdx
  push rsi

  mov rdx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id]
  mov rbx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid]

  mov rsi, service_render_ipc_data

  mov byte [rsi + SERVICE_RENDER_STRUCTURE_IPC.type], cl

  mov qword [rsi + SERVICE_RENDER_STRUCTURE_IPC.id], rdx

  mov qword [rsi + SERVICE_RENDER_STRUCTURE_IPC.value0],rax

  xor ecx, ecx
  call kernel_ipc_insert

  pop rsi
  pop rdx
  pop rcx
  pop rbx

  ret

  macro_debug "service_render_ipc_keyboard"
