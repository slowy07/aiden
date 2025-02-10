service_date_clock:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi

	call driver_rtc_get_date_and_time
	mov  rax, qword [driver_rtc_date_and_time]

	cmp qword [service_date_clock_last_state], rax
	je  .end

	mov qword [service_date_clock_last_state], rax

	mov  bl, byte [service_date_clock_colon]
	xchg bl, byte [service_date_window_taskbar.element_label_clock_char_colon]
	mov  byte [service_date_clock_colon], bl

	shr  rax, STATIC_MOVE_HIGH_TO_AL_shift
	and  eax, 0xFF
	mov  ebx, STATIC_NUMBER_SYSTEM_decimal
	mov  ecx, 0x02
	mov  dl, STATIC_ASCII_DIGIT_0
	mov  rdi, service_date_window_taskbar.element_label_clock_string_minute
	call include_integer_to_string

	mov rax, qword [service_date_clock_last_state]

	shr  rax, STATIC_MOVE_HIGH_TO_AX_shift
	and  rax, 0xFF
	mov  dl, STATIC_ASCII_SPACE
	mov  rdi, service_date_window_taskbar.element_label_clock_string_hour
	call include_integer_to_string

	mov  rdi, service_date_window_taskbar
	mov  rsi, service_date_window_taskbar.element_label_clock
	call include_unit_element_label

	mov al, SERVICE_RENDER_WINDOW_update
	mov rsi, service_date_window_taskbar
	int SERVICE_RENDER_IRQ

.end:
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret
