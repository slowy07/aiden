KERNEL_MEMORY_MAP_SIZE_page equ 0x01

kernel_memory_map_address dq STATIC_EMPTY
kernel_memory_map_address_end dq STATIC_EMPTY

kernel_memory_high_mask dq KERNEL_MEMORY_HIGH_mask
kernel_memory_real_address dq KERNEL_MEMORY_HIGH_REAL_address

kernel_memory_lock_semaphore db STATIC_FALSE

kernel_memory_secure:
	push rax
	push rcx
	push rsi

	mov rax, STATIC_MAX_unsigned

.loop:
	inc rax
	btr qword [rsi], rax

	dec rcx
	jnz .loop

	pop rsi
	pop rcx
	pop rax

	ret

kernel_memory_alloc_page:
	push rcx

	mov  ecx, 0x01
	call kernel_memory_alloc

	pop rcx

	ret

macro_debug "kernel_memory_alloc_page"

kernel_memory_alloc:
	push rbx
	push rdx
	push rsi
	push rbp
	push rax
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

	bt qword [rsi], rax
	jc .check

	jmp .reload

.error:
	mov qword [rsp + STATIC_QWORD_SIZE_byte], KERNEL_ERROR_PAGE_memory_low

	stc

	jmp .end

.found:
	mov rax, rbx

.lock:
	btr qword [rsi], rax

	test rbp, rbp
	jz   .next

	dec rbp
	dec dword [kernel_page_reserved_count]

.next:
	dec qword [kernel_page_free_count]

	inc rax

	dec rdx
	jnz .lock

	mov rdi, rbx
	shl rdi, STATIC_MULTIPLE_BY_PAGE_shift

	add rdi, KERNEL_BASE_address

.end:
	mov byte [kernel_memory_lock_semaphore], STATIC_FALSE

	pop rcx
	pop rax
	pop rbp
	pop rsi
	pop rdx
	pop rbx

	ret

macro_debug "kernel_memory_alloc"

kernel_memory_lock:
	macro_lock kernel_memory_lock_semaphore, 0

	ret

macro_debug "kernel_memory_lock"

kernel_memory_release_page:
	push rax
	push rcx
	push rdx
	push rsi
	push rdi

	mov rsi, qword [kernel_memory_map_address]

	mov rax, rdi
	sub rax, KERNEL_BASE_address
	shr rax, KERNEL_PAGE_SIZE_shift

	mov rcx, 64
	xor rdx, rdx
	div rcx

	shl rax, STATIC_MULTIPLE_BY_8_shift
	add rsi, rax

	bts qword [rsi], rdx

	inc qword [kernel_page_free_count]

	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rax

	ret

macro_debug "kernel_memory_release_page"

kernel_memory_release:
	push rcx
	push rdi

.loop:
	call kernel_memory_release_page

	add rdi, KERNEL_PAGE_SIZE_byte

	dec rcx
	jnz .loop

	pop rdi
	pop rcx

	ret

macro_debug "kernel_memory_release"

kernel_memory_release_foreign:
	push rax
	push rdx
	push rdi
	push r8
	push r9
	push r10
	push r12
	push r13
	push r14
	push r15
	push r11
	push rcx

	mov rcx, KERNEL_PAGE_PML3_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r15, rax

	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r11, rax

	mov rax, qword [r11]
	xor al, al

	mov r10, rax

	mov rax, rdx
	mov rcx, KERNEL_PAGE_PML2_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r14, rax

	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r10, rax

	mov rax, qword [r10]
	xor al, al

	mov r9, rax

	mov rax, rdx
	mov rcx, KERNEL_PAGE_PML1_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r13, rax

	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r9, rax

	mov rax, qword [r9]
	xor al, al

	mov r8, rax

	mov rax, rdx
	mov rcx, KERNEL_PAGE_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r12, rax

	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r8, rax

	mov rcx, qword [rsp]

.pml1:
	test rcx, rcx
	jz   .end

	cmp qword [r8], STATIC_EMPTY
	je  .pml1_omit

	mov  rdi, qword [r8]
	and  di, KERNEL_PAGE_mask
	call kernel_memory_release_page

	mov qword [r8], STATIC_EMPTY

