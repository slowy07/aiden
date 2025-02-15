kernel_init_page:
	call kernel_memory_alloc_page
	jc   kernel_panic_memory

	call kernel_page_drain
	mov  qword [kernel_page_pml4_address], rdi

	inc qword [kernel_page_paged_count]

	mov  eax, KERNEL_BASE_address
	mov  bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  rcx, qword [kernel_page_total_count]
	mov  r11, rdi
	call kernel_page_map_physical
	jc   kernel_panic_memory

	mov  rax, KERNEL_STACK_address
	mov  ecx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	call kernel_page_map_logical
	jc   kernel_panic_memory

	mov  rax, qword [kernel_video_base_address]
	or   bx, KERNEL_PAGE_FLAG_write_through | KERNEL_PAGE_FLAG_cache_disable
	mov  rcx, qword [kernel_video_size_byte]
	call include_page_from_size
	call kernel_page_map_physical
	jc   kernel_panic_memory

	mov  rax, qword [kernel_apic_base_address]
	mov  bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  ecx, dword [kernel_apic_size]
	call include_page_from_size
	call kernel_page_map_physical
	jc   kernel_panic_memory

	mov  eax, dword [kernel_io_apic_base_address]
	mov  ecx, KERNEL_PAGE_SIZE_byte >> KERNEL_PAGE_SIZE_shift
	call kernel_page_map_physical
	jc   kernel_panic_memory

	mov  eax, 0x8000
	mov  ecx, kernel_init_boot_file_end - kernel_init_boot_file
	call include_page_from_size
	call kernel_page_map_physical
	jc   kernel_panic_memory

	mov rax, rdi
	mov cr3, rax

	mov rsp, KERNEL_STACK_pointer
