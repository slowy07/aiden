%include "config.asm"
%include "kernel/config.asm"

	[BITS 64]

	[DEFAULT REL]

	[ORG SOFTWARE_base_address]

free:
	mov ax, KERNEL_SERVICE_VIDEO_string
	mov ecx, free_string_table_end - free_string_table
	mov rsi, free_string_table
	int KERNEL_SERVICE

	mov ax, KERNEL_SERVICE_SYSTEM_memory
	int KERNEL_SERVICE

	mov ax, KERNEL_SERVICE_VIDEO_cursor
	int KERNEL_SERVICE

	mov r15, rbx

	mov ax, KERNEL_SERVICE_VIDEO_number
	mov bl, STATIC_NUMBER_SYSTEM_decimal
	xor ecx, ecx
	shl r8, STATIC_MULTIPLE_BY_4_shift
	int KERNEL_SERVICE

	call free_column_fill

	shl r9, STATIC_MULTIPLE_BY_4_shift
	sub r8, r9
	int KERNEL_SERVICE

	call free_column_fill

	mov r8, r9
	int KERNEL_SERVICE

	call free_column_fill

	mov r8, r10
	shl r8, STATIC_MULTIPLE_BY_4_shift
	int KERNEL_SERVICE

	call free_column_fill

	xor ax, ax
	int KERNEL_SERVICE

free_column_fill:
	push rax
	push rcx
	push rbx

	mov ax, KERNEL_SERVICE_VIDEO_string
	mov ecx, free_string_kib_end - free_string_kib
	mov rsi, free_string_kib
	int KERNEL_SERVICE

	add r15, 14

	mov ax, KERNEL_SERVICE_VIDEO_cursor_set
	mov rbx, r15
	int KERNEL_SERVICE

	pop rbx
	pop rcx
	pop rax

	ret

%include "software/free/data.asm"
