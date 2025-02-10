struc	KERNEL_INIT_STRUCTURE_VFS_FILE
	.data_pointer	resb	8
	.size		resb	8
	.length		resb	1
	.path:
	.SIZE:
endstruc

kernel_init_vfs:
	call	kernel_memory_alloc_page
	jc	kernel_init_panic_low_memory	

	call	kernel_page_drain
	mov	qword [kernel_vfs_magicknot + KERNEL_VFS_STRUCTURE_MAGICKNOT.root],	rdi

	mov	rdi,	kernel_vfs_magicknot

	mov	rsi,	rdi
	call	kernel_vfs_dir_symlinks

	mov	rsi,	kernel_init_vfs_directory_structure

.dir:
	movzx	ecx,	byte [rsi]

	test	cl,	cl
	jz	.next	

	inc	rsi

	push	rcx
	push	rsi

	call	kernel_vfs_path_resolve

	mov	dl,	KERNEL_VFS_FILE_TYPE_directory
	call	kernel_vfs_file_touch

	pop	rsi
	pop	rcx

	add	rsi,	rcx

	jmp	.dir

.next:
	mov	rsi,	kernel_init_vfs_files

.file:
	cmp	qword [rsi],	STATIC_EMPTY
	je	.end	

	push	rsi

	movzx	ecx,	byte [rsi + KERNEL_INIT_STRUCTURE_VFS_FILE.length]
	mov	dl,	KERNEL_VFS_FILE_TYPE_regular_file
	add	rsi,	KERNEL_INIT_STRUCTURE_VFS_FILE.path
	call	kernel_vfs_path_resolve
	call	kernel_vfs_file_touch

	mov	rsi,	qword [rsp]	
	mov	rcx,	qword [rsi + KERNEL_INIT_STRUCTURE_VFS_FILE.size]
	mov	rsi,	qword [rsi + KERNEL_INIT_STRUCTURE_VFS_FILE.data_pointer]
	call	kernel_vfs_file_append

	pop	rsi

	movzx	ecx,	byte [rsi + KERNEL_INIT_STRUCTURE_VFS_FILE.length]
	add	rsi,	rcx
	add	rsi,	KERNEL_INIT_STRUCTURE_VFS_FILE.SIZE

	jmp	.file

.end:
