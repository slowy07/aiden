kernel_init_panic_low_memory:
	mov ecx, kernel_init_string_error_memory_low_end - kernel_init_string_error_memory_low
	mov esi, kernel_init_string_error_memory_low

	jmp kernel_panic
