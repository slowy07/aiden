; Prepare ethernet frame
service_network_ethernet_wrap:
	push rax ; Save rax register on stack

	mov qword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.target], rax ; Set target MAC address

	mov rax, qword [driver_nic_i82540em_mac_address] ; Load source MAC address
	mov qword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source], rax ; Set source MAC address

	; Set Ethernet frame type (IP, ARP, etc.)
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], cx

	pop rax ; Restore rax register

	ret ; Return from function

macro_debug "service_network_ethernet_wrap"

; Prepares an IP packet
service_network_ip_wrap:
	; Save the registers
	push rcx
	push rax

	; Set IP version (IPv4) and header length
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl], SERVICE_NETWORK_FRAME_IP_VERSION_4 | SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_default

	; Set Differentiated Services Code Point (DSCP) to 0
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.dscp_and_ecn], STATIC_EMPTY

	add cx, SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE ; Calculate total length of IP packet
	rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift ; Adjust byte order
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.total_length], cx ; Set total length

	inc word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.identification] ; Increment packet ID
	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.identification] ; Load new ID
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.identification], ax ; Set identification field

	; Set "Do Not Fragment" flag
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.f_and_f], SERVICE_NETWORK_FRAME_IP_F_AND_F_do_not_fragment
	; Set Time-To-Live (TTL)
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.ttl], SERVICE_NETWORK_FRAME_IP_TTL_default
	; Set protocol type (TCP, UDP, etc.)
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], bl
	; Clear checksum field for now
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], STATIC_EMPTY
	; Set source IP
	mov eax, dword [driver_nic_i82540em_ipv4_address] ; Load source IP address
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address], eax ; Set source IP

	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4] ; Load destination IP address
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.destination_address], eax ; Set destination IP

	xor  eax, eax ; Clear eax for checksum calculation
	mov  ecx, SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE >> STATIC_DIVIDE_BY_2_shift ; Set size of header for checksum calculation
	add  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE ; Adjust pointer to IP header
	call service_network_checksum ; Compute checksum
	rol  ax, STATIC_REPLACE_AL_WITH_HIGH_shift ; Adjust byte order
	sub  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE ; Reset pointer
	mov  word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], ax ; Store checksum

	pop  rax ; Restore rax register
	mov  cx, SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip ; Set Ethernet frame type to IP
	call service_network_ethernet_wrap ; Wrap in Ethernet frame

	pop rcx ; Restore rcx register

	ret ; Return from function

macro_debug "service_network_ip_wrap"

; Prepares a TCP segment
service_network_tcp_wrap:
	; Save registers
	push rax
	push rbx
	push rcx
	push rdi

	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port] ; Load source port
	; Set source port
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source], ax
	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port]
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target], ax

	mov   eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence] ; Load sequence number
	bswap eax ; Convert to network byte order
	mov   dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence], eax

	mov   eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence] ; Load acknowledgment number
	bswap eax ; Convert to network byte order
	mov   dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.acknowledgement], eax

	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.header_length], bl

	mov al, byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags] ; Load TCP flags
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], al

	mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.window_size] ; Load window size
	rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift ; Adjust byte order
	; Set window size
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.window_size], ax

	; Clear checksum field
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.checksum_and_urgent_pointer], STATIC_EMPTY

	call service_network_tcp_pseudo_header ; Compute pseudo-header for checksum

	shr  ecx, STATIC_DIVIDE_BY_2_shift ; Adjust size for checksum calculation
	; Move pointer to TCP header
	add  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
	call service_network_checksum ; Compute TCP checksum
	rol  ax, STATIC_REPLACE_AL_WITH_HIGH_shift ; Adjust byte order
	mov  word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.checksum], ax ; Store checksum

	mov  rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac] ; Load source MAC address
	mov  bl, SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP ; Set protocol to TCP
	shl  ecx, STATIC_MULTIPLE_BY_2_shift ; Adjust total segment size
	; Reset pointer
	sub  rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
	call service_network_ip_wrap ; Wrap in IP packet

	; Restore register
	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret ; Return from function

macro_debug "service_network_tcp_wrap"
