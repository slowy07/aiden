	; NIC Driver Constants for Intel 82540EM
	DRIVER_NIC_I82540EM_VENDOR_AND_DEVICE equ 0x100E8086

	; Control Register
	DRIVER_NIC_I82540EM_CTRL equ 0x0000  ; Control Register
	DRIVER_NIC_I82540EM_CTRL_FD equ 0x00000001  ; Full-Duplex
	DRIVER_NIC_I82540EM_CTRL_LRST equ 0x00000008  ; Link Reset
	DRIVER_NIC_I82540EM_CTRL_ASDE equ 0x00000020  ; Auto-Speed Detection Enable
	DRIVER_NIC_I82540EM_CTRL_SLU equ 0x00000040  ; Set Link Up
	DRIVER_NIC_I82540EM_CTRL_ILOS equ 0x00000080  ; Invert Loss-of-Signal (LOS)
	DRIVER_NIC_I82540EM_CTRL_SPEED_BIT_8 equ 0x00000100  ; Speed selection
	DRIVER_NIC_I82540EM_CTRL_SPEED_BIT_9 equ 0x00000200  ; Speed selection
	DRIVER_NIC_I82540EM_CTRL_FRCSPD equ 0x00000800  ; Force Speed
	DRIVER_NIC_I82540EM_CTRL_FRCPLX equ 0x00001000  ; Force Duplex
	DRIVER_NIC_I82540EM_CTRL_RST equ 0x04000000  ; Device Reset
	DRIVER_NIC_I82540EM_CTRL_RFCE equ 0x08000000  ; Receive Flow Control Enable
	DRIVER_NIC_I82540EM_CTRL_TFCE equ 0x10000000  ; Transmit Flow Control Enable
	DRIVER_NIC_I82540EM_CTRL_VME equ 0x40000000  ; VLAN Mode Enable

	; Status Registers
	DRIVER_NIC_I82540EM_STATUS equ 0x0008  ; Device Status Register
	DRIVER_NIC_I82540EM_EECD equ 0x0010  ; EEPROM/Flash Control & Data Register
	DRIVER_NIC_I82540EM_EERD equ 0x0014  ; EEPROM Read Register

	; Interrupt Registers
	DRIVER_NIC_I82540EM_ICR_register equ 0x00C0  ; Interrupt Cause Read
	DRIVER_NIC_I82540EM_ICR_register_flag_TXQE equ 1  ; Transmit Queue Empty
	DRIVER_NIC_I82540EM_ICR_register_flag_RXT0 equ 7  ; Receiver Timer Interrupt
	DRIVER_NIC_I82540EM_ITR equ 0x00C4  ; Interrupt Throttling Register
	DRIVER_NIC_I82540EM_ICS equ 0x00C8  ; Interrupt Cause Set Register
	DRIVER_NIC_I82540EM_IMS equ 0x00D0  ; Interrupt Mask Set/Read Register
	DRIVER_NIC_I82540EM_IMC equ 0x00D8  ; Interrupt Mask Clear

	; Receive Control Register
	DRIVER_NIC_I82540EM_RCTL equ 0x0100  ; Receive Control Register
	DRIVER_NIC_I82540EM_RCTL_EN equ 0x00000002  ; Receiver Enable
	DRIVER_NIC_I82540EM_RCTL_SBP equ 0x00000004  ; Store Bad Packets
	DRIVER_NIC_I82540EM_RCTL_UPE equ 0x00000008  ; Unicast Promiscuous Enabled
	DRIVER_NIC_I82540EM_RCTL_MPE equ 0x00000010  ; Multicast Promiscuous Enabled
	DRIVER_NIC_I82540EM_RCTL_BAM equ 0x00008000  ; Broadcast Accept Mode

	; Transmit Control Register
	DRIVER_NIC_I82540EM_TCTL equ 0x0400  ; Transmit Control Register
	DRIVER_NIC_I82540EM_TCTL_EN equ 0x00000002  ; Transmit Enable
	DRIVER_NIC_I82540EM_TCTL_PSP equ 0x00000008  ; Pad Short Packets
	DRIVER_NIC_I82540EM_TCTL_CT equ 0x00000100  ; Collision Threshold
	DRIVER_NIC_I82540EM_TCTL_COLD equ 0x00040000  ; Full-Duplex – 64-byte time
	DRIVER_NIC_I82540EM_TCTL_SWXOFF equ 0x00400000  ; Software OFF Transmission
	DRIVER_NIC_I82540EM_TCTL_RTLC equ 0x01000000  ; Re-transmit on Late Collision
	DRIVER_NIC_I82540EM_TCTL_NRTU equ 0x02000000  ; No Re-transmit on underrun (82544GC/EI only)

	; Descriptor Base Address
	DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS equ 0x00
	DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS equ 0x08

	; Descriptor Status Flags
	DRIVER_NIC_I82540EM_TDESC_STATUS_TU equ 0x0000000800000000  ; Transmit Underrun
	DRIVER_NIC_I82540EM_TDESC_STATUS_LC equ 0x0000000400000000  ; Late Collision
	DRIVER_NIC_I82540EM_TDESC_STATUS_EC equ 0x0000000200000000  ; Excess Collision
	DRIVER_NIC_I82540EM_TDESC_STATUS_DD equ 0x0000000100000000  ; Descriptor Done
	DRIVER_NIC_I82540EM_TDESC_CMD_IDE equ 0x0000000080000000  ; Interrupt Delay Enable
	DRIVER_NIC_I82540EM_TDESC_CMD_VLE equ 0x0000000040000000  ; VLAN Packet Enable
	DRIVER_NIC_I82540EM_TDESC_CMD_DEXT equ 0x0000000020000000  ; Extension (0b for legacy mode)
	DRIVER_NIC_I82540EM_TDESC_CMD_RPS equ 0x0000000010000000  ; Report Packet Send (reserved for 82544GC/EI only)
	DRIVER_NIC_I82540EM_TDESC_CMD_RS equ 0x0000000008000000  ; Report Status
	DRIVER_NIC_I82540EM_TDESC_CMD_IC equ 0x0000000004000000  ; Insert Checksum
	DRIVER_NIC_I82540EM_TDESC_CMD_IFCS equ 0x0000000002000000  ; Insert IFCS
	DRIVER_NIC_I82540EM_TDESC_CMD_EOP equ 0x0000000001000000  ; End Of Packet

	DRIVER_NIC_I82540EM_TIPG equ 0x0410 ; Transmit Inter Packet Gap
	DRIVER_NIC_I82540EM_TIPG_IPGT_DEFAULT equ 0x0000000A
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_0 equ 0x00000001 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_1 equ 0x00000002 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_2 equ 0x00000004 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_3 equ 0x00000008 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_4 equ 0x00000010 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_5 equ 0x00000020 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_6 equ 0x00000040 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_7 equ 0x00000080 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_8 equ 0x00000100 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_9 equ 0x00000200 ; IPG Transmit Time
	DRIVER_NIC_I82540EM_TIPG_IPGR1_DEFAULT equ 0x00002000
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_10 equ 0x00000400 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_11 equ 0x00000800 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_12 equ 0x00001000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_13 equ 0x00002000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_14 equ 0x00004000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_15 equ 0x00008000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_16 equ 0x00010000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_17 equ 0x00020000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_18 equ 0x00040000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_19 equ 0x00080000 ; IPG Receive Time 1
	DRIVER_NIC_I82540EM_TIPG_IPGR2_DEFAULT equ 0x00600000
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_20 equ 0x00100000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_21 equ 0x00200000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_22 equ 0x00400000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_23 equ 0x00800000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_24 equ 0x01000000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_25 equ 0x02000000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_26 equ 0x04000000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_27 equ 0x08000000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_28 equ 0x10000000 ; IPG Receive Time 2
	DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_29 equ 0x20000000 ; IPG Receive Time 2

	DRIVER_NIC_I82540EM_LEDCTL equ 0x0E00 ; LED Control
	DRIVER_NIC_I82540EM_PBA equ 0x1000 ; Packet Buffer Allocation
	DRIVER_NIC_I82540EM_EEWD equ 0x102C ; EEPROM Write Register
	DRIVER_NIC_I82540EM_RDBAL equ 0x2800 ; RX Descriptor Base Address Low
	DRIVER_NIC_I82540EM_RDBAH equ 0x2804 ; RX Descriptor Base Address High
	DRIVER_NIC_I82540EM_RDLEN equ 0x2808 ; RX Descriptor Length
	DRIVER_NIC_I82540EM_RDLEN_default equ 0x80 ; rozmiar przestrzeni kolejki: 128 Bajtów
	DRIVER_NIC_I82540EM_RDH equ 0x2810 ; RX Descriptor Head
	DRIVER_NIC_I82540EM_RDT equ 0x2818 ; RX Descriptor Tail
	DRIVER_NIC_I82540EM_RDTR equ 0x2820 ; RX Delay Timer Register
	DRIVER_NIC_I82540EM_RXDCTL equ 0x3828 ; RX Descriptor Control
	DRIVER_NIC_I82540EM_RADV equ 0x282C ; RX Int. Absolute Delay Timer
	DRIVER_NIC_I82540EM_RSRPD equ 0x2C00 ; RX Small Packet Detect Interrupt
	DRIVER_NIC_I82540EM_TXDMAC equ 0x3000 ; TX DMA Control
	DRIVER_NIC_I82540EM_TDBAL equ 0x3800 ; TX Descriptor Base Address Low
	DRIVER_NIC_I82540EM_TDBAH equ 0x3804 ; TX Descriptor Base Address High
	DRIVER_NIC_I82540EM_TDLEN equ 0x3808 ; TX Descriptor Length
	DRIVER_NIC_I82540EM_TDLEN_default equ 0x80 ; rozmiar przestrzeni kolejki: 128 Bajtów
	DRIVER_NIC_I82540EM_TDH equ 0x3810 ; TX Descriptor Head
	DRIVER_NIC_I82540EM_TDT equ 0x3818 ; TX Descriptor Tail
	DRIVER_NIC_I82540EM_TIDV equ 0x3820 ; TX Interrupt Delay Value
	DRIVER_NIC_I82540EM_TXDCTL equ 0x3828 ; TX Descriptor Control
	DRIVER_NIC_I82540EM_TADV equ 0x382C ; TX Absolute Interrupt Delay Value
	DRIVER_NIC_I82540EM_TSPMT equ 0x3830 ; TCP Segmentation Pad & Min Threshold
	DRIVER_NIC_I82540EM_RXCSUM equ 0x5000 ; RX Checksum Control
	DRIVER_NIC_I82540EM_MTA equ 0x5200 ; Multicast Table Array
	DRIVER_NIC_I82540EM_RA equ 0x5400 ; Receive Address
	DRIVER_NIC_I82540EM_IP4AT_ADDR0 equ 0x5840
	DRIVER_NIC_I82540EM_IP4AT_ADDR1 equ 0x5848
	DRIVER_NIC_I82540EM_IP4AT_ADDR2 equ 0x5850
	DRIVER_NIC_I82540EM_IP4AT_ADDR3 equ 0x5858

	;     Define a structure named DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry
	struc DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry
	;     8 bytes: base_address - This field represents the base address
	;     used for accessing a specific memory or register. The size is 8 bytes
	;     to support larger address ranges.
	.base_address resb 8          ; Reserve 8 bytes for base address

	;       2 bytes: length - This field holds the length of the descriptor.
	;       It is reserved for 2 bytes to represent the size.
	.length resb 2; Reserve 2 bytes for the length field

	;         2 bytes: checksum - This field holds a checksum value for data integrity.
	;         It uses 2 bytes to store the checksum.
	.checksum resb 2; Reserve 2 bytes for checksum

	;       1 byte: status - This field represents the status of the descriptor.
	;       It is reserved for 1 byte to indicate status flags.
	.status resb 1; Reserve 1 byte for the status field

	;       1 byte: errors - This field is used to track any errors related to
	;       the descriptor. It is reserved for 1 byte.
	.errors resb 1; Reserve 1 byte for errors field

	;        2 bytes: special - This field is reserved for special information
	;        with a size of 2 bytes.
	.special resb 2; Reserve 2 bytes for special field
	endstruc

	; Define the memory-mapped I/O base address for the NIC (Network Interface Card)
	driver_nic_i82540em_mmio_base_address dq STATIC_EMPTY
	; This is the base address for the memory-mapped I/O region of the I82540EM NIC.
	; It is reserved as a 64-bit (8-byte) value and will be initialized later.

	; Define the interrupt request number for the NIC
	driver_nic_i82540em_irq_number db STATIC_EMPTY
	; This field holds the interrupt request number used by the NIC.
	; It is reserved as a single byte and will be filled with the appropriate IRQ value.

	; Define the base address for the RX (Receive) descriptor of the NIC
	driver_nic_i82540em_rx_base_address dq STATIC_EMPTY
	; This is the base address for the receive descriptors of the NIC.
	; It is reserved as a 64-bit (8-byte) value and will be initialized later.

	; Define the base address for the TX (Transmit) descriptor of the NIC
	driver_nic_i82540em_tx_base_address dq STATIC_EMPTY
	; This is the base address for the transmit descriptors of the NIC.
	; It is reserved as a 64-bit (8-byte) value and will be initialized later.

	; Define the MAC address for the NIC
	driver_nic_i82540em_mac_address dq STATIC_EMPTY
	; This field holds the MAC (Media Access Control) address of the NIC.
	; It is reserved as a 64-bit (8-byte) value to hold the MAC address.

	; Define a semaphore to indicate if the TX queue is empty
	driver_nic_i82540em_tx_queue_empty_semaphore db STATIC_TRUE
	; This semaphore is a flag that indicates whether the TX (transmit) queue is empty.
	; A value of STATIC_TRUE means the TX queue is currently empty.

	; Define a semaphore to enable or disable promiscuous mode
	driver_nic_i82540em_promiscious_mode_semaphore db STATIC_FALSE
	; This semaphore flag controls the promiscuous mode for the NIC.
	; A value of STATIC_FALSE means promiscuous mode is disabled.

	; Define the IPv4 address assigned to the NIC
	driver_nic_i82540em_ipv4_address db 10, 0, 0, 64
	; This is the IPv4 address assigned to the NIC, represented as four bytes (octets).
	; In this case, the address is 10.0.0.64.

	; Define the subnet mask for the NIC
	driver_nic_i82540em_ipv4_mask db 255, 255, 255, 0
	; This is the subnet mask associated with the NIC's IPv4 address.
	; The mask 255.255.255.0 corresponds to a standard Class C subnet.

	; Define the default gateway for the NIC's network
	driver_nic_i82540em_ipv4_gateway db 10, 0, 0, 1
	; This is the IPv4 address of the default gateway used by the NIC.
	; The address 10.0.0.1 is typically the default gateway for local networks.

	; Define the VLAN (Virtual Local Area Network) ID for the NIC
	driver_nic_i82540em_vlan dw STATIC_EMPTY
	; This field holds the VLAN ID for the NIC.
	; It is reserved as a 16-bit value, which will be filled when VLAN information is available.

	; Define a counter to track the RX (Receive) packet count
	driver_nic_i82540em_rx_count dq STATIC_EMPTY
	; This field tracks the number of packets received by the NIC.
	; It is reserved as a 64-bit value and will be updated during operation.

	; Define a counter to track the TX (Transmit) packet count
	driver_nic_i82540em_tx_count dq STATIC_EMPTY
	; This field tracks the number of packets transmitted by the NIC.
	; It is reserved as a 64-bit value and will be updated during operation.

driver_nic_i82540em_irq:
	;     Save registers that will be modified during interrupt handling
	push  rax; Save the rax register
	push  rbx; Save the rbx register
	push  rcx; Save the rcx register
	push  rdx; Save the rdx register
	push  rsi; Save the rsi register
	pushf ; Save the flags register

	;   Retrieve the MMIO base address of the NIC and load the ICR (Interrupt Cause Register)
	mov rsi, qword [driver_nic_i82540em_mmio_base_address]
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_ICR_register]; Load the value of ICR register

	;   Check if the TX queue is empty (TXQE flag in ICR register)
	bt  eax, DRIVER_NIC_I82540EM_ICR_register_flag_TXQE
	jnc .no_txqe; If TXQE flag is not set, jump to .no_txqe

	;   If the TX queue is empty, set the semaphore to true
	mov byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_TRUE

	;   End interrupt handling for TX queue empty case
	jmp .end

.no_txqe:
	;   Check if a packet has been received (RXT0 flag in ICR register)
	bt  eax, DRIVER_NIC_I82540EM_ICR_register_flag_RXT0
	jnc .received; If RXT0 flag is not set, jump to .received

	;    If a packet is received, process it
	;    First, check if the network service is available
	mov  rbx, qword [service_network_pid]
	test rbx, rbx; Test if the network service is available
	jz   .received; If network service is not available, jump to .received

	;     Retrieve the incoming packet details (address and size)
	mov   rsi, qword [driver_nic_i82540em_rx_base_address]; Load RX base address
	movzx ecx, word [rsi + DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry.length]; Get packet length
	mov   rsi, qword [rsi + DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry.base_address]; Get packet address

	;    Allocate a new buffer for the packet
	call driver_nic_i82540em_rx_release

	;    Send the received packet message to the kernel
	call kernel_ipc_insert

.received:
	;   Inform the controller that packet processing is complete
	mov rsi, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rsi + DRIVER_NIC_I82540EM_RDH], 0x00; Set the RX Descriptor Head pointer to 0
	mov dword [rsi + DRIVER_NIC_I82540EM_RDT], 0x01; Set the RX Descriptor Tail pointer to 1

.end:
	;   Inform the APIC (Advanced Programmable Interrupt Controller) that the interrupt has been handled
	mov rax, qword [kernel_apic_base_address]
	mov dword [rax + KERNEL_APIC_EOI_register], STATIC_EMPTY; Write to the End of Interrupt register

	;   Restore the original registers
	popf
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	; Return from the interrupt
	iretq

	; Debugging macro for tracking the IRQ handler execution

	; driver_nic_i82540em_rx_release:
	; This function is responsible for releasing a receive buffer for the NIC.

driver_nic_i82540em_rx_release:
	;    Save the original registers
	push rax; Save the rax register
	push rdi; Save the rdi register (pointer to the buffer)

	;   Set the pointer to the first descriptor in the receive descriptor ring
	mov rax, qword [driver_nic_i82540em_rx_base_address]

	;    Prepare new space for the incoming packet buffer
	call kernel_memory_alloc_page
	jc   .end; If no free space available, jump to .end

	;   Set the new buffer in the receive descriptor
	mov qword [rax + DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS], rdi

.end:
	;   Restore the original registers
	pop rdi
	pop rax

	; Return from the procedure
	ret

	; Debugging macro to log the execution of the function
	macro_debug "driver_nic_i82540em_rx_release"

	; driver_nic_i82540em_transfer:
	; This function handles the transfer of a packet from the NIC to the network interface.
	; Input:
	; ax  - size of the packet to be transmitted
	; rdi - pointer to the packet

driver_nic_i82540em_transfer:
	;    Save the original registers
	push rsi; Save the rsi register
	push rax; Save the rax register

.wait:
	;   Is the transmit queue empty? Wait if it is
	cmp byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_TRUE
	jne .wait; If queue is not empty, wait for it to be free

	;   Set the pointer to the transmit descriptor buffer
	mov rsi, qword [driver_nic_i82540em_tx_base_address]

	;   Set the packet to be transmitted in the descriptor
	mov qword [rsi + DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS], rdi

	;   Set the packet size and flags in the descriptor
	and eax, STATIC_WORD_mask
	add rax, DRIVER_NIC_I82540EM_TDESC_CMD_RS
	or  rax, DRIVER_NIC_I82540EM_TDESC_CMD_IFCS
	or  rax, DRIVER_NIC_I82540EM_TDESC_CMD_EOP
	mov qword [rsi + DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS], rax

	;   Mark the transmit queue as not empty (the descriptor has been updated)
	mov byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_FALSE

	;   Inform the NIC that there is one descriptor to be processed, indicating its start and end
	mov rax, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rax + DRIVER_NIC_I82540EM_TDH], 0x00; Set the transmit descriptor head pointer to 0
	mov dword [rax + DRIVER_NIC_I82540EM_TDT], 0x01; Set the transmit descriptor tail pointer to 1

.status:
	;    Check the status of the descriptor
	mov  rax, DRIVER_NIC_I82540EM_TDESC_STATUS_DD
	test rax, qword [rsi + DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS]
	jz   .status; If the packet is not yet transmitted, check again

	;   Restore the original registers
	pop rax
	pop rsi

	; Return from the procedure
	ret

	; Debugging macro to log the execution of the function
	macro_debug "driver_nic_i82540em_transfer"

	; driver_nic_i82540em:
	; This function initializes the Intel i82540EM network interface controller (NIC).
	; It reads the necessary configuration from the PCI registers, maps the device's memory,
	; reads the MAC address from the EEPROM, and initializes the controller.

driver_nic_i82540em:
	;    Save the original registers
	push rax; Save the rax register
	push rbx; Save the rbx register
	push rcx; Save the rcx register
	push rsi; Save the rsi register
	push rdi; Save the rdi register
	push r11; Save the r11 register

	;    Read the BAR0 register (Base Address Register 0)
	mov  eax, DRIVER_PCI_REGISTER_bar0
	call driver_pci_read

	;   Check if the address from BAR0 is 64-bit
	bt  eax, DRIVER_PCI_REGISTER_FLAG_64_bit
	jnc .no; If it's not 64-bit, jump to .no

	;    Save the lower part of the 64-bit address
	push rax

	;    Read the upper part of the 64-bit address from BAR1
	mov  eax, DRIVER_PCI_REGISTER_bar1
	call driver_pci_read

	;   Combine the lower and upper parts of the 64-bit address
	mov dword [rsp + STATIC_DWORD_SIZE_byte], eax

	;   Retrieve the full 64-bit address
	pop rax

