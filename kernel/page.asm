KERNEL_PAGE_FLAG_available equ 0x01
KERNEL_PAGE_FLAG_write equ 0x02
KERNEL_PAGE_FLAG_user equ 0x04
KERNEL_PAGE_FLAG_write_through equ 0x08
KERNEL_PAGE_FLAG_cache_disable equ 0x10
KERNEL_PAGE_FLAG_length equ 0x80

KERNEL_PAGE_RECORDS_amount equ 512

KERNEL_PAGE_PML4_SIZE_byte equ KERNEL_PAGE_RECORDS_amount * KERNEL_PAGE_PML3_SIZE_byte
KERNEL_PAGE_PML3_SIZE_byte equ KERNEL_PAGE_RECORDS_amount * KERNEL_PAGE_PML2_SIZE_byte
KERNEL_PAGE_PML2_SIZE_byte equ KERNEL_PAGE_RECORDS_amount * KERNEL_PAGE_PML1_SIZE_byte
KERNEL_PAGE_PML1_SIZE_byte equ KERNEL_PAGE_RECORDS_amount * KERNEL_PAGE_SIZE_byte

kernel_page_pml4_address dq STATIC_EMPTY

kernel_page_total_count dq STATIC_EMPTY
kernel_page_free_count dq STATIC_EMPTY
kernel_page_reserved_count dq STATIC_EMPTY
kernel_page_paged_count dq STATIC_EMPTY

kernel_page_purge:
	push rbx
	push rcx
	push rdi

	mov bl, 0x04
	mov rdi, r11

.recursion:
	dec  bl
	push rcx
	call kernel_page_purge.table
	jnc  .purge

	test bl, bl
	jz   .continue

	mov ecx, KERNEL_PAGE_RECORDS_amount

.loop:
	cmp qword [rdi], STATIC_EMPTY
	je  .empty

	push rdi
	mov  rdi, qword [rdi]
	and  di, KERNEL_PAGE_mask
	call kernel_page_purge.recursion
	pop  rdi

.empty:
	add rdi, STATIC_QWORD_SIZE_byte
	dec ecx
	jnz .loop

.continue:
	pop rcx
	inc bl
	cmp bl, 0x04
	je  .end
	ret

.purge:
	test rdi, r11
	jz   .end

	call kernel_memory_release_page
	mov  rdi, qword [rsp + STATIC_QWORD_SIZE_byte * 0x02]
	mov  qword [rdi], STATIC_EMPTY
	jmp  .continue

.end:
	pop rdi
	pop rcx
	pop rbx
	ret

.table:
	push rcx
	push rdi
	mov  ecx, KERNEL_PAGE_RECORDS_amount

.table_check:
	cmp qword [rdi], STATIC_EMPTY
	jne .table_not_empty

	add rdi, STATIC_QWORD_SIZE_byte
	dec ecx
	jnz .table_check

	clc
	jmp .table_end

.table_not_empty:
	stc

.table_end:
	pop rdi
	pop rcx
	ret

kernel_page_drain:
	push rcx
	mov  rcx, KERNEL_PAGE_SIZE_byte
	call .proceed
	pop  rcx
	ret

.proceed:
	push rax
	push rdi
	xor  rax, rax
	shr  rcx, STATIC_DIVIDE_BY_8_shift
	and  di, KERNEL_PAGE_mask
	rep  stosq
	pop  rdi
	pop  rax
	ret

kernel_page_drain_few:
	push rcx
	shl  rcx, KERNEL_PAGE_SIZE_shift
	call kernel_page_drain.proceed
	pop  rcx
	ret

kernel_page_map_physical:
	push rcx
	push rdx
	push rdi
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push rax

	call kernel_page_prepare
	jc   .error

	or ax, bx

.row:
	cmp r12, KERNEL_PAGE_RECORDS_amount
	jb  .exist

	call kernel_page_pml1

.exist:
	stosq
	add rax, KERNEL_PAGE_SIZE_byte
	inc r12
	dec rcx
	jnz .row

	clc
	jmp .end

.error:
	stc

.end:
	pop rax
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop rdi
	pop rdx
	pop rcx
	ret

kernel_page_map_logical:
	push rax
	push rcx
	push rdx
	push rdi
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15

	call kernel_page_prepare

.record:
	cmp r12, KERNEL_PAGE_RECORDS_amount
	jb  .exists

	call kernel_page_pml1

.exists:
	cmp qword [rdi], STATIC_EMPTY
	je  .no

	add rdi, STATIC_QWORD_SIZE_byte
	jmp .continue

.no:
	push rdi
	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain
	add  di, bx
	pop  rax
	xchg rdi, rax
	stosq

.continue:
	inc r12
	dec rcx
	jnz .record

.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop rdi
	pop rdx
	pop rcx
	pop rax
	ret

.error:
	stc
	jmp .end

kernel_page_prepare:
	push rax
	push rcx
	push rdx

	mov rcx, KERNEL_PAGE_PML3_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r15, rax
	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r11, rax

	cmp qword [r11], STATIC_EMPTY
	je  .no_pml3

	mov rax, qword [r11]
	xor al, al
	mov r10, rax
	jmp .pml3

.no_pml3:
	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain
	mov  r10, rdi
	mov  qword [r11], rdi
	or   word [r11], bx
	inc  qword [kernel_page_paged_count]

.pml3:
	inc r15
	add r11, STATIC_QWORD_SIZE_byte

	mov rax, rdx
	mov rcx, KERNEL_PAGE_PML2_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r14, rax
	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r10, rax

	cmp qword [r10], STATIC_EMPTY
	je  .no_pml2

	mov rax, qword [r10]
	xor al, al
	mov r9, rax
	jmp .pml2

