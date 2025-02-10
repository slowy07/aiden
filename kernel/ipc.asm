KERNEL_IPC_SIZE_page_default equ 1
KERNEL_IPC_ENTRY_limit equ (KERNEL_IPC_SIZE_page_default << KERNEL_PAGE_SIZE_shift) / KERNEL_IPC_STRUCTURE.SIZE

KERNEL_IPC_TTL_default equ DRIVER_RTC_Hz / 10

struc KERNEL_IPC_STRUCTURE
.ttl  resb 8
.pid_source  resb 8
.pid_destination resb 8

.data:
	.size    resb 8
	.pointer resb 8
	.other   resb 24

.SIZE:
	endstruc

	kernel_ipc_semaphore db STATIC_FALSE
	kernel_ipc_base_address dq STATIC_EMPTY
	kernel_ipc_entry_count dq STATIC_EMPTY

kernel_ipc_insert:
	push rax
	push rdx
	push rsi
	push rdi
	push rcx

	call kernel_task_active
	mov  rdx, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	macro_lock kernel_ipc_semaphore, 0

.wait:
	cmp qword [kernel_ipc_entry_count], KERNEL_IPC_ENTRY_limit
	jne .reload

	xchg bx, bx
	jmp  $

.reload:
	mov rax, qword [driver_rtc_microtime]

	mov rcx, KERNEL_IPC_ENTRY_limit

	mov rdi, qword [kernel_ipc_base_address]

.loop:
	cmp rax, qword [rdi + KERNEL_IPC_STRUCTURE.ttl]
	ja  .found

	add rdi, KERNEL_IPC_STRUCTURE.SIZE

	dec rcx
	jnz .loop

	stc

	jmp .error

.found:
	mov qword [rdi + KERNEL_IPC_STRUCTURE.pid_source], rdx

	mov qword [rdi + KERNEL_IPC_STRUCTURE.pid_destination], rbx

	mov rcx, qword [rsp]

	test rcx, rcx
	jz   .load

	mov qword [rdi + KERNEL_IPC_STRUCTURE.size], rcx

	mov qword [rdi + KERNEL_IPC_STRUCTURE.pointer], rsi

	jmp .end

.load:
	push rdi

	mov ecx, KERNEL_IPC_STRUCTURE.SIZE - KERNEL_IPC_STRUCTURE.data
	add rdi, KERNEL_IPC_STRUCTURE.data
	rep movsb

	pop rdi

.end:
	inc qword [kernel_ipc_entry_count]

	add rax, KERNEL_IPC_TTL_default
	mov qword [rdi + KERNEL_IPC_STRUCTURE.ttl], rax

.error:
	mov byte [kernel_ipc_semaphore], STATIC_FALSE

	pop rcx
	pop rdi
	pop rsi
	pop rdx
	pop rax

	ret

macro_debug "kernel_ipc_insert"

kernel_ipc_receive:
	push rax
	push rcx
	push rsi
	push rdi

	cmp qword [kernel_ipc_entry_count], STATIC_EMPTY
	je  .empty

	call kernel_task_active
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	mov rcx, KERNEL_IPC_ENTRY_limit

	mov rsi, qword [kernel_ipc_base_address]

	mov rdi, qword [driver_rtc_microtime]

.loop:
	cmp qword [rsi + KERNEL_IPC_STRUCTURE.pid_destination], rax
	jne .next

	cmp rdi, qword [rsi + KERNEL_IPC_STRUCTURE.ttl]
	jbe .found

.next:
	add rsi, KERNEL_IPC_STRUCTURE.SIZE

	dec rcx
	jnz .loop

.empty:
	stc

	jmp .error

.found:
	mov ecx, KERNEL_IPC_STRUCTURE.SIZE
	mov rdi, qword [rsp]
	rep movsb

	mov qword [rsi - KERNEL_IPC_STRUCTURE.SIZE], STATIC_EMPTY

	dec qword [kernel_ipc_entry_count]

	clc

.error:
	pop rdi
	pop rsi
	pop rcx
	pop rax

	ret

macro_debug "kernel_ipc_receive"
