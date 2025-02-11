; Initializes the network subsystem
kernel_init_network:
	; Load PCI network class/subclass
	mov  eax, DRIVER_PCI_CLASS_SUBCLASS_network
	call driver_pci_find_class_and_subclass ; Find network device
	jc   .end ; If not found, exit

	mov  eax, DRIVER_PCI_REGISTER_vendor_and_device ; Load vendor/device register
	call driver_pci_read ; Read vendor and device ID

	cmp eax, DRIVER_NIC_I82540EM_VENDOR_AND_DEVICE ; Check if NIC is i82540EM
	jne .end ; If not, exit

	call driver_nic_i82540em ; Initialize NIC driver

	call kernel_memory_alloc_page ; Allocate memory for port table
	jc   kernel_panic ; Panic if allocation fails

	call kernel_page_drain ; Ensure memory is cleared
	mov  qword [service_network_port_table], rdi ; Store port table address

	call kernel_memory_alloc_page ; Allocate memory for network stack
	jc   kernel_panic ; Panic if allocation fails

	call kernel_page_drain ; Ensure memory is cleared
	mov  qword [service_network_stack_address], rdi ; Store stack address

.end:
