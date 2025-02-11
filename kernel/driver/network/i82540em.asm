
; 0x100E Device ID for the Intel 82540EM network controller
; 0x8086 Vendor ID for Intel Corporation
DRIVER_NIC_I82540EM_VENDOR_AND_DEVICE equ 0x100E8086

; Primary control register for configuring the NIC
DRIVER_NIC_I82540EM_CTRL equ 0x0000
DRIVER_NIC_I82540EM_CTRL_FD equ 0x00000001 ; Full-duplex mode
DRIVER_NIC_I82540EM_CTRL_LRST equ 0x00000008 ; Link reset
DRIVER_NIC_I82540EM_CTRL_ASDE equ 0x00000020 ; Auto speed detection enable
DRIVER_NIC_I82540EM_CTRL_SLU equ 0x00000040
DRIVER_NIC_I82540EM_CTRL_ILOS equ 0x00000080 ; ; Invert loss-of-signal indication
DRIVER_NIC_I82540EM_CTRL_SPEED_BIT_8 equ 0x00000100 
DRIVER_NIC_I82540EM_CTRL_SPEED_BIT_9 equ 0x00000200
DRIVER_NIC_I82540EM_CTRL_FRCSPD equ 0x00000800 ; Force speed
DRIVER_NIC_I82540EM_CTRL_FRCPLX equ 0x00001000 ; Force duplex
DRIVER_NIC_I82540EM_CTRL_SDP0_DATA equ 0x00040000
DRIVER_NIC_I82540EM_CTRL_SDP1_DATA equ 0x00080000
DRIVER_NIC_I82540EM_CTRL_ADVD3WUC equ 0x00100000
DRIVER_NIC_I82540EM_CTRL_EN_PHY_PWR_MGMT equ 0x00200000
DRIVER_NIC_I82540EM_CTRL_SDP0_IODIR equ 0x00400000
DRIVER_NIC_I82540EM_CTRL_SDP1_IODIR equ 0x00800000
DRIVER_NIC_I82540EM_CTRL_RST equ 0x04000000  ; Device reset
DRIVER_NIC_I82540EM_CTRL_RFCE equ 0x08000000 ; Receive flow control enable
DRIVER_NIC_I82540EM_CTRL_TFCE equ 0x10000000 ; Transmit flow control enable
DRIVER_NIC_I82540EM_CTRL_VME equ 0x40000000
DRIVER_NIC_I82540EM_CTRL_PHY_RST equ 0x7FFFFFFF

DRIVER_NIC_I82540EM_STATUS equ 0x0008
DRIVER_NIC_I82540EM_EECD equ 0x0010 ; EEPPROM control
DRIVER_NIC_I82540EM_EERD equ 0x0014 ; EEPPROM read register
DRIVER_NIC_I82540EM_CTRLEXT equ 0x0018
DRIVER_NIC_I82540EM_MDIC equ 0x0020
DRIVER_NIC_I82540EM_FCAL equ 0x0028
DRIVER_NIC_I82540EM_FCAH equ 0x002C
DRIVER_NIC_I82540EM_FCT equ 0x0030
DRIVER_NIC_I82540EM_VET equ 0x0038
DRIVER_NIC_I82540EM_ICR_register equ 0x00C0 ; Interrupt cause register
DRIVER_NIC_I82540EM_ICR_register_flag_TXQE equ 1 ; Transmit queue empty
DRIVER_NIC_I82540EM_ICR_register_flag_RXT0 equ 7 ; Receive timer expired
DRIVER_NIC_I82540EM_ITR equ 0x00C4 ; Interrupt throttling
DRIVER_NIC_I82540EM_ICS equ 0x00C8 ; Interrupt clear status
DRIVER_NIC_I82540EM_IMS equ 0x00D0 ; Interrupt mask set / read
DRIVER_NIC_I82540EM_IMC equ 0x00D8 ; Interrupt mask clear

; Receive control
DRIVER_NIC_I82540EM_RCTL equ 0x0100 
DRIVER_NIC_I82540EM_RCTL_EN equ 0x00000002 ; Enable receiver
DRIVER_NIC_I82540EM_RCTL_SBP equ 0x00000004 ; Store bad packets
DRIVER_NIC_I82540EM_RCTL_UPE equ 0x00000008 ; Unicast promiscuous mode enable
DRIVER_NIC_I82540EM_RCTL_MPE equ 0x00000010 ; Multicast promiscuous mode enable
DRIVER_NIC_I82540EM_RCTL_LPE equ 0x00000020 ; Long packet reception enable
DRIVER_NIC_I82540EM_RCTL_LBM_BIT_6 equ 0x00000040
DRIVER_NIC_I82540EM_RCTL_LBM_BIT_7 equ 0x00000080
DRIVER_NIC_I82540EM_RCTL_RDMTS_BIT_8 equ 0x00000100
DRIVER_NIC_I82540EM_RCTL_RDMTS_BIT_9 equ 0x00000200
DRIVER_NIC_I82540EM_RCTL_MO_BIT_12 equ 0x00001000
DRIVER_NIC_I82540EM_RCTL_MO_BIT_13 equ 0x00002000
DRIVER_NIC_I82540EM_RCTL_BAM equ 0x00008000 ; Broadcast accept mode
DRIVER_NIC_I82540EM_RCTL_BSIZE_2048_BYTES equ 0x00000000
DRIVER_NIC_I82540EM_RCTL_BSIZE_1024_BYTES equ 0x00010000
DRIVER_NIC_I82540EM_RCTL_BSIZE_512_BYTES equ 0x00020000
DRIVER_NIC_I82540EM_RCTL_BSIZE_256_BYTES equ 0x00030000
DRIVER_NIC_I82540EM_RCTL_VFE equ 0x00040000
DRIVER_NIC_I82540EM_RCTL_CFIEN equ 0x00080000
DRIVER_NIC_I82540EM_RCTL_CFI equ 0x00100000
DRIVER_NIC_I82540EM_RCTL_DPF equ 0x00400000
DRIVER_NIC_I82540EM_RCTL_PMCF equ 0x00800000
DRIVER_NIC_I82540EM_RCTL_BSEX equ 0x02000000
DRIVER_NIC_I82540EM_RCTL_SECRC equ 0x04000000

DRIVER_NIC_I82540EM_TXCW equ 0x0178
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_5 equ 0x00000020
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_6 equ 0x00000040
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_7 equ 0x00000080
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_8 equ 0x00000100
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_12 equ 0x00001000
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_13 equ 0x00002000
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD_BIT_15 equ 0x00008000
DRIVER_NIC_I82540EM_TXCW_TXCONFIGWORD equ 0x40000000
DRIVER_NIC_I82540EM_TXCW_ANE equ 0x80000000

DRIVER_NIC_I82540EM_RXCW equ 0x0180

; Control behaviour transmit engine
DRIVER_NIC_I82540EM_TCTL equ 0x0400
DRIVER_NIC_I82540EM_TCTL_EN equ 0x00000002 ; Enable transmision
DRIVER_NIC_I82540EM_TCTL_PSP equ 0x00000008 ; Pad short packets
DRIVER_NIC_I82540EM_TCTL_CT equ 0x00000100 ; Collision threshold
DRIVER_NIC_I82540EM_TCTL_COLD equ 0x00040000 ; Collision distance
DRIVER_NIC_I82540EM_TCTL_SWXOFF equ 0x00400000 ; Software XOFF transmision
DRIVER_NIC_I82540EM_TCTL_RTLC equ 0x01000000
DRIVER_NIC_I82540EM_TCTL_NRTU equ 0x02000000

DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS equ 0x00
DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS equ 0x08
DRIVER_NIC_I82540EM_TDESC_STATUS_TU equ 0x0000000800000000
DRIVER_NIC_I82540EM_TDESC_STATUS_LC equ 0x0000000400000000
DRIVER_NIC_I82540EM_TDESC_STATUS_EC equ 0x0000000200000000
DRIVER_NIC_I82540EM_TDESC_STATUS_DD equ 0x0000000100000000
DRIVER_NIC_I82540EM_TDESC_CMD_IDE equ 0x0000000080000000
DRIVER_NIC_I82540EM_TDESC_CMD_VLE equ 0x0000000040000000
DRIVER_NIC_I82540EM_TDESC_CMD_DEXT equ 0x0000000020000000
DRIVER_NIC_I82540EM_TDESC_CMD_RPS equ 0x0000000010000000
DRIVER_NIC_I82540EM_TDESC_CMD_RS equ 0x0000000008000000
DRIVER_NIC_I82540EM_TDESC_CMD_IC equ 0x0000000004000000
DRIVER_NIC_I82540EM_TDESC_CMD_IFCS equ 0x0000000002000000
DRIVER_NIC_I82540EM_TDESC_CMD_EOP equ 0x0000000001000000

