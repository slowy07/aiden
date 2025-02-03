kernel_init_vfs:
	call kernel_memory_alloc_page
	jc   kernel_init_panic_low_memory

	call kernel_page_drain
	mov  qword [kernel_vfs_magicknot + KERNEL_STRUCTURE_VFS_MAGICKNOT.root], rdi

	mov rdi, kernel_vfs_magicknot

	mov  rsi, rdi
	call kernel_vfs_dir_symlinks

  mov rsi, kernel_init_vfs_directory_structure

.loop:
  movzx ecx, byte [rsi]

  test cl, cl
  jz .end

  inc rsi

  push rcx
  push rsi

  call kernel_vfs_path_resolve

  mov dl, KERNEL_VFS_FILE_TYPE_directory
  call kernel_vfs_file_touch

  pop rsi
  pop rcx

  add rsi, rcx
  jmp .loop

.end:
