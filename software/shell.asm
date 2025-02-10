%include "config.asm"
%include "kernel/config.asm"
%include "software/shell/config.asm"

	[BITS 64]

	[DEFAULT REL]

	[ORG SOFTWARE_base_address]

shell:
	mov ecx, shell_string_prompt_end - shell_string_prompt_with_new_line
	mov rsi, shell_string_prompt_with_new_line

	mov ax, KERNEL_SERVICE_VIDEO_cursor
	int KERNEL_SERVICE

	cmp ebx, STATIC_EMPTY
	jne .prompt

	mov ecx, shell_string_prompt_end - shell_string_prompt
	mov rsi, shell_string_prompt

.prompt:
	mov ax, KERNEL_SERVICE_VIDEO_string
	int KERNEL_SERVICE

.restart:
	xor ebx, ebx

	mov ecx, SHELL_CACHE_SIZE_byte

	mov rsi, shell_cache

	call include_input
	jc   shell

	call include_string_trim
	jc   shell

	push rcx

	cmp rsi, shell_cache
	je  .begin

	mov rdi, shell_cache
	rep movsb

.begin:
	pop rcx

	mov  rsi, shell_cache
	call include_string_word_next

	jmp shell_prompt

%include "software/shell/data.asm"
%include "software/shell/prompt.asm"
%include "include/input.asm"
%include "include/string_trim.asm"
%include "include/string_word_next.asm"
%include "include/string_compare.asm"
