KERNEL_TASK_EFLAGS_if equ 000000000000001000000000b
KERNEL_TASK_EFLAGS_zf equ 000000000000000001000000b
KERNEL_TASK_EFLAGS_cf equ 000000000000000000000001b
KERNEL_TASK_EFLAGS_df equ 000000000000010000000000b
KERNEL_TASK_EFLAGS_default equ KERNEL_TASK_EFLAGS_if

KERNEL_TASK_FLAG_active equ 0000000000000001b
KERNEL_TASK_FLAG_closed equ 0000000000000010b
KERNEL_TASK_FLAG_service equ 0000000000000100b
KERNEL_TASK_FLAG_processing equ 0000000000001000b
KERNEL_TASK_FLAG_secured equ 0000000000010000b
KERNEL_TASK_FLAG_thread equ 0000000000100000b

KERNEL_TASK_FLAG_active_bit equ 0
KERNEL_TASK_FLAG_closed_bit equ 1
KERNEL_TASK_FLAG_service_bit equ 2
KERNEL_TASK_FLAG_processing_bit equ 3
KERNEL_TASK_FLAG_secured_bit equ 4
KERNEL_TASK_FLAG_thread_bit equ 5

KERNEL_TASK_STACK_address equ (KERNEL_MEMORY_HIGH_VIRTUAL_address << STATIC_MULTIPLE_BY_2_shift) - (KERNEL_TASK_STACK_SIZE_page << STATIC_MULTIPLE_BY_PAGE_shift)
KERNEL_TASK_STACK_SIZE_page equ 1

struc   KERNEL_TASK_STRUCTURE
.cr3    resb 8
.rsp    resb 8
.cpu    resb 8
.pid    resb 8
.time   resb 8
.knot   resb 8
.map    resb 8
.map_size   resb 8
.flags  resb 2
.stack  resb 2
.length resb 1
.name   resb 255

.SIZE:
	endstruc

	struc   KERNEL_TASK_STRUCTURE_IRETQ
	.rip    resb 8
	.cs     resb 8
	.eflags resb 8
	.rsp    resb 8
	.ds     resb 8
	endstruc

	kernel_task_debug_semaphore db STATIC_FALSE
	kernel_task_address dq STATIC_EMPTY
	kernel_task_size_page dq KERNEL_TASK_STACK_SIZE_page
	kernel_task_count dq STATIC_EMPTY
	kernel_task_free dq ((KERNEL_TASK_STACK_SIZE_page << STATIC_MULTIPLE_BY_PAGE_shift) - (KERNEL_TASK_STACK_SIZE_page << STATIC_MULTIPLE_BY_QWORD_shift)) / KERNEL_TASK_STRUCTURE.SIZE
	kernel_task_active_list dq STATIC_EMPTY
	kernel_task_pid_semaphore db STATIC_FALSE
	kernel_task_pid dq STATIC_EMPTY

kernel_task:
	cli

	cmp byte [kernel_task_debug_semaphore], STATIC_FALSE
	je  .no

	xchg bx, bx

.no:
	push rax
	push rdi

	call kernel_apic_id_get

	push rbx
	push rcx
	push rdx
	push rsi
	push rbp
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15

	cld

	mov rbx, rax
	shl rbx, STATIC_MULTIPLE_BY_8_shift

	mov rsi, qword [kernel_task_active_list]
	mov rdi, qword [rsi + rbx]

	mov      rbp, KERNEL_STACK_pointer
	FXSAVE64 [rbp]

	mov qword [rdi + KERNEL_TASK_STRUCTURE.rsp], rsp

	push rax

	mov rax, cr3
	mov qword [rdi + KERNEL_TASK_STRUCTURE.cr3], rax

	mov qword [rdi + KERNEL_TASK_STRUCTURE.cpu], STATIC_EMPTY

	and word [rdi + KERNEL_TASK_STRUCTURE.flags], ~KERNEL_TASK_FLAG_processing

	movzx eax, di
	and   ax, ~KERNEL_PAGE_mask
	mov   rcx, KERNEL_TASK_STRUCTURE.SIZE
	xor   edx, edx
	div   rcx

	mov ecx, STATIC_STRUCTURE_BLOCK.link / KERNEL_TASK_STRUCTURE.SIZE

	sub rcx, rax

	pop rax

	jmp .next

.block:
	and di, KERNEL_PAGE_mask
	mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

.ap_entry:
	mov ecx, STATIC_STRUCTURE_BLOCK.link / KERNEL_TASK_STRUCTURE.SIZE

	jmp .check

.next:
	dec ecx
	jz  .block

	add rdi, KERNEL_TASK_STRUCTURE.SIZE

.check:
	test word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_secured
	jz   .next

	lock bts word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_processing_bit
	jc   .next

	test word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_active
	jnz  .active

	and word [rdi + KERNEL_TASK_STRUCTURE.flags], ~KERNEL_TASK_FLAG_processing

	jmp .next

.active:
	mov qword [rdi + KERNEL_TASK_STRUCTURE.cpu], rax

	mov qword [rsi + rbx], rdi

	mov rsp, qword [rdi + KERNEL_TASK_STRUCTURE.rsp]
	mov rax, qword [rdi + KERNEL_TASK_STRUCTURE.cr3]
	mov cr3, rax

	mov       rbp, KERNEL_STACK_pointer
	FXRSTOR64 [rbp]

	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rbp
	pop rsi
	pop rdx
	pop rcx
	pop rbx

