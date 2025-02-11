; MAC address mask (48 bits, lower 6 bytes of a 64-bit register)
SERVICE_NETWORK_MAC_mask equ 0x0000FFFFFFFFFFFF
; Size of a network port in pages (1 page = 4 KB)
SERVICE_NETWORK_PORT_SIZE_page equ 0x01

; Network port flags
SERVICE_NETWORK_PORT_FLAG_empty equ 000000001b ; Port is empty
SERVICE_NETWORK_PORT_FLAG_received equ 000000010b ; Port has received data
SERVICE_NETWORK_PORT_FLAG_send equ 000000100b  ; Port is ready to send data

; Bit positions for network port flags
SERVICE_NETWORK_PORT_FLAG_BIT_empty equ 0
SERVICE_NETWORK_PORT_FLAG_BIT_received equ 1
SERVICE_NETWORK_PORT_FLAG_BIT_send equ 2
; Size of the network stack in pages (1 page = 4 KB)
SERVICE_NETWORK_STACK_SIZE_page equ 0x01
; Network stack flags
SERVICE_NETWORK_STACK_FLAG_busy equ 10000000b ; Stack is busy
; Ethernet frame types
SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp equ 0x0608 ; ARP protocol (0x0806 in little-endian)
SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip equ 0x0008  ; IPv4 protocol (0x0800 in little-endian)
; ARP frame constants
SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet equ 0x0100 ; Hardware type: Ethernet (1)
SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4 equ 0x0008 ; Protocol type: IPv4 (0x0800 in little-endian)
SERVICE_NETWORK_FRAME_ARP_HAL_mac equ 0x06 ; Hardware address length: 6 bytes (MAC address)
SERVICE_NETWORK_FRAME_ARP_PAL_ipv4 equ 0x04 ; Protocol address length: 4 bytes (IPv4 address)
SERVICE_NETWORK_FRAME_ARP_OPCODE_request equ 0x0100 ; ARP opcode: Request (1)
SERVICE_NETWORK_FRAME_ARP_OPCODE_answer equ 0x0200 ; ARP opcode: Reply (2)
; IP frame constants
SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_default equ 0x05 ; Default IP header length (5 words = 20 bytes)
SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask equ 0x0F 
SERVICE_NETWORK_FRAME_IP_VERSION_mask equ 0xF0 ; Mask for IP version field
SERVICE_NETWORK_FRAME_IP_VERSION_4 equ 0x40 ; IP version: IPv4 (4)
SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP equ 0x01 ; IP protocol: ICMP
SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP equ 0x06 ; IP protocol: TCP
SERVICE_NETWORK_FRAME_IP_PROTOCOL_UDP equ 0x11 ; IP protocol: UDP
SERVICE_NETWORK_FRAME_IP_TTL_default equ 0x40 ; Default Time To Live (TTL) value
SERVICE_NETWORK_FRAME_IP_F_AND_F_do_not_fragment equ 0x0040 ; IP flags: Do Not Fragment (DF)
; ICMP frame constants
SERVICE_NETWORK_FRAME_ICMP_TYPE_REQUEST equ 0x08  ; ICMP type: Echo Request
SERVICE_NETWORK_FRAME_ICMP_TYPE_REPLY equ 0x00 ; ICMP type: Echo Reply
; TCP frame constants
SERVICE_NETWORK_FRAME_TCP_HEADER_LENGTH_default equ 0x50 ; Default TCP header length (5 words = 20 bytes)
SERVICE_NETWORK_FRAME_TCP_FLAGS_fin equ 0000000000000001b ; TCP flag: FIN (Finish)
SERVICE_NETWORK_FRAME_TCP_FLAGS_syn equ 0000000000000010b ; TCP flag: SYN (Synchronize)
SERVICE_NETWORK_FRAME_TCP_FLAGS_rst equ 0000000000000100b ; TCP flag: RST (Reset)
SERVICE_NETWORK_FRAME_TCP_FLAGS_psh equ 0000000000001000b ; TCP flag: PSH (Push)
SERVICE_NETWORK_FRAME_TCP_FLAGS_ack equ 0000000000010000b ; TCP flag: ACK (Acknowledge)
SERVICE_NETWORK_FRAME_TCP_FLAGS_urg equ 0000000000100000b ; TCP flag: URG (Urgent)
SERVICE_NETWORK_FRAME_TCP_FLAGS_bsy equ 0000100000000000b ; TCP flag: BSY (Busy)
SERVICE_NETWORK_FRAME_TCP_FLAGS_bsy_bit equ 11 ; Bit position for "BSY" flag
SERVICE_NETWORK_FRAME_TCP_OPTION_MSS_default equ 0xB4050402 ; Default TCP option: Maximum Segment Size (MSS)
SERVICE_NETWORK_FRAME_TCP_OPTION_KIND_mss equ 0x02 ; TCP option kind: MSS
SERVICE_NETWORK_FRAME_TCP_PROTOCOL_default equ 0x06 ; Default TCP protocol (6)
SERVICE_NETWORK_FRAME_TCP_WINDOW_SIZE_default equ 0x05B4 ; Default TCP window size (1460 bytes)

	; ; MAC address structure (6 bytes)
	struc SERVICE_NETWORK_STRUCTURE_MAC
	.0    resb 1 ; Byte 0 of the MAC address
	.1    resb 1 ; Byte 1 of the MAC address
	.2    resb 1 ; Byte 2 of the MAC address
	.3    resb 1 ; Byte 3 of the MAC address
	.4    resb 1 ; Byte 4 of the MAC address
	.5    resb 1 ; Byte 5 of the MAC address

.SIZE: ; Total size of the MAC address structure (6 bytes)
	endstruc

	; ; Ethernet frame structure
	struc   SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET
	.target resb 0x06 ; Destination MAC address (6 bytes)
	.source resb 0x06 ; Source MAC address (6 bytes)
	.type   resb 0x02 ; EtherType (2 bytes, e.g., 0x0800 for IPv4)

.SIZE: ; Total size of the Ethernet frame structure (14 bytes)
	endstruc

	; ARP frame structure 
	struc   SERVICE_NETWORK_STRUCTURE_FRAME_ARP
	.htype  resb 0x02 ; Hardware type (2 bytes, e.g., 1 for Ethernet)
	.ptype  resb 0x02 ; Protocol type (2 bytes, e.g., 0x0800 for IPv4)
	.hal    resb 0x01 ; Hardware address length (1 byte, e.g., 6 for MAC)
	.pal    resb 0x01 ; Protocol address length (1 byte, e.g., 4 for IPv4)
	.opcode resb 0x02 ; Opcode (2 bytes, e.g., 1 for request, 2 for reply)
	.source_mac resb 0x06 ; Source MAC address (6 bytes)
	.source_ip resb 0x04 ; Source IP address (4 bytes)
	.target_mac resb 0x06 ; Target MAC address (6 bytes)
	.target_ip resb 0x04 ; Target IP address (4 bytes)

.SIZE: ; Total size of the ARP frame structure (28 bytes)
	endstruc

	; IP frame structure
	struc           SERVICE_NETWORK_STRUCTURE_FRAME_IP
	.version_and_ihl    resb 0x01 ; Version (4 bits) + Header Length (4 bits)
	.dscp_and_ecn     resb 0x01  ; DSCP (6 bits) + ECN (2 bits)
	.total_length     resb 0x02 ; Total length of the IP packet (2 bytes)
	.identification resb 0x02 ; Identification (2 bytes)
	.f_and_f     resb 0x02 ; Flags (3 bits) + Fragment Offset (13 bits)
	.ttl            resb 0x01 ; Time To Live (1 byte)
	.protocol       resb 0x01 ; Protocol (1 byte, e.g., 6 for TCP, 17 for UDP)
	.checksum       resb 0x02 ; Header checksum (2 bytes)
	.source_address     resb 0x04 ; Source IP address (4 bytes)
	.destination_address    resb 0x04 ; Destination IP address (4 bytes)

