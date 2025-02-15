service_render_keyboard:
	call driver_ps2_keyboard_read
	jz   .end
  
  mov rsi, qword [service_render_object_selected_pointer]
  
  test rsi, rsi
  jz .leave

  mov cl, SERVICE_RENDER_IPC_KEYBOARD
  call service_render_ipc_keyboard

.leave:
	cmp ax, DRIVER_PS2_KEYBOARD_PRESS_ALT_LEFT
	jne .no_press_alt_left

	mov byte [service_render_keyboard_alt_left_semaphore], STATIC_TRUE

.no_press_alt_left:
	cmp ax, DRIVER_PS2_KEYBOARD_RELEASE_ALT_LEFT
	jne .end

	mov byte [service_render_keyboard_alt_left_semaphore], STATIC_FALSE

.end:
	ret

macro_debug "service_render_keyboard"