.leave:
	mov rdi, qword [kernel_apic_base_address]
	mov dword [rdi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz

	mov dword [rdi + KERNEL_APIC_EOI_register], STATIC_EMPTY

	pop rdi
	pop rax

	sti

	iretq

	macro_debug "kernel_task"

kernel_task_add:
	push rax
	push rsi
	push rcx
	push rdi

	call kernel_task_queue
	jc   .end

	push rdi

	mov qword [rdi + KERNEL_TASK_STRUCTURE.cr3], r11

	mov rax, KERNEL_STACK_pointer - (STATIC_QWORD_SIZE_byte * 0x14)
	mov qword [rdi + KERNEL_TASK_STRUCTURE.rsp], rax

	call kernel_task_active
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.knot]

	pop rdi

	mov qword [rdi + KERNEL_TASK_STRUCTURE.knot], rax

	call kernel_task_pid_get

	mov qword [rdi + KERNEL_TASK_STRUCTURE.pid], rcx

	xchg rcx, qword [rsp + STATIC_QWORD_SIZE_byte]

	mov rax, qword [driver_rtc_microtime]
	mov qword [rdi + KERNEL_TASK_STRUCTURE.time], rax

	or word [rdi + KERNEL_TASK_STRUCTURE.flags], bx

	mov word [rdi + KERNEL_TASK_STRUCTURE.stack], KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift

	mov qword [rsp], rdi

	mov byte [rdi + KERNEL_TASK_STRUCTURE.length], cl

	and ecx, STATIC_BYTE_mask
	add rdi, KERNEL_TASK_STRUCTURE.name
	rep movsb

	clc

.end:
	pop rdi
	pop rcx
	pop rsi
	pop rax

	ret

macro_debug "kernel_task_add"

kernel_task_queue:
	push rax
	push rcx
	push rsi
	push rdi

	cmp qword [kernel_task_free], STATIC_EMPTY
	je  .error

	mov rdi, qword [kernel_task_address]

.restart:
	mov rcx, STATIC_STRUCTURE_BLOCK.link / KERNEL_TASK_STRUCTURE.SIZE

.next:
	lock bts word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_secured_bit
	jnc  .found

	add rdi, KERNEL_TASK_STRUCTURE.SIZE

	dec rcx
	jnz .next

	and di, KERNEL_PAGE_mask
	mov rsi, rdi

	mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

	cmp rdi, qword [kernel_task_address]
	jne .restart

	call kernel_memory_alloc_page
	jc   .error

	call kernel_page_drain
	mov  qword [rsi + STATIC_STRUCTURE_BLOCK.link], rdi

	mov rsi, qword [kernel_task_address]
	mov qword [rdi + STATIC_STRUCTURE_BLOCK.link], rsi

	inc qword [kernel_task_size_page]

	jmp .found

.error:
	add rsp, STATIC_QWORD_SIZE_byte

	stc

	jmp .end

.found:
	dec qword [kernel_task_free]

	inc qword [kernel_task_count]

	mov qword [rsp], rdi

.end:
	pop rdi
	pop rsi
	pop rcx
	pop rax

	ret

macro_debug "kernel_task_queue"

kernel_task_pid_get:
	macro_lock kernel_task_pid_semaphore, 0

.next:
	mov rcx, qword [kernel_task_pid]
	inc qword [kernel_task_pid]

	call kernel_task_pid_check
	jnc  .next

	mov byte [kernel_task_pid_semaphore], STATIC_FALSE

	ret

macro_debug "kernel_task_pid_get"

kernel_task_pid_check:
	push rax
	push rcx
	push rdi

	mov rdi, qword [kernel_task_address]

.restart:
	mov rax, STATIC_STRUCTURE_BLOCK.link / KERNEL_TASK_STRUCTURE.SIZE

.next:
	cmp qword [rdi + KERNEL_TASK_STRUCTURE.pid], rcx
	je  .found

.omit:
	add rdi, KERNEL_TASK_STRUCTURE.SIZE

	dec rax
	jnz .next

	and di, KERNEL_PAGE_mask
	mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

	cmp rdi, qword [kernel_task_address]
	jne .restart

.error:
	stc

	jmp .end

.found:
	cmp byte [rdi + KERNEL_TASK_STRUCTURE.flags], STATIC_EMPTY
	je  .omit

	bt word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_closed_bit

.end:
	pop rdi
	pop rcx
	pop rax

	ret

macro_debug "kernel_task_pid_check"

kernel_task_active_pid:
	push rdi

	call kernel_task_active

	mov rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	pop rdi

	ret

macro_debug "kernel_task_active_pid"

kernel_task_active:
	push rax

	cli

	call kernel_apic_id_get

	shl rax, STATIC_MULTIPLE_BY_8_shift
	mov rdi, qword [kernel_task_active_list]
	mov rdi, qword [rdi + rax]

	sti

	pop rax

	ret

macro_debug "kernel_task_active"

kernel_task_kill:
	call kernel_task_active

	and word [rdi + KERNEL_TASK_STRUCTURE.flags], ~KERNEL_TASK_FLAG_active
	or  word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_closed

	jmp $

macro_debug "kernel_task_kill_me"
