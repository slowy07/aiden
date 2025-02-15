kernel_service:
	push rax

	cmp al, KERNEL_SERVICE_PROCESS
	je  .process

	cmp al, KERNEL_SERVICE_VIDEO
	je  .video

	cmp al, KERNEL_SERVICE_VFS
	je  .vfs

	cmp al, KERNEL_SERVICE_SYSTEM
	je  .system

.error:
	stc

.end:
	pushf
	pop rax

	mov qword [rsp + KERNEL_TASK_STRUCTURE_IRETQ.eflags + STATIC_QWORD_SIZE_byte], rax

	pop rax

	iretq

.process:
	cmp ax, KERNEL_SERVICE_PROCESS_exit
	je  kernel_task_kill

	cmp ax, KERNEL_SERVICE_PROCESS_run
	je  .process_run

	cmp ax, KERNEL_SERVICE_PROCESS_check
	je  .process_check

	cmp ax, KERNEL_SERVICE_PROCESS_memory_alloc
	je  .process_memory_alloc

	cmp ax, KERNEL_SERVICE_PROCESS_ipc_receive
	je  .process_ipc_receive

	cmp ax, KERNEL_SERVICE_PROCESS_pid
	je  .process_pid

	jmp kernel_service.error

.process_run:
	push rsi
	push rdi
	push rcx

	call kernel_vfs_path_resolve
	jc   .process_run_end

	call kernel_vfs_file_find
	jc   .process_run_end

	call kernel_exec

	mov qword [rsp], rcx

.process_run_end:
	pop rcx
	pop rdi
	pop rsi

	mov qword [rsp], rax

	jmp kernel_service.end

.process_check:
	call kernel_task_pid_check

	jmp kernel_service.end

.process_memory_alloc:
	push rax
	push rbx
	push rcx
	push rdi
	push r8
	push r11

	call include_page_from_size

	call kernel_service_memory_alloc
	jc   .process_memory_alloc_error

	mov  rax, rdi
	sub  rax, qword [kernel_memory_high_mask]
	mov  bx, KERNEL_PAGE_FLAG_write | KERNEL_PAGE_FLAG_user | KERNEL_PAGE_FLAG_available
	mov  r11, cr3
	call kernel_page_map_logical
	jnc  .process_memory_alloc_ready

	call kernel_service_memory_release

.process_memory_alloc_error:
	stc
	mov qword [rsp + STATIC_QWORD_SIZE_byte], KERNEL_ERROR_memory_low

	jmp .process_memory_alloc_end

.process_memory_alloc_ready:
	mov qword [rsp], rdi

.process_memory_alloc_end:
	pop rdi
	pop rax
	pop r11
	pop r8
	pop rcx
	pop rbx

	jmp kernel_service.end

.process_ipc_receive:
  call kernel_ipc_receive
  jmp kernel_service.end

.process_pid:
  call kernel_task_active_pid
  mov qword [rsp], rax

  jmp kernel_service.end

.video:
	cmp ax, KERNEL_SERVICE_VIDEO_properties
	je  .video_properties

	jmp kernel_service.error

.video_properties:
	mov r8, qword [kernel_video_width_pixel]
	mov r9, qword [kernel_video_height_pixel]

	mov r10, qword [kernel_video_size_byte]

	jmp kernel_service.end

.vfs:
	cmp ax, KERNEL_SERVICE_VFS_exist
	jne kernel_service.error

	xor eax, eax

	push rcx
	push rsi
	push rdi

	call kernel_vfs_path_resolve
	jc   .vfs_exist_not

	call kernel_vfs_file_find

.vfs_exist_not:
	pop rdi
	pop rsi
	pop rcx

	mov qword [rsp], rax

	jmp kernel_service.end

.system:
	cmp ax, KERNEL_SERVICE_SYSTEM_memory
	jne kernel_service.error

	mov r8, qword [kernel_page_total_count]
	mov r9, qword [kernel_page_free_count]
	mov r10, qword [kernel_page_paged_count]

	jmp kernel_service.end

kernel_service_memory_alloc:
  push rbx
  push rdx
  push rsi
  push rdi
  push rax
  push rcx

  mov rax, STATIC_MAX_unsigned
  
  call kernel_task_active

  mov rcx, qword [rdi + KERNEL_TASK_STRUCTURE.map_size]
  mov rsi, qword [rdi + KERNEL_TASK_STRUCTURE.map]

.reload:
  xor edx, edx

.search:
  inc rax

  cmp rax, rcx
  je .error

  bt qword [rsi], rax
  jnz .search

  mov rbx, rax

.check:
  inc rax

  inc rdx

  cmp rdx, qword [rsp]
  je .found

  cmp rax, rcx
  je .error

  bt qword [rsi], rax
  jc .check

  jmp .reload

.error:
  mov qword [rsp + STATIC_QWORD_SIZE_byte], KERNEL_ERROR_memory_low
  stc
  jmp .end

.found:
  mov rax, rbx

.lock:
  btr qword [rsi], rax

  inc rax

  dec rdx
  jnz .lock

  shl rbx, STATIC_MULTIPLE_BY_PAGE_shift

  add rbx, qword [kernel_memory_real_address]

  mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x02], rbx

.end:
  pop rcx
  pop rax
  pop rdi
  pop rsi
  pop rdx
  pop rbx

  ret

  macro_debug "kernel_service_memory_alloc"

kernel_service_memory_release:
  push rax
  push rdx
  push rsi
  push rdi
  push rcx

  call kernel_task_active

  mov rax, rdi
  sub rax, qword [kernel_memory_real_address]
  shr rax, KERNEL_PAGE_SIZE_shift
  
  mov rcx, 64
  xor rdx, rdx
  div rcx

  shl rax, STATIC_MULTIPLE_BY_8_shift
  add rsi, rax

  mov rcx, qword [rsp]

.loop:
  bts qword [rsi], rdx

  inc rdx
  
  dec rcx
  jnz .loop

  pop rcx
  pop rdi
  pop rsi
  pop rdx
  pop rax

  ret

  macro_debug "kernel_service_memory_release"
