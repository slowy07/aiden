
	%include	"config.asm"
	%include	"kernel/config.asm"

[BITS 64]

[DEFAULT REL]

[ORG SOFTWARE_base_address]

init:
	mov	ax,	KERNEL_SERVICE_VIDEO_string
	mov	ecx,	init_string_logo_end - init_string_logo
	mov	rsi,	init_string_logo
	int	KERNEL_SERVICE

.exec:
	mov	ax,	KERNEL_SERVICE_PROCESS_run
	mov	ecx,	init_program_shell_end - init_program_shell
	xor	edx,	edx	
	mov	rsi,	init_program_shell
	int	KERNEL_SERVICE
	jc	.exec	

	mov	ax,	KERNEL_SERVICE_PROCESS_check

.wait_for_shell:
	int	KERNEL_SERVICE
	jnc	.wait_for_shell	

	mov	ax,	KERNEL_SERVICE_VIDEO_clean
	int	KERNEL_SERVICE

	jmp	init

.error:
	push	rax

	mov	ax,	KERNEL_SERVICE_VIDEO_string
	mov	ecx,	init_string_error_end - init_string_error
	mov	rsi,	init_string_error
	int	KERNEL_SERVICE

	mov	ax,	KERNEL_SERVICE_VIDEO_number
	mov	ebx,	STATIC_NUMBER_SYSTEM_decimal
	xor	ecx,	ecx	
	pop	r8	
	int	KERNEL_SERVICE

	int	0x00

	jmp	$

	%include	"software/init/data.asm"