; IPGT (inter-packet gap time) -> define minimum gap between packet
; Using for fine-grained control over the inter-packet gap timing
DRIVER_NIC_I82540EM_TIPG equ 0x0410

; Default value for the IPGT field is 10 (0x0A) which is set
; minimum inter-packet gap time
DRIVER_NIC_I82540EM_TIPG_IPGT_DEFAULT equ 0x0000000A
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_0 equ 0x00000001
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_1 equ 0x00000002
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_2 equ 0x00000004
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_3 equ 0x00000008
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_4 equ 0x00000010
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_5 equ 0x00000020
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_6 equ 0x00000040
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_7 equ 0x00000080
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_8 equ 0x00000100
DRIVER_NIC_I82540EM_TIPG_IPGT_BIT_9 equ 0x00000200
DRIVER_NIC_I82540EM_TIPG_IPGR1_DEFAULT equ 0x00002000

; IPGR1 (inter-packet gap retransmit 1) -> for additional spacing parameter for packet
; 										   transmision
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_10 equ 0x00000400
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_11 equ 0x00000800
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_12 equ 0x00001000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_13 equ 0x00002000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_14 equ 0x00004000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_15 equ 0x00008000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_16 equ 0x00010000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_17 equ 0x00020000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_18 equ 0x00040000
DRIVER_NIC_I82540EM_TIPG_IPGR1_BIT_19 equ 0x00080000
DRIVER_NIC_I82540EM_TIPG_IPGR2_DEFAULT equ 0x00600000

; IPGR2 (inter-packet gap retransmit 2) -> for further spacing configuraion for packet
;										   retransmission
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_20 equ 0x00100000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_21 equ 0x00200000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_22 equ 0x00400000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_23 equ 0x00800000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_24 equ 0x01000000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_25 equ 0x02000000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_26 equ 0x04000000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_27 equ 0x08000000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_28 equ 0x10000000
DRIVER_NIC_I82540EM_TIPG_IPGR2_BIT_29 equ 0x20000000

DRIVER_NIC_I82540EM_LEDCTL equ 0x0E00
DRIVER_NIC_I82540EM_PBA equ 0x1000
DRIVER_NIC_I82540EM_EEWD equ 0x102C
DRIVER_NIC_I82540EM_RDBAL equ 0x2800 ; RX Descriptor base address (low)
DRIVER_NIC_I82540EM_RDBAH equ 0x2804 ; RX Descriptor base address (high)
DRIVER_NIC_I82540EM_RDLEN equ 0x2808 ; RX Descriptor length
DRIVER_NIC_I82540EM_RDLEN_default equ 0x80
DRIVER_NIC_I82540EM_RDH equ 0x2810 ; RX Descriptor Head
DRIVER_NIC_I82540EM_RDT equ 0x2818 ; RX Descriptor Tail
DRIVER_NIC_I82540EM_RDTR equ 0x2820
DRIVER_NIC_I82540EM_RXDCTL equ 0x3828
DRIVER_NIC_I82540EM_RADV equ 0x282C
DRIVER_NIC_I82540EM_RSRPD equ 0x2C00

DRIVER_NIC_I82540EM_TXDMAC equ 0x3000
DRIVER_NIC_I82540EM_TDBAL equ 0x3800 ; TX Descriptor base address (low)
DRIVER_NIC_I82540EM_TDBAH equ 0x3804 ; TX Descriptor base address (high)
DRIVER_NIC_I82540EM_TDLEN equ 0x3808 ; TX Descriptor Length
DRIVER_NIC_I82540EM_TDLEN_default equ 0x80
DRIVER_NIC_I82540EM_TDH equ 0x3810 ; TX Descriptor Head
DRIVER_NIC_I82540EM_TDT equ 0x3818 ; TX Descriptor Tail
DRIVER_NIC_I82540EM_TIDV equ 0x3820
DRIVER_NIC_I82540EM_TXDCTL equ 0x3828
DRIVER_NIC_I82540EM_TADV equ 0x382C
DRIVER_NIC_I82540EM_TSPMT equ 0x3830
DRIVER_NIC_I82540EM_RXCSUM equ 0x5000
DRIVER_NIC_I82540EM_MTA equ 0x5200
DRIVER_NIC_I82540EM_RA equ 0x5400
DRIVER_NIC_I82540EM_IP4AT_ADDR0 equ 0x5840
DRIVER_NIC_I82540EM_IP4AT_ADDR1 equ 0x5848
DRIVER_NIC_I82540EM_IP4AT_ADDR2 equ 0x5850
DRIVER_NIC_I82540EM_IP4AT_ADDR3 equ 0x5858