.no:
	;   Remove flags from the address
	and al, 0xF0; Clear the flags in the address
	mov qword [driver_nic_i82540em_mmio_base_address], rax

	;   Set the pointer to the base address of the controller's memory space
	mov rsi, rax

	;    Read the interrupt number for the controller
	mov  eax, DRIVER_PCI_REGISTER_irq
	call driver_pci_read

	;   Save the interrupt number
	mov byte [driver_nic_i82540em_irq_number], al

	;    Map the controller's memory space to the kernel's page tables
	mov  rax, qword [driver_nic_i82540em_mmio_base_address]
	mov  rbx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  rcx, 32; The memory register space is 128K bytes (32 pages)
	mov  r11, cr3
	call kernel_page_map_physical

	;-----------------------------------------------------------------------
	; Read the MAC address from the EEPROM (3 consecutive reads)

	;   Read the first part of the MAC address (address 0x00)
	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000001
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift
	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.0], ax

	;   Read the second part of the MAC address (address 0x01)
	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000101
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift
	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.2], ax

	;   Read the third part of the MAC address (address 0x02)
	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000201
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift
	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.4], ax

	;   Disable all interrupt types for the controller
	mov dword [rsi + DRIVER_NIC_I82540EM_IMC], STATIC_MAX_unsigned; Disable all interrupts

	;   Clear any pending interrupt events
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_ICR_register]
	;   Reading this register implicitly acknowledges any pending interrupts.
	;   Writing a 1 to any bit clears that bit, writing a 0 has no effect.

	;    Initialize the NIC controller
	call driver_nic_i82540em_setup

	;   Restore the original registers
	pop r11
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	; Return from the procedure
	ret

	; Debugging macro to log the execution of the function
	macro_debug "driver_nic_i82540em"

	; driver_nic_i82540em_setup:
	; This function configures the Intel i82540EM NIC for receiving and sending packets.
	; It initializes both receive (RX) and transmit (TX) descriptors, configures packet
	; reception and transmission settings, and enables the controller.

