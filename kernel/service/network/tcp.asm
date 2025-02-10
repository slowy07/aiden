%include "kernel/service/network/wrap.asm"

service_network_tcp:
	push rax
	push rcx
	push rdx

	movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	rol   ax, STATIC_REPLACE_AL_WITH_HIGH_shift

	cmp ax, 512
	jnb .end

	mov ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
	mul ecx
	add rax, qword [service_network_port_table]
	cmp qword [rax], STATIC_EMPTY
	je  .end

	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_syn
	je  service_network_tcp_syn

	call service_network_tcp_find
	jc   .end

	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	je  service_network_tcp_ack

	test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_fin
	jnz  service_network_tcp_fin

	test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh
	jnz  service_network_tcp_psh

.end:
	pop rdx
	pop rcx
	pop rax

	jmp service_network.end

macro_debug "service_network_tcp"

service_network_tcp_psh:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi

	movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	rol   ax, STATIC_REPLACE_AL_WITH_HIGH_shift
	mov   ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
	mul   ecx

	movzx ecx, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.total_length]
	rol   cx, STATIC_REPLACE_AL_WITH_HIGH_shift
	sub   cx, bx

	push rcx

	movzx edx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.header_length]
	shr   dl, STATIC_MOVE_AL_HALF_TO_HIGH_shift
	shl   dx, STATIC_MULTIPLE_BY_4_shift

	mov rdi, rsi

	add rsi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
	add rsi, rbx
	add rsi, rdx

	rep movsb

	mov rcx, KERNEL_PAGE_SIZE_byte
	sub rcx, qword [rsp]
	rep stosb

	mov rbx, qword [service_network_port_table]
	mov rbx, qword [rbx + rax]

	xor  ecx, ecx
	mov  rsi, rsp
	call kernel_ipc_insert

	add rsp, STATIC_QWORD_SIZE_byte

	mov qword [rsp], STATIC_EMPTY

.end:
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end

macro_debug "service_network_tcp_psh_ack"

service_network_tcp_fin:
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	xchg rsi, rdi

	and byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	mov   eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
	bswap eax
	inc   eax

	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement]
	inc eax
	mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence], eax

	inc eax
	mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement], eax

	mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack | SERVICE_NETWORK_FRAME_TCP_FLAGS_fin

	mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	call kernel_memory_alloc_page
	jc   .error

	mov  bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	call service_network_tcp_wrap

	mov  eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
	call service_network_transfer

	jmp .end

.error:
	mov byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], STATIC_EMPTY

.end:
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end

macro_debug "service_network_tcp_fin"

service_network_tcp_ack:
	push rsi
	push rdi

	test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	jz   .end

	and word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_fin | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	jz   .end

	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], STATIC_EMPTY

.end:
	pop rdi
	pop rsi

	jmp service_network_tcp.end

macro_debug "service_network_tcp_ack"

service_network_tcp_find:
	push rax
	push rcx
	push rbx
	push rdi

	movzx ebx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
	and   bl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
	shl   bl, STATIC_MULTIPLE_BY_4_shift

	mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
	mov rdi, qword [service_network_stack_address]

.loop:
	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
	rol rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source + SERVICE_NETWORK_STRUCTURE_MAC.4]
	ror rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
	cmp qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rax
	jne .next

	mov eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
	cmp dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address], eax
	jne .next

	mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port]
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target], ax
	jne .next

	mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port]
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source], ax
	je  .found

.next:
	add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE

	dec rcx
	jnz .loop

	stc

	jmp .end

.found:
	mov qword [rsp + STATIC_QWORD_SIZE_byte], rbx

	mov qword [rsp], rdi

.end:
	pop rdi
	pop rbx
	pop rcx
	pop rax

	ret

macro_debug "service_network_tcp_find"

service_network_tcp_syn:
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
	mov rdi, qword [service_network_stack_address]

.search:
	lock bts word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], SERVICE_NETWORK_STACK_FLAG_busy
	jnc  .found

	add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE

	dec rcx
	jnz .search

	jmp .end

.found:
	movzx ecx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
	and   cl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
	shl   cl, STATIC_MULTIPLE_BY_4_shift

	add ecx, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE

	mov ax, word [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port], ax

	mov ax, word [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source]
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port], ax

	mov   eax, dword [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
	bswap eax
	mov   dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence], eax

	mov rcx, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
	shl rcx, STATIC_MOVE_AX_TO_HIGH_shift
	shr rcx, STATIC_MOVE_HIGH_TO_AX_shift
	mov qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rcx

	mov ecx, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4], ecx

	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence], STATIC_EMPTY

	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.window_size], SERVICE_NETWORK_FRAME_TCP_WINDOW_SIZE_default

	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_syn | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	mov rsi, rdi

	call service_network_tcp_reply

.end:
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end

macro_debug "service_network_tcp_syn"

service_network_tcp_reply:
	push rax
	push rbx
	push rcx
	push rdi

	call kernel_memory_alloc_page

	mov  bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	call service_network_tcp_wrap

	mov  eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
	call service_network_transfer

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

service_network_tcp_pseudo_header:
	push rcx
	push rdi

	mov eax, dword [driver_nic_i82540em_ipv4_address]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.source_ipv4], eax

	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.target_ipv4], eax

	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.reserved], STATIC_EMPTY

	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.protocol], SERVICE_NETWORK_FRAME_TCP_PROTOCOL_default

	rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.segment_length], cx

	xor  eax, eax
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE >> STATIC_DIVIDE_BY_2_shift
	add  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE
	call service_network_checksum_part

	pop rdi
	pop rcx

	ret

macro_debug "service_network_tcp_pseudo_header"

service_network_tcp_port_assign:
	push rax
	push rcx
	push rdx
	push rdi

	macro_lock service_network_port_semaphore, 0

	cmp cx, 512
	jnb .error

	mov eax, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
	and ecx, STATIC_WORD_mask
	mul ecx

	call kernel_task_active
	mov  rcx, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	mov  rdi, qword [service_network_port_table]
	test rdi, rdi
	jz   .error

	cmp qword [rdi + rcx + SERVICE_NETWORK_STRUCTURE_PORT.pid], STATIC_EMPTY
	jne .error

	mov qword [rdi + rax + SERVICE_NETWORK_STRUCTURE_PORT.pid], rcx

	jmp .end

.error:
	stc

.end:
	mov byte [service_network_port_semaphore], STATIC_FALSE

	pop rdi
	pop rdx
	pop rcx
	pop rax

	ret

macro_debug "service_network_tcp_port_assign"

service_network_tcp_port_send:
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	call kernel_memory_alloc_page
	jc   .end

	push rcx
	push rdi

	add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	rep movsb

	pop rdi
	pop rcx

	inc dword [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence]
	mov byte [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	add  rcx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + 0x01
	mov  rsi, rbx
	mov  bl, SERVICE_NETWORK_FRAME_TCP_HEADER_LENGTH_default
	call service_network_tcp_wrap

	mov  rax, rcx
	add  rax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
	call service_network_transfer

.end:
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "service_network_tcp_port_send"
