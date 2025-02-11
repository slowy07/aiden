%include "kernel/service/network/wrap.asm"

; Process incoming TCP packets
service_network_tcp:
	; Save registers
	push rax
	push rcx
	push rdx

	; Extract destination from TCP header
	movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	rol   ax, STATIC_REPLACE_AL_WITH_HIGH_shift

	; Check if the port number is valid (below 512)
	cmp ax, 512
	jnb .end

	; Calculate port table index
	mov ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
	mul ecx
	add rax, qword [service_network_port_table]

	; Check if the port entry is empty
	cmp qword [rax], STATIC_EMPTY
	je  .end

	; Check for TCP SYN flag (connection initiation)
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_syn
	je  service_network_tcp_syn

	; Find existing connection
	call service_network_tcp_find
	jc   .end

	; Check for TCP ACK flag (acknowledgment)
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	je  service_network_tcp_ack

	; Check for TCP FIN flag (connection termination)
	test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_fin
	jnz  service_network_tcp_fin

	; Check for TCP PSH flag (data push)
	test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh
	jnz  service_network_tcp_psh

.end:
	; Restore registers
	pop rdx
	pop rcx
	pop rax

	jmp service_network.end

macro_debug "service_network_tcp"

; Handle TCP PSH flag
service_network_tcp_psh:
	; Save registers	
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi

	; Extract destination port
	movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	rol   ax, STATIC_REPLACE_AL_WITH_HIGH_shift
	mov   ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
	mul   ecx

	; Compute total length of IP packet
	movzx ecx, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.total_length]
	rol   cx, STATIC_REPLACE_AL_WITH_HIGH_shift
	sub   cx, bx

	push rcx

	; Compute TCP header length
	movzx edx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.header_length]
	shr   dl, STATIC_MOVE_AL_HALF_TO_HIGH_shift
	shl   dx, STATIC_MULTIPLE_BY_4_shift

	mov rdi, rsi

	; Adjust source pointer to start of payload
	add rsi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
	add rsi, rbx
	add rsi, rdx

	; Move payload data to stack
	rep movsb

	; Clear remaining space in the buffer
	mov rcx, KERNEL_PAGE_SIZE_byte
	sub rcx, qword [rsp]
	rep stosb

	; Lookup connection entry
	mov rbx, qword [service_network_port_table]
	mov rbx, qword [rbx + rax]

	; Insert packet into IPC system
	xor  ecx, ecx
	mov  rsi, rsp
	call kernel_ipc_insert

	; Cleanup stack
	add rsp, STATIC_QWORD_SIZE_byte

	mov qword [rsp], STATIC_EMPTY

.end:
	; Restore registers
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end

macro_debug "service_network_tcp_psh_ack"

; Handle TCP FIN flag
service_network_tcp_fin:
	; Save Register
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	xchg rsi, rdi ; Swap source and destination pointers

	; Remove ACK flag from request flags
	and byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	; Get the sequence number from the received TCP FIN packet
	mov   eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
	bswap eax ; Convert endianness
	inc   eax ; Increment sequence number

	; Set acknowledgment number to expected next sequence
	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement]
	inc eax
	mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence], eax

	; Prepare next acknowledgment number
	inc eax
	mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement], eax

	; Set flags to FIN + ACK
	mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack | SERVICE_NETWORK_FRAME_TCP_FLAGS_fin

	; Mark that an acknowledgment is required
	mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	; Allocate memory for response frame
	call kernel_memory_alloc_page
	jc   .error ; Jump to error handling if allocation fails

	; Prepare TCP header size
	mov  bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	call service_network_tcp_wrap

	; Send the TCP FIN-ACK response
	mov  eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
	call service_network_transfer

	jmp .end ; Jump to end

.error:
	; Mark connection as empty in case of failure
	mov byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], STATIC_EMPTY

.end:
	; Restore register
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end ; Return to main handler


macro_debug "service_network_tcp_fin"

; Handle TCP ACK flag
service_network_tcp_ack:
	; Save registers
	push rsi
	push rdi

	; Check if an acknowledgment is requested
	test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	jz   .end ; If not set, exit

	; Remove ACK flag from request flags
	and word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	; Check if both FIN and ACK flags are set
	test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_fin | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	jz   .end ; If not set, exit

	; Clear all flags (connection closure completed)
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], STATIC_EMPTY

.end:
	; Restore registers
	pop rdi
	pop rsi

	jmp service_network_tcp.end ; Return to main handler

macro_debug "service_network_tcp_ack"

; Find activate TCP connection
service_network_tcp_find:
	; Save register
	push rax
	push rcx
	push rbx
	push rdi

	; Extract IP header length fromm incoming packet
	movzx ebx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
	and   bl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
	shl   bl, STATIC_MULTIPLE_BY_4_shift

	; Calculate number of TCP stack entries
	mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
	mov rdi, qword [service_network_stack_address]

.loop:
	; Compare source Mac address
	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
	rol rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source + SERVICE_NETWORK_STRUCTURE_MAC.4]
	ror rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
	cmp qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rax
	jne .next

	; Compare source IPv4 address
	mov eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
	cmp dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address], eax
	jne .next

	; Compare target port
	mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port]
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target], ax
	jne .next

	; Compare source port
	mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port]
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source], ax
	je  .found

.next:
	add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE ; Move to next entry

	dec rcx
	jnz .loop

	stc ; Set carry flag to indicate failure

	jmp .end

.found:
	mov qword [rsp + STATIC_QWORD_SIZE_byte], rbx ; Store hgeader length
	mov qword [rsp], rdi ; Store found stack entry

.end:
	; Restore register
	pop rdi
	pop rbx
	pop rcx
	pop rax

	ret	; Return to function