struc     DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry
.base_address    resb 8 ; This point to the pyhsical address of received packet
						; 64-bit base address the packet buffer
.length   resb 2 ; Length of the received packet
				 ; Specify the size of the received packet
.checksum resb 2 ; Checksum value
				 ; Store the computed checksum for packet validation
.status   resb 1 ; Status flags
				 ; Indicating current status received descriptor
.errors   resb 1 ; Error flags
			     ; Flags any error encountered during reception
.special  resb 2 ; Special flags
				 ; Holding any special flags related to the received packet
endstruc

; Store base address into of the MMIO space, which is mapped into system memory
driver_nic_i82540em_mmio_base_address  dq STATIC_EMPTY
; Representing interrupt request assigned to the NIC
driver_nic_i82540em_irq_number   db STATIC_EMPTY
; Points to the base of the received descriptor ring buffer
driver_nic_i82540em_rx_base_address  dq STATIC_EMPTY
; Points to the base of the transmit descriptor ring buffer
driver_nic_i82540em_tx_base_address  dq STATIC_EMPTY
; Store the NIC MAC address
driver_nic_i82540em_mac_address   dq STATIC_EMPTY

; Flag that signal wether transmit queue is empty
driver_nic_i82540em_tx_queue_empty_semaphore db STATIC_TRUE
; Determine  if the NIC operating in promiscuous mode
driver_nic_i82540em_promiscious_mode_semaphore db STATIC_FALSE

driver_nic_i82540em_ipv4_address  db 10, 0, 0, 64 ; Assigned IPV4 address
driver_nic_i82540em_ipv4_mask   db 255, 255, 255, 0 ; Subnet mask
driver_nic_i82540em_ipv4_gateway  db 10, 0, 0, 1 ; Default gateway used for routing
driver_nic_i82540em_vlan   dw STATIC_EMPTY ; Hold VLAN setting if applicable

driver_nic_i82540em_rx_count dq STATIC_EMPTY ; Tracking received packet
driver_nic_i82540em_tx_count dq STATIC_EMPTY ; Tracking transmited packet

; Printing status message
driver_nic_i82540em_string   db STATIC_COLOR_ASCII_GREEN_LIGHT, "::", STATIC_COLOR_ASCII_DEFAULT, " Network controller:", STATIC_ASCII_NEW_LINE, "   Intel 82540EM, MAC ", STATIC_COLOR_ASCII_WHITE

driver_nic_i82540em_string_end:
	driver_nic_i82540em_string_irq   db STATIC_COLOR_ASCII_DEFAULT, ", IRQ ", STATIC_COLOR_ASCII_WHITE

driver_nic_i82540em_string_irq_end:

driver_nic_i82540em_irq:
	; Save register and flag
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	pushf

	; Load the base address of the NIC's MMIO (Memory-Mapped I/O) region
	mov rsi, qword [driver_nic_i82540em_mmio_base_address]
	; Read the Interrupt Cause Register (ICR) to determine the cause of the interrupt
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_ICR_register]

	; Check if the TX Queue Empty (TXQE) flag is set
	bt  eax, DRIVER_NIC_I82540EM_ICR_register_flag_TXQE
	jnc .no_txqe ; If not set, jump to .no_txqe

	; If TXQE is set, set the TX queue empty semaphore to TRUE
	mov byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_TRUE
	; Jump to the end of the interrupt handler
	jmp .end

.no_txqe:
	; Check if the Receive Timer Interrupt (RXT0) flag is set
	bt  eax, DRIVER_NIC_I82540EM_ICR_register_flag_RXT0
	jnc .received

	; Check if the network service process ID is valid
	mov  rbx, qword [service_network_pid]
	test rbx, rbx
	jz   .received ; If not valid, jump to .received

	; Load the base address of the RX descriptor
	mov   rsi, qword [driver_nic_i82540em_rx_base_address]
	; Load the length of the received packet
	movzx ecx, word [rsi + DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry.length]
	; Load the base address of the received packet
	mov   rsi, qword [rsi + DRIVER_NIC_I82540EM_STRUCTURE_RCTL_RDESC_entry.base_address]

	; Release the RX buffer
	call driver_nic_i82540em_rx_release

	; Insert the received packet into the IPC (Inter-Process Communication) queue
	call kernel_ipc_insert

