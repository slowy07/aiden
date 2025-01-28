kernel_init_network:
	mov  eax, DRIVER_PCI_CLASS_SUBCLASS_network
	call driver_pci_find_class_and_subclass
	jc   .end

	mov  eax, DRIVER_PCI_REGISTER_vendor_and_device
	call driver_pci_read

	cmp eax, DRIVER_NIC_I82540EM_VENDOR_AND_DEVICE
	jne .end

	call driver_nic_i82540em

	call kernel_memory_alloc_page
	jc   kernel_panic
	call kernel_page_drain
	mov  qword [kernel_network_port_table], rdi

	call kernel_memory_alloc_page
	jc   kernel_panic

	call kernel_page_drain
	mov  qword [kernel_network_stack_address], rdi

.end: