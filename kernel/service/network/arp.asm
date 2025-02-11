service_network_arp:
	; Save the RAX register
	push rax

	; Check if the ARP hardware type is Ethernet (HTYPE = 1)
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.htype], SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet
	jne .omit ; If not, skip processing

	; Check if the ARP protocol type is IPv4 (PTYPE = 0x0800)
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.ptype], SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4
	jne .omit ; If not, skip processing

	; Check if the hardware address length is 6 bytes (MAC address)
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.hal], SERVICE_NETWORK_FRAME_ARP_HAL_mac
	jne .omit ; If not, skip processing

	; Check if the protocol address length is 4 bytes (IPv4 address)
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.pal], SERVICE_NETWORK_FRAME_ARP_PAL_ipv4
	jne .omit ; If not, skip processing

	; Check if the target IP address in the ARP request matches our IP address
	mov eax, dword [driver_nic_i82540em_ipv4_address]
	cmp eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_ip]
	jne .omit ; If not, skip processing

	; Save the RDI register
	push rdi

	; Allocate a page for the ARP response
	call kernel_memory_alloc_page
	jc   .error ; If allocation fails, jump to .error

	; Set the Ethernet frame type to ARP
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
	; Set the ARP hardware type to Ethernet
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.htype], SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet
	; Set the ARP protocol type to IPv4
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.ptype], SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4
	; Set the hardware address length to 6 bytes (MAC address)
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.hal], SERVICE_NETWORK_FRAME_ARP_HAL_mac
	; Set the protocol address length to 4 bytes (IPv4 address)
	mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.pal], SERVICE_NETWORK_FRAME_ARP_PAL_ipv4
	; Set the ARP opcode to "reply"
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.opcode], SERVICE_NETWORK_FRAME_ARP_OPCODE_answer
	; Set the source IP address in the ARP response to our IP address
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_ip], eax

	; Set the target IP address in the ARP response to the sender's IP address
	mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_ip]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_ip], eax
	
	; Set the source MAC address in the Ethernet frame and ARP response to our MAC address
	mov rax, qword [driver_nic_i82540em_mac_address]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source], eax
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac], eax
	shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source + SERVICE_NETWORK_STRUCTURE_MAC.4], ax
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac + SERVICE_NETWORK_STRUCTURE_MAC.4], ax

	; Set the target MAC address in the ARP response to the sender's MAC address
	mov rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac]
	mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_mac], eax
	shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
	mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_mac + SERVICE_NETWORK_STRUCTURE_MAC.4], ax

	; Wrap the ARP response in an Ethernet frame
	mov  rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac]
	mov  cx, SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
	call service_network_ethernet_wrap

	; Send the ARP response
	mov  eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.SIZE
	call service_network_transfer

.error:
	; Restore the RDI register
	pop rdi

.omit:
	; Restore the RAX register
	pop rax

	; Jump to the end of the network service handler
	jmp service_network.end

; Debug macro to mark the end of the ARP handler
macro_debug "service_network_arp"