.received:
	; Reset the Receive Descriptor Head (RDH) and Receive Descriptor Tail (RDT) pointers
	mov rsi, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rsi + DRIVER_NIC_I82540EM_RDH], 0x00
	mov dword [rsi + DRIVER_NIC_I82540EM_RDT], 0x01

.end:
	; Send End of Interrupt (EOI) to the Local APIC
	mov rax, qword [kernel_apic_base_address]
	mov dword [rax + KERNEL_APIC_EOI_register], STATIC_EMPTY

	; Restore registers and flags
	popf
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	; Return from interrupt
	iretq

	; Debug macro to mark the end of the interrupt handler
	macro_debug "driver_nic_i82540em_irq"

driver_nic_i82540em_rx_release:
	; Save registers
	push rax
	push rdi

	; Load the base address of the RX descriptor
	mov rax, qword [driver_nic_i82540em_rx_base_address]

	; Allocate a new page for the RX buffer
	call kernel_memory_alloc_page
	jc   .end  ; If allocation fails, jump to .end

	; Store the allocated page address in the RX descriptor
	mov qword [rax + DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS], rdi

.end:
	; Restore registers
	pop rdi
	pop rax

	; Return from the function
	ret

; Debug macro to mark the end of the RX release function
macro_debug "driver_nic_i82540em_rx_release"

driver_nic_i82540em_transfer:
	; Save registers
	push rsi
	push rax

.wait:
	; Wait until the TX queue is empty (semaphore is set to TRUE)
	cmp byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_TRUE
	jne .wait
	; Load the base address of the TX descriptor
	mov rsi, qword [driver_nic_i82540em_tx_base_address]

	; Set the base address of the packet to transmit in the TX descriptor
	mov qword [rsi + DRIVER_NIC_I82540EM_TDESC_BASE_ADDRESS], rdi

	; Prepare the command flags for the TX descriptor
	and eax, STATIC_WORD_mask
	add rax, DRIVER_NIC_I82540EM_TDESC_CMD_RS ; Report Status
	or  rax, DRIVER_NIC_I82540EM_TDESC_CMD_IFCS ; Insert Frame Check Sequence
	or  rax, DRIVER_NIC_I82540EM_TDESC_CMD_EOP ; End of Packet
	mov qword [rsi + DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS], rax

	; Mark the TX queue as not empty
	mov byte [driver_nic_i82540em_tx_queue_empty_semaphore], STATIC_FALSE

	; Update the TX Descriptor Head (TDH) and TX Descriptor Tail (TDT) pointers
	mov rax, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rax + DRIVER_NIC_I82540EM_TDH], 0x00
	mov dword [rax + DRIVER_NIC_I82540EM_TDT], 0x01

.status:
	; Wait until the TX descriptor status indicates that the packet has been sent
	mov  rax, DRIVER_NIC_I82540EM_TDESC_STATUS_DD
	test rax, qword [rsi + DRIVER_NIC_I82540EM_TDESC_LENGTH_AND_FLAGS]
	jz   .status

	; Restore registers
	pop rax
	pop rsi

	; Return from the function
	ret

; Debug macro to mark the end of the transfer function
macro_debug "driver_nic_i82540em_transfer"

driver_nic_i82540em:
	; Save registers
	push rax
	push rbx
	push rcx
	push rsi
	push rdi
	push r11

	; Read the Base Address Register (BAR0) to get the MMIO base address
	mov  eax, DRIVER_PCI_REGISTER_bar0
	call driver_pci_read

	; Check if the BAR is 64-bit
	bt  eax, DRIVER_PCI_REGISTER_FLAG_64_bit
	jnc .no

	; If BAR is 64-bit, read the upper 32 bits (BAR1)
	push rax

	mov  eax, DRIVER_PCI_REGISTER_bar1
	call driver_pci_read

	; Combine the upper 32 bits with the lower 32 bits
	mov dword [rsp + STATIC_DWORD_SIZE_byte], eax

	pop rax

