KERNEL_VFS_FILE_TYPE_socket equ 01000000b
KERNEL_VFS_FILE_TYPE_symbolic_link equ 00100000b
KERNEL_VFS_FILE_TYPE_regular_file equ 00010000b
KERNEL_VFS_FILE_TYPE_block_device equ 00001000b
KERNEL_VFS_FILE_TYPE_directory equ 00000100b
KERNEL_VFS_FILE_TYPE_character_device equ 00000010b
KERNEL_VFS_FILE_TYPE_fifo equ 00000001b
KERNEL_VFS_FILE_TYPE_character_device_bit equ 1
KERNEL_VFS_FILE_TYPE_directory_bit equ 2
KERNEL_VFS_FILE_TYPE_block_device_bit equ 3
KERNEL_VFS_FILE_TYPE_regular_file_bit equ 4
KERNEL_VFS_FILE_TYPE_symbolic_link_bit equ 5

KERNEL_VFS_FILE_MODE_suid equ 0000100000000000b
KERNEL_VFS_FILE_MODE_sgid equ 0000010000000000b
KERNEL_VFS_FILE_MODE_sticky equ 0000001000000000b
KERNEL_VFS_FILE_MODE_USER_read equ 0000000100000000b
KERNEL_VFS_FILE_MODE_USER_write equ 0000000010000000b
KERNEL_VFS_FILE_MODE_USER_execute_or_traverse equ 0000000001000000b
KERNEL_VFS_FILE_MODE_USER_full_control equ 0000000111000000b
KERNEL_VFS_FILE_MODE_GROUP_read equ 0000000000100000b
KERNEL_VFS_FILE_MODE_GROUP_write equ 0000000000010000b
KERNEL_VFS_FILE_MODE_GROUP_execute_or_traverse equ 0000000000001000b
KERNEL_VFS_FILE_MODE_GROUP_full_control equ 0000000000111000b
KERNEL_VFS_FILE_MODE_OTHER_read equ 0000000000000100b
KERNEL_VFS_FILE_MODE_OTHER_write equ 0000000000000010b
KERNEL_VFS_FILE_MODE_OTHER_execute_or_traverse equ 0000000000000001b
KERNEL_VFS_FILE_MODE_OTHER_full_control equ 0000000000000111b
KERNEL_VFS_FILE_MODE_UNKNOWN_execute equ KERNEL_VFS_FILE_MODE_USER_execute_or_traverse | KERNEL_VFS_FILE_MODE_GROUP_execute_or_traverse | KERNEL_VFS_FILE_MODE_OTHER_execute_or_traverse

KERNEL_VFS_FILE_FLAGS_save equ 00000001b
KERNEL_VFS_FILE_FLAGS_reserved equ 00000010b

KERNEL_VFS_FILE_FLAGS_SAVE_bit equ 0
KERNEL_VFS_FILE_FLAGS_reserved_bit equ 1

KERNEL_VFS_ERROR_FILE_exists equ 0x01
KERNEL_VFS_ERROR_DIRECTORY_full equ 0x02
KERNEL_VFS_ERROR_FILE_not_exists equ 0x03
KERNEL_VFS_ERROR_FILE_name_long equ 0x04
KERNEL_VFS_ERROR_FILE_name_short equ 0x05
KERNEL_VFS_ERROR_FILE_low_memory equ 0x06
KERNEL_VFS_ERROR_FILE_overflow equ 0x07
KERNEL_VFS_ERROR_FILE_no_directory equ 0x08

struc KERNEL_VFS_STRUCTURE_MAGICKNOT
.root resb 8
.size resb 8
endstruc

struc   KERNEL_VFS_STRUCTURE_KNOT
.id_or_data     resb 8
.size   resb 8
.type   resb 1
.flags  resb 2
.time_modified     resb 8
.length resb 1
.name   resb 255

.SIZE:
	endstruc

	kernel_vfs_semaphore     db STATIC_FALSE

	kernel_vfs_magicknot     dq STATIC_EMPTY

	kernel_vfs_string_directory_local   db "."

kernel_vfs_string_directory_local_end:

kernel_vfs_dir_symlinks:
	push rax
	push rbx

	mov rbx, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rdi

	mov word [rbx + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_symbolic_link

	mov rax, qword [driver_rtc_microtime]
	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.time_modified], rax

	mov byte [rbx + KERNEL_VFS_STRUCTURE_KNOT.length], 0x01

	mov byte [rbx + KERNEL_VFS_STRUCTURE_KNOT.name], "."

	add rbx, KERNEL_VFS_STRUCTURE_KNOT.SIZE

	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rsi

	mov word [rbx + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_symbolic_link

	mov rax, qword [driver_rtc_microtime]
	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.time_modified], rax

	mov byte [rbx + KERNEL_VFS_STRUCTURE_KNOT.length], 0x02

	mov word [rbx + KERNEL_VFS_STRUCTURE_KNOT.name], ".."

	pop rbx
	pop rax

	ret

macro_debug "kernel_vfs_dir_symlinks"

kernel_vfs_path_resolve:
	push rax
	push rbx
	push rdx
	push rsi
	push rcx

	push STATIC_EMPTY

	xor ebx, ebx

	test rcx, rcx
	jz   .empty

	mov rdi, kernel_vfs_magicknot

	cmp byte [rsi], STATIC_ASCII_SLASH
	je  .prefix

	call kernel_task_active

	mov rdi, qword [rdi + KERNEL_TASK_STRUCTURE.knot]

	jmp .suffix

.prefix:
	dec rcx
	inc rsi

	test rcx, rcx
	jz   .root

	cmp byte [rsi], STATIC_ASCII_SLASH
	je  .prefix

.suffix:
	cmp byte [rsi + rcx - 0x01], STATIC_ASCII_SLASH
	jne .cut

	dec rcx

	test rcx, rcx
	jnz  .suffix

.cut:
	cmp byte [rsi + rcx - STATIC_BYTE_SIZE_byte], STATIC_ASCII_SLASH
	je  .loop

	inc rbx
	dec rcx

	test rcx, rcx
	jnz  .cut

	jmp .ready

.doubled:
	dec rcx
	inc rsi

.loop:
	test rcx, rcx
	jz   .ready

	mov qword [rsp], rcx

	mov  al, STATIC_ASCII_SLASH
	call include_string_cut
	jc   .ready

	test rcx, rcx
	jz   .leave

	mov eax, KERNEL_VFS_ERROR_FILE_not_exists

	call kernel_vfs_file_find
	jc   .error

	bt  word [rdi + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_symbolic_link_bit
	jnc .no_link

	mov rdi, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

.no_link:
	mov eax, KERNEL_VFS_ERROR_FILE_no_directory

	bt  word [rdi + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_directory_bit
	jnc .error

	sub qword [rsp], rcx
	add rsi, rcx

.leave:
	mov rcx, qword [rsp]

	jmp .doubled

.ready:
	mov rcx, rbx

.prepared:
	mov qword [rsp + STATIC_QWORD_SIZE_byte], rcx
	mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x02], rsi

	clc

	jmp .end

.root:
	mov rcx, kernel_vfs_string_directory_local_end - kernel_vfs_string_directory_local
	mov rsi, kernel_vfs_string_directory_local

	jmp .prepared

.empty:
	mov rax, KERNEL_VFS_ERROR_FILE_not_exists

.error:
	mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x05], rax

	stc

.end:
	add rsp, STATIC_QWORD_SIZE_byte

	pop rcx
	pop rsi
	pop rdx
	pop rbx
	pop rax

	ret

macro_debug "kernel_vfs_path_resolve"