macro_debug "service_network_tcp_find"

; Handle incoming TCP SYN requests
service_network_tcp_syn:
	; Save registers
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	; Calculate number of TCP stack entries
	mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
	mov rdi, qword [service_network_stack_address]

.search:
	; Check if slot is free
	lock bts word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], SERVICE_NETWORK_STACK_FLAG_busy
	jnc  .found ; If free, use this slot

	add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE ; Move to next entry

	dec rcx
	jnz .search

	jmp .end ; If no free slots, exit

.found:
	; Extract IP header length
	movzx ecx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
	and   cl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
	shl   cl, STATIC_MULTIPLE_BY_4_shift

	add ecx, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE

	; Store target port
	mov ax, word [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port], ax

	; Store source port
	mov ax, word [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source]
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port], ax

	; Store sequence number
	mov   eax, dword [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
	bswap eax
	mov   dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence], eax

	; Store source MAC address
	mov rcx, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
	shl rcx, STATIC_MOVE_AX_TO_HIGH_shift
	shr rcx, STATIC_MOVE_HIGH_TO_AX_shift
	mov qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rcx

	; Store source IPv4 address
	mov ecx, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4], ecx

	; Initialize sequence numbers and window size
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence], STATIC_EMPTY
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.window_size], SERVICE_NETWORK_FRAME_TCP_WINDOW_SIZE_default

	; Set SYN-ACK response flags
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_syn | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	; Respond to the SYN request
	mov rsi, rdi

	call service_network_tcp_reply

.end:
	; Restore registers
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	jmp service_network_tcp.end ; Return to main handler

macro_debug "service_network_tcp_syn"

service_network_tcp_reply:
	; Save registers
	push rax
	push rbx
	push rcx
	push rdi

	call kernel_memory_alloc_page ; Allocate a memory page for TCP reply

	mov  bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	call service_network_tcp_wrap ; Wrap the TCP segment properly

	mov  eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
	call service_network_transfer ; Transfer the constructed network packet

	pop rdi ; Restore rdi register from stack
	pop rcx ; Restore rcx register from stack
	pop rbx ; Restore rbx register from stack
	pop rax ; Restore rax register from stack

	ret ; Return from function

service_network_tcp_pseudo_header:
	push rcx ; Save rcx register on stack
	push rdi ; Save rdi register on stack

	mov eax, dword [driver_nic_i82540em_ipv4_address]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.source_ipv4], eax

	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4] ; Load source IPv4 address from stack
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.target_ipv4], eax

	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.reserved], STATIC_EMPTY

	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.protocol], SERVICE_NETWORK_FRAME_TCP_PROTOCOL_default

	rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift ; Rotate bits in cx for proper alignment
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.segment_length], cx

	xor  eax, eax ; Clear eax register
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE >> STATIC_DIVIDE_BY_2_shift
	add  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE
	call service_network_checksum_part ; Compute checksum

	pop rdi ; Restore rdi register from stack
	pop rcx ; Restore rcx register from stack

	ret ; Return from function

macro_debug "service_network_tcp_pseudo_header"

service_network_tcp_port_assign:
	; Save register
	push rax
	push rcx
	push rdx
	push rdi

	macro_lock service_network_port_semaphore, 0 ; Lock the semaphore to prevent race conditions

	cmp cx, 512 ; Check if the requested port is valid (less than 512)
	jnb .error ; If port is invalid, jump to error handling

	mov eax, SERVICE_NETWORK_STRUCTURE_PORT.SIZE ; Load port structure size
	and ecx, STATIC_WORD_mask ; Mask out unnecessary bits from port number
	mul ecx ; Calculate offset in port table

	call kernel_task_active ; Get current active task
	mov  rcx, qword [rdi + KERNEL_TASK_STRUCTURE.pid] ; Load process ID

	mov  rdi, qword [service_network_port_table] ; Load port table address
	test rdi, rdi ; Check if port table is valid
	jz   .error ; If invalid, jump to error handling

	cmp qword [rdi + rcx + SERVICE_NETWORK_STRUCTURE_PORT.pid], STATIC_EMPTY ; Check if port is already assigned
	jne .error ; If assigned, jump to error handling

	mov qword [rdi + rax + SERVICE_NETWORK_STRUCTURE_PORT.pid], rcx ; Assign process ID to port

	jmp .end ; Jump to end

.error:
	stc ; Set carry flag to indicate error

.end:
	mov byte [service_network_port_semaphore], STATIC_FALSE ; Release semaphore

	; Restore registers
	pop rdi
	pop rdx
	pop rcx
	pop rax

	ret ; Return from function

macro_debug "service_network_tcp_port_assign"

service_network_tcp_port_send:
	; Save registers
	push rax
	push rbx
	push rcx
	push rsi
	push rdi

	call kernel_memory_alloc_page ; Allocate memory page for the transmision buffer
	jc   .end ; Jump to end if allocation failed

	push rcx ; Save rcx register
	push rdi ; Save rdi register

	; Adjust destination index to payload location
	add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
	rep movsb ; Copy data from source to destination

	pop rdi
	pop rcx

	; Increment host sequence number
	inc dword [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence]
	; Set flags for PUSH and ACK
	mov byte [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

	; Adjust data length
	add  rcx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + 0x01
	mov  rsi, rbx ; Set source index
	mov  bl, SERVICE_NETWORK_FRAME_TCP_HEADER_LENGTH_default ; Set TCP header length
	call service_network_tcp_wrap ; Wrap the TCP packet

	mov  rax, rcx ; Set length to rax
	add  rax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
	call service_network_transfer ; Transfer the packet over the network

.end:
	; Restore register
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	ret ; Return from function

macro_debug "service_network_tcp_port_send"