.pml1_omit:
	dec rcx

	add r8, STATIC_QWORD_SIZE_byte
	inc r12

	cmp r12, KERNEL_PAGE_RECORDS_amount
	jne .pml1

.pml2_entry:
	mov  rdi, qword [r9]
	and  di, KERNEL_PAGE_mask
	call kernel_page_empty
	jnz  .pml2

	call kernel_memory_release_page

	dec qword [kernel_page_paged_count]

	mov qword [r9], STATIC_EMPTY

.pml2:
	add r9, STATIC_QWORD_SIZE_byte
	inc r13

	cmp r13, KERNEL_PAGE_RECORDS_amount
	je  .pml3_entry

.pml2_record:
	mov r8, qword [r9]

	test r8, r8
	jz   .pml2

	xor r8b, r8b

	xor r12, r12

	jmp .pml1

.pml3_entry:
	mov  rdi, qword [r10]
	and  di, KERNEL_PAGE_mask
	call kernel_page_empty
	jnz  .pml3

	call kernel_memory_release_page

	dec qword [kernel_page_paged_count]

	mov qword [r10], STATIC_EMPTY

.pml3:
	add r10, STATIC_QWORD_SIZE_byte
	inc r14

	cmp r14, KERNEL_PAGE_RECORDS_amount
	je  .pml4_entry

.pml3_record:
	mov r9, qword [r10]

	test r9, r9
	jz   .pml3

	xor r9b, r9b

	xor r13, r13

	jmp .pml2_record

.pml4_entry:
	mov  rdi, qword [r11]
	and  di, KERNEL_PAGE_mask
	call kernel_page_empty
	jnz  .pml4

	call kernel_memory_release_page

	dec qword [kernel_page_paged_count]

	mov qword [r11], STATIC_EMPTY

.pml4:
	add r11, STATIC_QWORD_SIZE_byte
	inc r15

	cmp r15, KERNEL_PAGE_RECORDS_amount
	je  .pml5

	mov r10, qword [r11]

	test r10, r10
	jz   .pml4

	xor r10b, r10b

	xor r14, r14

	jmp .pml3_record

.pml5:
	stc

.end:
	pop rcx
	pop r11
	pop r15
	pop r14
	pop r13
	pop r12
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rdx
	pop rax

	ret

macro_debug "kernel_memory_release_foreign"

kernel_memory_copy:
	push rcx
	push rsi
	push rdi

	shr rcx, STATIC_DIVIDE_BY_256_shift

.loop:
	macro_copy

	add rsi, 256
	add rdi, 256

	dec rcx
	jnz .loop

	pop rdi
	pop rsi
	pop rcx

	ret

macro_debug "kernel_memory_copy"

kernel_memory_mark:
	push rcx
	push rdi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push rax

	mov r11, cr3

	mov  rax, rdi
	call kernel_page_prepare
	jc   .error

.pml1:
	cmp r12, KERNEL_PAGE_RECORDS_amount
	jb  .entry

.pml2:
	cmp r13, KERNEL_PAGE_RECORDS_amount
	jnb .pml3

	add r9, STATIC_QWORD_SIZE_byte
	mov r8, qword [r9]

	and r8w, KERNEL_PAGE_mask

	xor r12, r12

	jmp .entry

.pml3:
	cmp r14, KERNEL_PAGE_RECORDS_amount
	jnb .pml4

	add r10, STATIC_QWORD_SIZE_byte
	mov r9, qword [r10]

	and r9w, KERNEL_PAGE_mask

	xor r13, r13

	jmp .pml2

.pml4:
	cmp r15, KERNEL_PAGE_RECORDS_amount
	jnb .error

	add r11, STATIC_QWORD_SIZE_byte
	mov r10, qword [r10]

	and r10w, KERNEL_PAGE_mask

	xor r14, r14

	jmp .pml3

.entry:
	or word [r8], KERNEL_PAGE_FLAG_user

	add r8, STATIC_QWORD_SIZE_byte

	inc r12

	dec rcx
	jnz .pml1

	clc

	jmp .end

.error:
	xchg bx, bx

	jmp $

.end:
	pop rax
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rcx

	ret

macro_debug "kernel_memory_mark"