kernel_vfs_file_touch:
	push rcx
	push rsi
	push rax

	mov eax, KERNEL_VFS_ERROR_FILE_name_long

	cmp rcx, KERNEL_VFS_STRUCTURE_KNOT.SIZE - KERNEL_VFS_STRUCTURE_KNOT.name
	ja  .error

	mov eax, KERNEL_VFS_ERROR_FILE_name_short

	cmp rcx, STATIC_EMPTY
	je  .error

	mov eax, KERNEL_VFS_ERROR_FILE_exists

	call kernel_vfs_file_find
	jnc  .error

	mov rax, KERNEL_VFS_ERROR_DIRECTORY_full

	call kernel_vfs_knot_prepare
	jc   .end

	mov rax, rdi

	cmp dl, KERNEL_VFS_FILE_TYPE_directory
	je  .directory

	cmp dl, KERNEL_VFS_FILE_TYPE_block_device
	jne .regular_file

	mov qword [rax + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rbx

	jmp .regular_file

.directory:
	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain

	mov qword [rax + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rdi
	mov qword [rax + KERNEL_VFS_STRUCTURE_KNOT.size], 1

.regular_file:
	mov byte [rax + KERNEL_VFS_STRUCTURE_KNOT.length], cl

	mov byte [rax + KERNEL_VFS_STRUCTURE_KNOT.type], dl

	push rax

	mov rdi, rax
	add rdi, KERNEL_VFS_STRUCTURE_KNOT.name
	rep movsb

	pop rdi

	jmp .end

.error:
	mov qword [rsp], rax

	stc

.end:
	pop rax
	pop rsi
	pop rcx

	ret

macro_debug "kernel_vfs_file_touch"

kernel_vfs_file_find:
	push rax
	push rcx
	push rsi
	push rdi

	mov rax, rcx

	mov rdi, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

.prepare:
	mov rcx, STATIC_STRUCTURE_BLOCK.link / KERNEL_VFS_STRUCTURE_KNOT.SIZE

.loop:
	cmp byte [rdi + KERNEL_VFS_STRUCTURE_KNOT.length], al
	jne .next

	add rdi, KERNEL_VFS_STRUCTURE_KNOT.name

	xchg rcx, rax

	call include_string_compare

	xchg rcx, rax

	jnc .found

	sub rdi, KERNEL_VFS_STRUCTURE_KNOT.name

.next:
	add rdi, KERNEL_VFS_STRUCTURE_KNOT.SIZE

	loop .loop

	and  di, KERNEL_PAGE_mask
	mov  rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]
	test rdi, rdi
	jnz  .prepare

	stc

	jmp .end

.found:
	sub rdi, KERNEL_VFS_STRUCTURE_KNOT.name
	mov qword [rsp], rdi

.end:
	pop rdi
	pop rsi
	pop rcx
	pop rax

	ret

macro_debug "kernel_vfs_file_find"

kernel_vfs_knot_prepare:
	push rcx

	macro_lock kernel_vfs_semaphore, 0

	mov rdi, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

.prepare:
	mov ecx, STATIC_STRUCTURE_BLOCK.link / KERNEL_VFS_STRUCTURE_KNOT.SIZE

.loop:
	cmp byte [rdi + KERNEL_VFS_STRUCTURE_KNOT.type], STATIC_EMPTY
	je  .ready

	add rdi, KERNEL_VFS_STRUCTURE_KNOT.SIZE

	loop .loop

	and  di, KERNEL_PAGE_mask
	mov  rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]
	test rdi, rdi
	jnz  .prepare

	mov rcx, rdi

	call kernel_memory_alloc_page
	jnc  .ok

	stc

	jmp .end

.ok:
	call kernel_page_drain

	mov qword [rcx], rdi

.ready:
	mov byte [rdi + KERNEL_VFS_STRUCTURE_KNOT.length], STATIC_TRUE

.end:
	mov byte [kernel_vfs_semaphore], STATIC_FALSE

	pop rcx

	ret

macro_debug "kernel_vfs_knot_prepare"

kernel_vfs_file_write:
	push rax
	push rbx
	push rdx
	push rcx
	push rdi

	mov rbx, rdi

	cmp qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], STATIC_EMPTY
	jne .exist

	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain

	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rdi

.exist:
	mov rdx, qword [rsp + STATIC_QWORD_SIZE_byte]

	mov rdi, qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

	cmp rcx, STATIC_STRUCTURE_BLOCK.link
	jbe .all_in_one

	mov  rax, STATIC_STRUCTURE_BLOCK.link
	xchg rax, rcx
	xor  edx, edx
	div  rcx

	test dx, dx
	jz   .no_modulo

	mov ecx, STATIC_TRUE

.no_modulo:
	add  rcx, rax
	call kernel_page_secure
	jc   .end

	mov rbp, rcx

	mov rdx, qword [rsp + STATIC_QWORD_SIZE_byte]

.loop:
	mov ecx, STATIC_STRUCTURE_BLOCK.link
	shr ecx, STATIC_DIVIDE_BY_8_shift
	rep movsq

	sub rdx, STATIC_STRUCTURE_BLOCK.link

	cmp qword [rdi], STATIC_EMPTY
	jne .next_block

