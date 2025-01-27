KERNEL_MEMORY_HIGH_mask   equ 0xFFFF000000000000
KERNEL_MEMORY_HIGH_REAL_address  equ 0xFFFF800000000000
KERNEL_MEMORY_HIGH_VIRTUAL_address equ KERNEL_MEMORY_HIGH_REAL_address - KERNEL_MEMORY_HIGH_mask

KERNEL_MEMORY_MAP_SIZE_page  equ 0x01

kernel_memory_map_address  dq STATIC_EMPTY
kernel_memory_map_address_end  dq STATIC_EMPTY

kernel_memory_lock_semaphore  db STATIC_FALSE

kernel_memory_alloc_page:
	push rcx

	mov  ecx, 0x01
	call kernel_memory_alloc

	pop rcx
	ret

kernel_memory_alloc:
	push rax
	push rbx
	push rdx
	push rsi
	push rbp
	push rcx

	mov rax, STATIC_MAX_unsigned
	mov rcx, qword [kernel_page_total_count]
	mov rsi, qword [kernel_memory_map_address]

.reload:
	xor edx, edx

.search:
	inc rax
	cmp rax, rcx
	je  .error
	bt  qword [rsi], rax
	jnc .search
	mov rbx, rax

.check:
	inc rax
	inc rdx
	cmp rdx, qword [rsp]
	je  .found

	cmp rax, rcx
	je  .error
	bt  qword [rsi], rax
	jc  .check
	jmp .reload

.error:
	stc

	jmp .end

.found:
	mov rax, rbx

.lock:
	btr qword [rsi], rax

	test rbp, rbp
	jz   .empty
	dec  rbp
	dec  dword [kernel_page_reserved_count]

	jmp .next

.empty:
	dec qword [kernel_page_free_count]

.next:
	inc rax

	dec rdx
	jnz .lock
	mov rdi, rbx
	shl rdi, STATIC_MULTIPLE_BY_PAGE_shift

	add rdi, KERNEL_BASE_address

.end:
	mov byte [kernel_memory_lock_semaphore], STATIC_FALSE

	pop rcx
	pop rbp
	pop rsi
	pop rdx
	pop rbx
	pop rax

	ret

kernel_memory_lock:
	macro_close kernel_memory_lock_semaphore, 0
	ret
