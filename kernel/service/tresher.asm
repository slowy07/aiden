service_tresher:
	call service_tresher_search

	mov r11, qword [rsi + KERNEL_STRUCTURE_TASK.cr3]

	mov rax, KERNEL_MEMORY_HIGH_VIRTUAL_address

	movzx ecx, word [rsi + KERNEL_STRUCTURE_TASK.stack]

	mov rbx, rcx
	shl rbx, KERNEL_PAGE_SIZE_shift
	sub rax, rbx

	call kernel_memory_release_foreign

	test word [rsi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_thread
	jz   .pml4

	mov  rbx, 4
	mov  rcx, 1
	mov  rdi, r11
	add  rdi, KERNEL_PAGE_SIZE_byte - (256 * STATIC_QWORD_SIZE_byte)
	call kernel_page_release_pml.loop

.pml4:
	mov  rdi, r11
	call kernel_page_purge
	call kernel_memory_release_page

	dec qword [kernel_page_paged_count]

	mov word [rsi + KERNEL_STRUCTURE_TASK.flags], STATIC_EMPTY

	jmp service_tresher

service_tresher_search:
	push rcx

	mov rsi, qword [kernel_task_address]

.restart:
	mov rcx, STATIC_STRUCTURE_BLOCK.link / KERNEL_STRUCTURE_TASK.SIZE

.next:
	test word [rsi + KERNEL_STRUCTURE_TASK.flags], KERNEL_TASK_FLAG_closed
	jnz  .found

	add rsi, KERNEL_STRUCTURE_TASK.SIZE

	dec rcx
	jnz .next

	and si, KERNEL_PAGE_mask
	mov rsi, qword [rsi + STATIC_STRUCTURE_BLOCK.link]
	jmp .restart

.found:
	pop rcx

	ret