driver_nic_i82540em_setup:
	;    Save the original registers
	push rax; Save the rax register
	push rdi; Save the rdi register

	;    Incoming Packet Configuration
	;    Allocate space for the receive descriptor array
	;    A descriptor stores the address of the memory space where incoming packets
	;    are loaded (Documentation: Page 34/410, Table 3-1)
	call kernel_memory_alloc_page
	call kernel_page_drain

	;   Save the address of the receive descriptor table
	mov qword [driver_nic_i82540em_rx_base_address], rdi

	;   Load the address of the receive descriptor table into the controller
	mov dword [rsi + DRIVER_NIC_I82540EM_RDBAL], edi
	shr rdi, STATIC_MOVE_HIGH_TO_EAX_shift
	mov dword [rsi + DRIVER_NIC_I82540EM_RDBAH], edi

	;   Set the size of the descriptor buffer, header, and limit
	;   Documentation: Page 321/410, Section 13.4.27
	;   We handle one packet at a time, so set minimal values
	mov dword [rsi + DRIVER_NIC_I82540EM_RDLEN], DRIVER_NIC_I82540EM_RDLEN_default
	mov dword [rsi + DRIVER_NIC_I82540EM_RDH], 0x00; First available descriptor
	mov dword [rsi + DRIVER_NIC_I82540EM_RDT], 0x01; First unavailable descriptor

	;    Allocate space for the incoming packet queue
	call kernel_memory_alloc_page

	;   Insert the first record in the descriptor table
	mov rax, qword [driver_nic_i82540em_rx_base_address]
	mov qword [rax], rdi

	;   Configure the receive control register
	;   Documentation: Page 314/410, Table 13-67
	mov eax, DRIVER_NIC_I82540EM_RCTL_EN; Enable packet reception
	or  eax, DRIVER_NIC_I82540EM_RCTL_UPE; Packets destined only for me
	or  eax, DRIVER_NIC_I82540EM_RCTL_BAM; Packets destined for all
	or  eax, DRIVER_NIC_I82540EM_RCTL_SECRC; Strip CRC from the end of the packet
	or  eax, DRIVER_NIC_I82540EM_RCTL_MPE; Packets destined for the majority
	mov dword [rsi + DRIVER_NIC_I82540EM_RCTL], eax

	;    Outgoing Packet Configuration
	;    Allocate space for the transmit descriptor array
	call kernel_memory_alloc_page
	call kernel_page_drain

	;   Save the address of the transmit descriptor table
	mov qword [driver_nic_i82540em_tx_base_address], rdi

	;   Load the address of the transmit descriptor table into the controller
	mov dword [rsi + DRIVER_NIC_I82540EM_TDBAL], edi
	shr rdi, STATIC_MOVE_HIGH_TO_EAX_shift
	mov dword [rsi + DRIVER_NIC_I82540EM_TDBAH], edi

	;   Set the size of the descriptor buffer, header, and limit
	;   Documentation: Page 330/410, Section 13.4.38
	;   Set minimal values for transmit descriptor array size
	mov dword [rsi + DRIVER_NIC_I82540EM_TDLEN], DRIVER_NIC_I82540EM_TDLEN_default
	mov dword [rsi + DRIVER_NIC_I82540EM_TDH], 0x00; First descriptor in the list
	mov dword [rsi + DRIVER_NIC_I82540EM_TDT], 0x00; No descriptors to process

	;   Configure the transmit control register
	;   Documentation: Page 314/410, Table 13-67
	mov eax, DRIVER_NIC_I82540EM_TCTL_EN; Enable packet transmission
	or  eax, DRIVER_NIC_I82540EM_TCTL_PSP; Pad short packets to the minimum size of 64 bytes
	or  eax, DRIVER_NIC_I82540EM_TCTL_RTLC; Retransmit on Late Collision
	or  eax, DRIVER_NIC_I82540EM_TCTL_CT; Retry up to 15 times on collision
	or  eax, DRIVER_NIC_I82540EM_TCTL_COLD; Set Collision Threshold
	mov dword [rsi + DRIVER_NIC_I82540EM_TCTL], eax

	;   Set IPGT, IPGR1, IPGR2 (inter-packet gap)
	mov eax, DRIVER_NIC_I82540EM_TIPG_IPGT_DEFAULT
	or  eax, DRIVER_NIC_I82540EM_TIPG_IPGR1_DEFAULT
	or  eax, DRIVER_NIC_I82540EM_TIPG_IPGR2_DEFAULT
	mov dword [rsi + DRIVER_NIC_I82540EM_TIPG], eax

	;   Enable the Controller
	;   Clear: LRST, PHY_RST, VME, ILOS, Set: SLU, ASDE
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_CTRL]
	or  eax, DRIVER_NIC_I82540EM_CTRL_SLU
	or  eax, DRIVER_NIC_I82540EM_CTRL_ASDE
	and rax, ~DRIVER_NIC_I82540EM_CTRL_LRST
	and rax, ~DRIVER_NIC_I82540EM_CTRL_ILOS
	and rax, ~DRIVER_NIC_I82540EM_CTRL_VME
	and rax, DRIVER_NIC_I82540EM_CTRL_PHY_RST; NASM ERROR: Compiler issue?
	mov dword [rsi + DRIVER_NIC_I82540EM_CTRL], eax

	;     Attach the network controller IRQ handler
	movzx eax, byte [driver_nic_i82540em_irq_number]
	add   al, KERNEL_IDT_IRQ_offset
	mov   rbx, KERNEL_IDT_TYPE_irq
	mov   rdi, driver_nic_i82540em_irq
	call  kernel_idt_mount

	;     Set the interrupt vector in the I/O APIC
	movzx ebx, byte [driver_nic_i82540em_irq_number]
	shl   ebx, STATIC_MULTIPLE_BY_2_shift
	add   ebx, KERNEL_IO_APIC_iowin
	call  kernel_io_apic_connect

	;   Enable controller interrupts
	;   Documentation: Page 311/410, Section 13.4.20
	mov rdi, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rdi + DRIVER_NIC_I82540EM_IMS], 0b00000000000000011111011011011111

	;   Restore the original registers
	pop rdi
	pop rax

	; Return from the procedure
	ret

	; Debugging macro to log the execution of the function
	macro_debug "driver_nic_i82540em_setup"