.SIZE:  ; Total size of the IP frame structure (20 bytes)
	endstruc

	; ICMP frame structure
	struc     SERVICE_NETWORK_STRUCTURE_FRAME_ICMP
	.type     resb 0x01 ; ICMP type (1 byte, e.g., 8 for Echo Request)
	.code     resb 0x01 ; ICMP code (1 byte)
	.checksum resb 0x02 ; ICMP checksum (2 bytes)
	.reserved resb 0x04 ; Reserved field (4 bytes)
	.data     resb 0x20 ; ICMP data (32 bytes)

.SIZE: ; Total size of the ICMP frame structure (40 bytes)
	endstruc

	; UDP frame structure
	struc     SERVICE_NETWORK_STRUCTURE_FRAME_UDP
	.port_source     resb 0x02 ; Source port (2 bytes)
	.port_target     resb 0x02 ; Destination port (2 bytes)
	.length   resb 0x02 ; Length of the UDP packet (2 bytes)
	.checksum resb 0x02 ; UDP checksum (2 bytes)

.SIZE: ; Total size of the UDP frame structure (8 bytes)
	endstruc

	; TCP frame structure
	struc            SERVICE_NETWORK_STRUCTURE_FRAME_TCP
	.port_source     resb 0x02 ; Source port (2 bytes)
	.port_target     resb 0x02 ; Destination port (2 bytes)
	.sequence        resb 0x04 ; Sequence number (4 bytes)
	.acknowledgement resb 0x04 ; Acknowledgment number (4 bytes)
	.header_length     resb 0x01 ; Header length (4 bits) + Reserved (4 bits)
	.flags           resb 0x01 ; TCP flags (e.g., SYN, ACK, FIN)
	.window_size     resb 0x02 ; Window size (2 bytes)

.checksum_and_urgent_pointer:
	.checksum resb 0x02 ; TCP checksum (2 bytes)
	.urgent_pointer     resb 0x02 ; Urgent pointer (2 bytes)

.SIZE: ; Total size of the TCP frame structure (20 bytes)
.options: ; Optional TCP options (variable length)
	endstruc

	; TCP pseudo-header structure (used for checksum calculation)
	struc     SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER
	.source_ipv4     resb 4 ; Source IP address (4 bytes)
	.target_ipv4     resb 4 ; Destination IP address (4 bytes)
	.reserved resb 1 ; Reserved field (1 byte)
	.protocol resb 1 ; Protocol (1 byte, e.g., 6 for TCP)
	.segment_length     resb 2 ; TCP segment length (2 bytes)


.SIZE:  ; Total size of the TCP pseudo-header structure (12 bytes)
	endstruc

	; TCP stack structure (used for tracking TCP connections)
	struc           SERVICE_NETWORK_STRUCTURE_TCP_STACK
	.source_mac     resb 8 ; Source MAC address (8 bytes, padded)
	.source_ipv4     resb 4  ; Source IP address (4 bytes)
	.source_sequence    resb 4 ; Source sequence number (4 bytes)
	.host_sequence     resb 4 ; Host sequence number (4 bytes)
	.request_acknowledgement   resb 4  ; Request acknowledgment number (4 bytes)
	.window_size     resb 2 ; Window size (2 bytes)
	.source_port     resb 2 ; Source port (2 bytes)
	.host_port     resb 2 ; Host port (2 bytes)
	.status         resb 2 ; Connection status (2 bytes)
	.flags          resb 2 ; TCP flags (2 bytes)
	.flags_request     resb 2 ; Requested TCP flags (2 bytes)
	.identification resb 2 ; Identification (2 bytes)

.SIZE: ; Total size of the TCP stack structure (36 bytes)
	endstruc

	; Network port structure (used for managing network ports)
	struc SERVICE_NETWORK_STRUCTURE_PORT
	.pid  resb 8 ; Process ID associated with the port (8 bytes)

.SIZE: ; Total size of the network port structure (8 bytes)
	endstruc
