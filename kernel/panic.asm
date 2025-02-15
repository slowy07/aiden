kernel_panic_memory:
  mov rsi, kernel_init_string_error_memory_low

kernel_panic:
  call driver_serial_send
	jmp $

macro_debug "kernel_panic"