.no:
	; Mask the lower 4 bits of the BAR to get the base address
	and al, 0xF0
	mov qword [driver_nic_i82540em_mmio_base_address], rax

	mov rsi, rax

	; Read the IRQ number from the PCI configuration space
	mov  eax, DRIVER_PCI_REGISTER_irq
	call driver_pci_read

	; Store the IRQ number
	mov byte [driver_nic_i82540em_irq_number], al

	; Map the MMIO region into the kernel's address space
	mov rax, qword [driver_nic_i82540em_mmio_base_address]
	mov rbx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov rcx, 32

	mov  r11, cr3
	call kernel_page_map_physical

	; Read the MAC address from the EEPROM
	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000001
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift

	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.0], ax

	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000101
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift

	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.2], ax

	mov dword [rsi + DRIVER_NIC_I82540EM_EERD], 0x00000201
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_EERD]
	shr eax, STATIC_MOVE_HIGH_TO_AX_shift

	mov word [driver_nic_i82540em_mac_address + SERVICE_NETWORK_STRUCTURE_MAC.4], ax

	; Disable all interrupts by setting the Interrupt Mask Clear (IMC) register
	mov dword [rsi + DRIVER_NIC_I82540EM_IMC], STATIC_MAX_unsigned

	; Clear any pending interrupts by reading the Interrupt Cause Register (ICR)
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_ICR_register]

	; Perform additional setup for the NIC
	call driver_nic_i82540em_setup

	; Print the NIC initialization string
	mov  ecx, driver_nic_i82540em_string_end - driver_nic_i82540em_string
	mov  rsi, driver_nic_i82540em_string
	call kernel_video_string

	; Print the MAC address
	mov bl, STATIC_NUMBER_SYSTEM_hexadecimal

	xor cl, cl

	mov dl, 6

	mov rsi, driver_nic_i82540em_mac_address

.mac:
	lodsb

	call kernel_video_number

	dec dl
	jz  .end

	; Print a colon between MAC address bytes
	mov  eax, STATIC_ASCII_COLON
	mov  cl, 1
	call kernel_video_char

	jmp .mac

.end:
	; Print the IRQ number
	mov  ecx, driver_nic_i82540em_string_irq_end - driver_nic_i82540em_string_irq
	mov  rsi, driver_nic_i82540em_string_irq
	call kernel_video_string

	movzx eax, byte [driver_nic_i82540em_irq_number]
	mov   bl, STATIC_NUMBER_SYSTEM_decimal
	xor   ecx, ecx
	call  kernel_video_number

	; Print a newline character
	mov  eax, STATIC_ASCII_NEW_LINE
	mov  cl, 1
	call kernel_video_char

	; Restore registers
	pop r11
	pop rdi
	pop rsi
	pop rcx
	pop rbx
	pop rax

	; Return from the function
	ret

; Debug macro to mark the end of the driver initialization function
macro_debug "driver_nic_i82540em"

