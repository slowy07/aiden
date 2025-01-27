KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_memory_map equ 6

struc        KERNEL_INIT_MEMORY_MULTIBOOT_HEADER
.flags       resb 4
.unsupported resb 40
.mmap_length resb 4
.mmap_addr resb 4
endstruc

struc    KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP
.size    resb 4
.address resb 8
.limit   resb 8
.type    resb 4

.SIZE:
	endstruc

kernel_init_memory:
	bt  dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.flags], KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_memory_map
	jnc kernel_panic

	mov ecx, dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.mmap_length]
	mov ebx, dword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_HEADER.mmap_addr]

.search:
	cmp qword [ebx + KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.address], KERNEL_BASE_address
	je  .found
	add ebx, KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.SIZE

	sub ecx, KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.SIZE
	jnz .search

	mov  ecx, kernel_init_string_error_memory_end - kernel_init_string_error_memory
	mov  rsi, kernel_init_string_error_memory
	call kernel_panic

.found:
	mov rcx, qword [rbx + KERNEL_INIT_MEMORY_MULTIBOOT_STRUCTURE_MEMORY_MAP.limit]
	shr rcx, STATIC_DIVIDE_BY_PAGE_shift

	mov qword [kernel_page_total_count], rcx
	mov qword [kernel_page_free_count], rcx

	mov  rdi, kernel_end
	call library_page_align_up

	mov qword [kernel_memory_map_address], rdi

	shr rcx, STATIC_DIVIDE_BY_8_shift

	push rcx

	call library_page_from_size
	call kernel_page_drain_few

	pop rcx

	mov al, STATIC_MAX_unsigned
	rep stosb

	mov qword [kernel_memory_map_address_end], rdi

	call library_page_align_up
	sub  rdi, KERNEL_BASE_address
	shr  rdi, STATIC_DIVIDE_BY_PAGE_shift

	mov  rcx, rdi
	call kernel_memory_alloc
