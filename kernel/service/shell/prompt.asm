service_shell_prompt_clean:
	add rsi, rbx
	sub r8, rbx

	mov  rcx, r8
	call include_string_trim

	mov r8, rcx

.error:
	ret

service_shell_prompt:
	mov r8, rcx

	cmp rbx, service_shell_command_clean_end - service_shell_command_clean
	jne .clean_omit

	mov  ecx, ebx
	mov  rdi, service_shell_command_clean
	call include_string_compare
	jc   .clean_omit

	call kernel_video_drain

	mov  qword [kernel_video_cursor], STATIC_EMPTY
	call kernel_video_cursor_set

	jmp .end

.clean_omit:
	cmp rbx, service_shell_command_ip_end - service_shell_command_ip
	jne .ip_omit

	mov  ecx, ebx
	mov  rdi, service_shell_command_ip
	call include_string_compare
	jc   .ip_omit
	call service_shell_prompt_clean
	jc   .ip_properties

	call include_string_word_next

	cmp ebx, service_shell_command_ip_set_end - service_shell_command_ip_set
	jne .ip_unknown

	mov  ecx, ebx
	mov  rdi, service_shell_command_ip_set
	call include_string_compare
	jc   .ip_unknown

	call service_shell_prompt_clean
	jc   .ip_set_error

	call include_string_word_next

	cmp rbx, rcx
	jne .ip_set_error

	mov dl, 4

	xor r8d, r8d

	mov rdi, rsi
	add rdi, rbx

.ip_set_loop:
	mov  al, STATIC_ASCII_DOT
	call include_string_cut

	test rcx, rcx
	jz   .ip_set_error

	call include_string_digits
	jc   .ip_set_error

	call include_string_to_integer

	cmp rax, 255
	ja  .ip_set_error

	shl r8d, STATIC_MOVE_AL_TO_HIGH_shift
	mov r8b, al

	inc rcx
	add rsi, rcx

	dec dl
	jnz .ip_set_loop

	dec rsi
	cmp rsi, rdi
	jne .ip_set_error

	bswap r8d
	mov   dword [driver_nic_i82540em_ipv4_address], r8d

	jmp .end

.ip_set_error:
	mov  ecx, service_shell_string_error_ipv4_format_end - service_shell_string_error_ipv4_format
	mov  rsi, service_shell_string_error_ipv4_format
	call kernel_video_string

	jmp .end

.ip_properties:
	mov  eax, STATIC_ASCII_NEW_LINE
	mov  cl, 1
	call kernel_video_char

	mov bl, STATIC_NUMBER_SYSTEM_decimal

	xor cl, cl

	mov dl, 4

	mov rsi, driver_nic_i82540em_ipv4_address

.ip_properties_loop:
	lodsb

	call kernel_video_number

	dec dl
	jz  .end

	mov  eax, STATIC_ASCII_DOT
	mov  cl, 1
	call kernel_video_char

	jmp .ip_properties_loop

.ip_unknown:
	mov  al, STATIC_ASCII_NEW_LINE
	mov  ecx, 1
	call kernel_video_char

	mov  ecx, ebx
	call kernel_video_string

	mov  ecx, service_shell_command_unknown_end - service_shell_command_unknown
	mov  rsi, service_shell_command_unknown
	call kernel_video_string

	jmp .end

.ip_omit:

.end:
	jmp service_shell