driver_nic_i82540em_setup:
	; Save registers
	push rax
	push rdi

	; Allocate a page for the RX descriptor ring
	call kernel_memory_alloc_page
	call kernel_page_drain

	; Store the allocated page address as the RX base address
	mov qword [driver_nic_i82540em_rx_base_address], rdi

	; Set the lower 32 bit of the RX descriptor base address
	mov dword [rsi + DRIVER_NIC_I82540EM_RDBAL], edi
	; Set the upper 32 bits of the RX descriptor base address
	shr rdi, STATIC_MOVE_HIGH_TO_EAX_shift
	mov dword [rsi + DRIVER_NIC_I82540EM_RDBAH], edi

	; Set the length of the RX descriptor ring
	mov dword [rsi + DRIVER_NIC_I82540EM_RDLEN], DRIVER_NIC_I82540EM_RDLEN_default

	; Initialize the RX Descriptor Head (RDH) and Tail (RDT) pointers
	mov dword [rsi + DRIVER_NIC_I82540EM_RDH], 0x00
	mov dword [rsi + DRIVER_NIC_I82540EM_RDT], 0x01

	; Allocate a page for the RX buffer
	call kernel_memory_alloc_page

	; Store the allocated page address in the first RX descriptor
	mov rax, qword [driver_nic_i82540em_rx_base_address]
	mov qword [rax], rdi

	; Configure the Receive Control Register (RCTL)
	mov eax, DRIVER_NIC_I82540EM_RCTL_EN ; Enable receiver
	or eax, DRIVER_NIC_I82540EM_RCTL_UPE ; Unicast Promiscuous Enable
	or eax, DRIVER_NIC_I82540EM_RCTL_BAM ; Broadcast Accept Mode
	or eax, DRIVER_NIC_I82540EM_RCTL_SECRC ; Strip Ethernet CRC

	or  eax, DRIVER_NIC_I82540EM_RCTL_MPE ; Multicast Promiscuous Enable
	mov dword [rsi + DRIVER_NIC_I82540EM_RCTL], eax

	; Allocate a page for the TX descriptor ring
	call kernel_memory_alloc_page
	call kernel_page_drain

	; Store the allocated page address as the TX base address
	mov qword [driver_nic_i82540em_tx_base_address], rdi

	; Set the lower 32 bits of the TX descriptor base address
	mov dword [rsi + DRIVER_NIC_I82540EM_TDBAL], edi
	; Set the upper 32 bits of the TX descriptor base address
	shr rdi, STATIC_MOVE_HIGH_TO_EAX_shift
	mov dword [rsi + DRIVER_NIC_I82540EM_TDBAH], edi

	; Set the length of the TX descriptor ring
	mov dword [rsi + DRIVER_NIC_I82540EM_TDLEN], DRIVER_NIC_I82540EM_TDLEN_default

	; Initialize the TX Descriptor Head (TDH) and Tail (TDT) pointers
	mov dword [rsi + DRIVER_NIC_I82540EM_TDH], 0x00
	mov dword [rsi + DRIVER_NIC_I82540EM_TDT], 0x00

	; Configure the Transmit Control Register (TCTL)
	mov eax, DRIVER_NIC_I82540EM_TCTL_EN ; Enable transmitter
	or  eax, DRIVER_NIC_I82540EM_TCTL_PSP ; Pad Short Packets
	or  eax, DRIVER_NIC_I82540EM_TCTL_RTLC ; Retry on Late Collision
	or  eax, DRIVER_NIC_I82540EM_TCTL_CT ; Collision Threshold
	or  eax, DRIVER_NIC_I82540EM_TCTL_COLD ; Collision Distance
	mov dword [rsi + DRIVER_NIC_I82540EM_TCTL], eax

	; Configure the Transmit IPG Register (TIPG)
	mov eax, DRIVER_NIC_I82540EM_TIPG_IPGT_DEFAULT
	or  eax, DRIVER_NIC_I82540EM_TIPG_IPGR1_DEFAULT
	or  eax, DRIVER_NIC_I82540EM_TIPG_IPGR2_DEFAULT
	mov dword [rsi + DRIVER_NIC_I82540EM_TIPG], eax

	; Configure the Control Register (CTRL)
	mov eax, dword [rsi + DRIVER_NIC_I82540EM_CTRL]
	or  eax, DRIVER_NIC_I82540EM_CTRL_SLU ; Set Link Up
	or  eax, DRIVER_NIC_I82540EM_CTRL_ASDE ; Auto-Speed Detection Enable
	and rax, ~DRIVER_NIC_I82540EM_CTRL_LRST ; Clear Link Reset
	and rax, ~DRIVER_NIC_I82540EM_CTRL_ILOS ; Clear Invert Loss of Signal
	and rax, ~DRIVER_NIC_I82540EM_CTRL_VME ; Clear VLAN Mode Enable
	and rax, DRIVER_NIC_I82540EM_CTRL_PHY_RST ; Clear PHY Reset
	mov dword [rsi + DRIVER_NIC_I82540EM_CTRL], eax

	; Mount the interrupt handler in the IDT
	movzx eax, byte [driver_nic_i82540em_irq_number]
	add   al, KERNEL_IDT_IRQ_offset
	mov   rbx, KERNEL_IDT_TYPE_irq
	mov   rdi, driver_nic_i82540em_irq
	call  kernel_idt_mount

	; Connect the IRQ to the IO APIC
	movzx ebx, byte [driver_nic_i82540em_irq_number]
	shl   ebx, STATIC_MULTIPLE_BY_2_shift
	add   ebx, KERNEL_IO_APIC_iowin
	call  kernel_io_apic_connect

	; Enable interrupts in the Interrupt Mask Set Register (IMS)
	mov rdi, qword [driver_nic_i82540em_mmio_base_address]
	mov dword [rdi + DRIVER_NIC_I82540EM_IMS], 00000000000000011111011011011111b

	; Restore registers
	pop rdi
	pop rax

	ret

; Debug macro to mark the end of the setup function
macro_debug "driver_nic_i82540em_setup"
