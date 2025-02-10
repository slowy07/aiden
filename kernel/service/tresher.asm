service_tresher:
	call service_tresher_search

	mov r11, qword [rsi + KERNEL_TASK_STRUCTURE.cr3]

	mov rax, KERNEL_MEMORY_HIGH_VIRTUAL_address

	movzx ecx, word [rsi + KERNEL_TASK_STRUCTURE.stack]

	shl rcx, KERNEL_PAGE_SIZE_shift
	sub rax, rcx

	shr  rcx, KERNEL_PAGE_SIZE_shift
	call kernel_memory_release_foreign

	test word [rsi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_thread
	jnz  .pml4

	mov  rax, KERNEL_MEMORY_HIGH_VIRTUAL_address
	mov  rcx, STATIC_MAX_unsigned
	call kernel_memory_release_foreign

.pml4:
	mov  rdi, r11
	call kernel_memory_release_page

	dec qword [kernel_page_paged_count]

	mov word [rsi + KERNEL_TASK_STRUCTURE.flags], STATIC_EMPTY

	dec qword [kernel_task_count]

	inc qword [kernel_task_free]

	jmp service_tresher

macro_debug "service_tresher"

service_tresher_search:
	push rcx

	mov rsi, qword [kernel_task_address]

.restart:
	mov rcx, STATIC_STRUCTURE_BLOCK.link / KERNEL_TASK_STRUCTURE.SIZE

.next:
	test word [rsi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_closed
	jnz  .found

	add rsi, KERNEL_TASK_STRUCTURE.SIZE

	dec rcx
	jnz .next

	and si, KERNEL_PAGE_mask
	mov rsi, qword [rsi + STATIC_STRUCTURE_BLOCK.link]
	jmp .restart

.found:
	pop rcx

	ret

macro_debug "service_tresher_search"