.next_block:
	mov rdi, qword [rdi]

	cmp rdx, STATIC_STRUCTURE_BLOCK.link
	ja  .loop

.all_in_one:
	test rdx, rdx
	jz   .saved

	mov rcx, rdx
	rep movsb

	and di, KERNEL_PAGE_mask
	mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

.remove:
	test rdi, rdi
	jz   .saved

	push qword [rdi + STATIC_STRUCTURE_BLOCK.link]

	call kernel_memory_release_page

	pop rdi

	jmp .remove

.saved:
	sub qword [kernel_page_reserved_count], rbp
	add qword [kernel_page_free_count], rbp

	mov rcx, qword [rsp + STATIC_QWORD_SIZE_byte]
	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.size], rcx

	mov rcx, qword [driver_rtc_microtime]
	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.time_modified], rcx

.end:
	pop rdi
	pop rcx
	pop rdx
	pop rbx
	pop rax

	ret

macro_debug "kernel_vfs_file_write"

kernel_vfs_file_append:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	push rcx

	mov rbx, rdi

	cmp qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], STATIC_EMPTY
	jne .exist

	mov eax, KERNEL_VFS_ERROR_FILE_low_memory

	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain

	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data], rdi

.exist:
	mov rdi, qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

.last_one:
	cmp qword [rdi + STATIC_STRUCTURE_BLOCK.link], STATIC_EMPTY
	je  .found

	mov rdi, qword [rdi + STATIC_STRUCTURE_BLOCK.link]

	jmp .last_one

.found:
	mov rax, qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.size]
	mov rcx, STATIC_STRUCTURE_BLOCK.link
	xor edx, edx
	div rcx

	add rdi, rax

	sub rax, STATIC_STRUCTURE_BLOCK.link
	not rax
	inc rax

	mov rcx, rax

	cmp rcx, qword [rsp]
	jbe .more

.less:
	xor ecx, ecx

	xchg rcx, qword [rsp]

	jmp .write

.more:
	sub qword [rsp], rcx

.write:
	rep movsb

	cmp qword [rsp], STATIC_EMPTY
	je  .ready

	mov rdx, rdi

	mov eax, KERNEL_VFS_ERROR_FILE_low_memory

	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain

	mov qword [rdx], rdi

	mov ecx, STATIC_STRUCTURE_BLOCK.link

	cmp qword [rsp], rcx
	jbe .less
	ja  .more

.ready:
	mov rcx, qword [rsp + STATIC_QWORD_SIZE_byte * 0x03]
	add qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.size], rcx

	mov rcx, qword [driver_rtc_microtime]
	mov qword [rbx + KERNEL_VFS_STRUCTURE_KNOT.time_modified], rcx

.end:
	add rsp, STATIC_QWORD_SIZE_byte

	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_vfs_file_append"

kernel_vfs_file_read:
	push rax
	push rdx
	push rsi
	push rdi

.symbolic_link:
	bt  word [rsi + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_symbolic_link_bit
	jnc .file

	mov rsi, qword [rsi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

	jmp .symbolic_link

.file:
	mov rax, qword [rsi + KERNEL_VFS_STRUCTURE_KNOT.size]

	bt  word [rsi + KERNEL_VFS_STRUCTURE_KNOT.type], KERNEL_VFS_FILE_TYPE_directory_bit
	jnc .regular_file

	mov rcx, STATIC_STRUCTURE_BLOCK.link
	mul rcx

.regular_file:
	push rax

	mov rsi, qword [rsi + KERNEL_VFS_STRUCTURE_KNOT.id_or_data]

.loop:
	mov rcx, STATIC_STRUCTURE_BLOCK.link

	cmp rax, rcx
	ja  .next_block

	mov rcx, rax

.next_block:
	sub rax, rcx

	rep movsb

	and si, KERNEL_PAGE_mask
	mov rsi, qword [rsi + STATIC_STRUCTURE_BLOCK.link]

	test rax, rax
	jnz  .loop

	pop rcx

	pop rdi
	pop rsi
	pop rdx
	pop rax

	ret

macro_debug "kernel_vfs_file_read"