.no_pml2:
	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain
	mov  r9, rdi
	mov  qword [r10], rdi
	or   word [r10], bx
	inc  qword [kernel_page_paged_count]

.pml2:
	inc r14
	add r10, STATIC_QWORD_SIZE_byte

	mov rax, rdx
	mov rcx, KERNEL_PAGE_PML1_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r13, rax
	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r9, rax

	cmp qword [r9], STATIC_EMPTY
	je  .no_pml1

	mov rax, qword [r9]
	xor al, al
	mov r8, rax
	jmp .pml1

.no_pml1:
	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain
	mov  r8, rdi
	mov  qword [r9], rdi
	or   word [r9], bx
	inc  qword [kernel_page_paged_count]

.pml1:
	inc r13
	add r9, STATIC_QWORD_SIZE_byte

	mov rax, rdx
	mov rcx, KERNEL_PAGE_SIZE_byte
	xor rdx, rdx
	div rcx

	mov r12, rax
	shl rax, STATIC_MULTIPLE_BY_8_shift
	add r8, rax

	mov rdi, r8

.end:
	pop rdx
	pop rcx
	pop rax
	ret

kernel_page_pml1:
	cmp r13, KERNEL_PAGE_RECORDS_amount
	je  .pml3

	cmp qword [r9], STATIC_EMPTY
	je  .pml2_create

	mov rdi, qword [r9]
	jmp .pml2_continue

.pml2_create:
	call kernel_memory_alloc_page
	jc   .error

	call kernel_page_drain
	or   di, bx
	mov  qword [r9], rdi
	inc  qword [kernel_page_paged_count]

.pml2_continue:
	and di, KERNEL_PAGE_mask
	mov r8, rdi
	xor r12, r12
	add r9, STATIC_QWORD_SIZE_byte
	inc r13
	ret

.pml3:
	cmp r14, KERNEL_PAGE_RECORDS_amount
	je  .pml4

	cmp qword [r10], STATIC_EMPTY
	je  .pml3_create

	mov rdi, qword [r10]
	jmp .pml3_continue

.pml3_create:
	call kernel_memory_alloc_page
	jc   .error

	call kernel_page_drain
	or   di, bx
	mov  qword [r10], rdi
	inc  qword [kernel_page_paged_count]

.pml3_continue:
	and di, KERNEL_PAGE_mask
	mov r9, rdi
	xor r13, r13
	add r10, STATIC_QWORD_SIZE_byte
	inc r14
	jmp kernel_page_pml1

.pml4:
	cmp r15, KERNEL_PAGE_RECORDS_amount
	je  .error

	cmp qword [r11], STATIC_EMPTY
	je  .pml4_create

	mov rdi, qword [r11]
	jmp .pml4_continue

.pml4_create:
	call kernel_memory_alloc_page
	jc   .error

	call kernel_page_drain
	or   di, bx
	mov  qword [r11], rdi
	inc  qword [kernel_page_paged_count]

.pml4_continue:
	and di, KERNEL_PAGE_mask
	mov r10, rdi
	xor r14, r14
	add r11, STATIC_QWORD_SIZE_byte
	inc r15
	jmp .pml3

.error:
	stc
	ret

kernel_page_merge:
	push rbx
	mov  rbx, 4

.inner:
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	cmp rdi, rsi
	je  .copy

	dec rbx
	mov rcx, KERNEL_PAGE_RECORDS_amount

.loop:
	cmp qword [rsi], STATIC_EMPTY
	je  .next

	cmp qword [rdi], STATIC_EMPTY
	ja  .compare

	mov rax, qword [rsi]
	mov qword [rdi], rax

.compare:
	cmp rbx, STATIC_EMPTY
	je  .next

	push rsi
	push rdi

	mov rsi, qword [rsi]
	mov rdi, qword [rdi]

	test rsi, rdi
	jnz  .the_same

	and  si, KERNEL_PAGE_mask
	and  di, KERNEL_PAGE_mask
	call .inner

.the_same:
	pop rdi
	pop rsi

.next:
	add rsi, STATIC_QWORD_SIZE_byte
	add rdi, STATIC_QWORD_SIZE_byte
	dec rcx
	jnz .loop

.copy:
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	cmp rbx, 4
	jne .return

	pop rbx

.return:
	ret

kernel_page_secure:
	push rax
	call kernel_memory_lock

	mov rax, qword [kernel_page_free_count]
	sub rax, qword [kernel_page_reserved_count]
	jz  .error

	cmp rax, rcx
	jb  .error

	sub qword [kernel_page_free_count], rcx
	add qword [kernel_page_reserved_count], rcx
	clc
	jmp .end

.error:
	stc

.end:
	mov byte [kernel_memory_lock_semaphore], STATIC_FALSE
	pop rax
	ret

kernel_page_release_pml:
	dec rbx
	mov rcx, KERNEL_PAGE_RECORDS_amount

	cmp rbx, 0x01
	je  .continue

.loop:
	push rcx
	push rdi

	cmp qword [rdi], STATIC_EMPTY
	je  .empty

	mov rdi, qword [rdi]
	and di, KERNEL_PAGE_mask

	push rdi
	call kernel_page_release_pml
	pop  rdi

	call kernel_memory_release_page
	dec  qword [kernel_page_paged_count]
	inc  rbx

.empty:
	pop rdi
	pop rcx
	add rdi, STATIC_QWORD_SIZE_byte
	dec rcx
	jnz .loop

.end:
	ret

.continue:
	cmp qword [rdi], STATIC_EMPTY
	jne .after

.next:
	add rdi, STATIC_QWORD_SIZE_byte
	dec rcx
	jnz .continue
	ret

.after:
	push rdi
	mov  rdi, qword [rdi]
	and  di, KERNEL_PAGE_mask
	call kernel_memory_release_page
	pop  rdi
	jmp  .next
