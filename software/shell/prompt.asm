shell_prompt_clean:

	add rsi, rbx
	sub r8, rbx

	mov  rcx, r8
	call include_string_trim

	mov r8, rcx

.error:
	ret

shell_prompt:
	mov r8, rcx

	cmp rbx, shell_command_clean_end - shell_command_clean
	jne .no_clean

	mov  ecx, ebx
	mov  rdi, shell_command_clean
	call include_string_compare
	jc   .no_clean

	mov ax, KERNEL_SERVICE_VIDEO_clean
	int KERNEL_SERVICE

	jmp shell

.no_clean:
	cmp rbx, shell_command_exit_end - shell_command_exit
	jne .no_exit

	mov  ecx, ebx
	mov  rdi, shell_command_exit
	call include_string_compare
	jc   .no_exit

	xor ax, ax
	int KERNEL_SERVICE

.no_exit:
	mov ax, KERNEL_SERVICE_VFS_exist
	add r8, shell_exec_path_end - shell_exec_path
	mov rcx, r8
	mov rsi, shell_exec_path
	int KERNEL_SERVICE
	jc  .error

	mov ax, KERNEL_SERVICE_VIDEO_char
	mov ecx, 0x01
	mov dx, STATIC_ASCII_NEW_LINE
	int KERNEL_SERVICE

	mov ax, KERNEL_SERVICE_PROCESS_run
	mov rcx, r8
	int KERNEL_SERVICE
	jc  .end

	mov ax, KERNEL_SERVICE_PROCESS_check

.wait_for_end:
	int KERNEL_SERVICE
	jnc .wait_for_end

.end:
	jmp shell

.error:
	mov ax, KERNEL_SERVICE_VIDEO_string
	mov ecx, shell_command_unknown_end - shell_command_unknown
	mov rsi, shell_command_unknown
	int KERNEL_SERVICE

	jmp shell
