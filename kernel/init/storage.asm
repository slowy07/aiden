kernel_init_storage:
	mov  eax, DRIVER_PCI_CLASS_SUBCLASS_ide
	call driver_pci_find_class_and_subclass
	jc   .ide_end
	call driver_ide_init

	cmp byte [driver_ide_devices_count], STATIC_EMPTY
	je  .ide_end

	mov  ecx, kernel_init_string_storage_ide_end - kernel_init_string_storage_ide
	mov  rsi, kernel_init_string_storage_ide
	call kernel_video_string

	mov cl, 0x04

	mov rsi, kernel_init_string_storage_ide_hd

	mov rdi, driver_ide_devices

.ide_loop:
	cmp word [rdi + DRIVER_IDE_STRUCTURE_DEVICE.channel], STATIC_EMPTY
	je  .ide_next

	push rax
	push rcx
	push rsi
	push rdi

	mov rax, qword [rdi + DRIVER_IDE_STRUCTURE_DEVICE.size_sectors]
	shl rax, STATIC_MULTIPLE_BY_512_shift

	mov  ecx, kernel_init_string_storage_ide_hd_end - kernel_init_string_storage_ide_hd_path
	mov  rsi, kernel_init_string_storage_ide_hd_path
	call kernel_vfs_path_resolve
	mov  rbx, qword [rsp]
	mov  dl, KERNEL_VFS_FILE_TYPE_block_device
	call kernel_vfs_file_touch

	mov qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.size], rax

	mov  ecx, kernel_init_string_storage_ide_hd_end - kernel_init_string_storage_ide_hd
  mov rsi, kernel_init_string_storage_ide_hd
	call kernel_video_string

	mov  ecx, kernel_init_string_storage_ide_size_end - kernel_init_string_storage_ide_size
	mov  rsi, kernel_init_string_storage_ide_size
	call kernel_video_string

	shr  rax, STATIC_DIVIDE_BY_1024_shift
	mov  ebx, STATIC_NUMBER_SYSTEM_decimal
	xor  ecx, ecx
	call kernel_video_number

	mov  ecx, kernel_init_string_storage_ide_format_end - kernel_init_string_storage_ide_format
	mov  rsi, kernel_init_string_storage_ide_format
	call kernel_video_string

	pop rdi
	pop rsi
	pop rcx
	pop rax

.ide_next:
	inc byte [kernel_init_string_storage_ide_hd_letter]
	add rdi, DRIVER_IDE_STRUCTURE_DEVICE.SIZE

	dec cl
	jnz .ide_loop

.ide_end:
	xchg bx, bx
