KERNEL_DEBUG_FLOW_offset equ 0x02
KERNEL_DEBUG_REGISTER_offset equ 0x05
KERNEL_DEBUG_CODE_offset equ 0x15
KERNEL_DEBUG_TASK_offset equ 0x15
KERNEL_DEBUG_PAGE_offset equ 0x15
KERNEL_DEBUG_PAGE_offset_in_row equ 0x05
KERNEL_DEBUG_TASK_offset_in_row equ 0x02
KERNEL_DEBUG_STACK_offset equ 0x40
KERNEL_DEBUG_MEMORY_offset equ 0x15

struc   KERNEL_DEBUG_STRUCTURE_PRESERVED
.rax    resb 8
.rbx    resb 8
.rcx    resb 8
.rdx    resb 8
.rsi    resb 8
.rdi    resb 8
.rbp    resb 8
.r8     resb 8
.r9     resb 8
.r10    resb 8
.r11    resb 8
.r12    resb 8
.r13    resb 8
.r14    resb 8
.r15    resb 8
.eflags resb 8

.SIZE:
	endstruc

	kernel_debug_string_welcome  db STATIC_COLOR_ASCII_MAGENTA_LIGHT, "Press ESC key to enter GOD mode."

kernel_debug_string_welcome_end:
	kernel_debug_string_process_name db STATIC_COLOR_ASCII_GRAY_LIGHT, "Process name ", STATIC_COLOR_ASCII_GRAY, "(PID)", STATIC_COLOR_ASCII_GRAY_LIGHT, ": ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_process_name_end:
	kernel_debug_string_pid   db " ", STATIC_COLOR_ASCII_GRAY, "("

kernel_debug_string_pid_end:
	kernel_debug_string_pid_close  db ")", STATIC_ASCII_NEW_LINE

kernel_debug_string_pid_close_end:

	kernel_debug_string_eflags  db STATIC_COLOR_ASCII_GRAY_LIGHT, "Eflags: ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_eflags_end:

	kernel_debug_string_rax   db STATIC_COLOR_ASCII_GRAY_LIGHT, "rax ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rax_end:
	kernel_debug_string_rbx   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rbx ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rbx_end:
	kernel_debug_string_rcx   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rcx ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rcx_end:
	kernel_debug_string_rdx   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rdx ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rdx_end:
	kernel_debug_string_rsi   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rsi ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rsi_end:
	kernel_debug_string_rdi   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rdi ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rdi_end:
	kernel_debug_string_rbp   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rbp ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rbp_end:
	kernel_debug_string_rsp   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "rsp ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_rsp_end:
	kernel_debug_string_r8   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r8  ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r8_end:
	kernel_debug_string_r9   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r9  ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r9_end:
	kernel_debug_string_r10   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r10 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r10_end:
	kernel_debug_string_r11   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r11 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r11_end:
	kernel_debug_string_r12   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r12 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r12_end:
	kernel_debug_string_r13   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r13 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r13_end:
	kernel_debug_string_r14   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r14 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r14_end:
	kernel_debug_string_r15   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "r15 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_r15_end:
	kernel_debug_string_cr0   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "cr0 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_cr0_end:
	kernel_debug_string_cr2   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "cr2 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_cr2_end:
	kernel_debug_string_cr3   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "cr3 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_cr3_end:
	kernel_debug_string_cr4   db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_GRAY_LIGHT, "cr4 ", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_cr4_end:

	kernel_debug_string_memory  db STATIC_COLOR_ASCII_GRAY, "Address          Memory                                          Content", STATIC_COLOR_ASCII_GRAY_LIGHT, STATIC_ASCII_NEW_LINE

kernel_debug_string_memory_end:

	kernel_debug_string_task  db STATIC_COLOR_ASCII_GRAY_LIGHT, "Task queue properties (Size [Bytes]/Task Count/Free):", STATIC_COLOR_ASCII_WHITE, STATIC_ASCII_NEW_LINE

kernel_debug_string_task_end:
	kernel_debug_string_separator db STATIC_COLOR_ASCII_GRAY, "/", STATIC_COLOR_ASCII_WHITE

kernel_debug_string_separator_end:

	kernel_debug_string_page  db STATIC_COLOR_ASCII_GRAY_LIGHT, "Pages (Total/Used/Free)", STATIC_COLOR_ASCII_WHITE, STATIC_ASCII_NEW_LINE

kernel_debug_string_page_end:

kernel_debug_assembly_table:
	db 0x02, 0x00, 0x31, 0xC9, 0x0C, "xor ecx, ecx"
	db 0x02, 0x08, 0x48, 0xBE, 0x09, "mov rsi, "
	db 0x01, 0x01, 0x72, 0x04, "jb +"
	db 0x01, 0x01, 0x73, 0x05, "jnb +"
	db 0x01, 0x04, 0xB9, 0x09, "mov ecx, "
	db 0x01, 0x04, 0xBB, 0x09, "mov ebx, "
	db 0x01, 0x01, 0xCD, 0x04, "int "
	db 0x01, 0x04, 0xE8, 0x05, "call "
	db 0x01, 0x01, 0xEB, 0x05, "jmp -"
	db STATIC_EMPTY

kernel_debug_assembly_table_end:

kernel_debug:
	xchg bx, bx

	pushf
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push rbp
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax

	call kernel_video_cursor_disable

	mov  ecx, kernel_debug_string_welcome_end - kernel_debug_string_welcome
	mov  rsi, kernel_debug_string_welcome
	call kernel_video_string

.any:
	call kernel_video_drain

	call kernel_task_active

	mov  ecx, kernel_debug_string_process_name_end - kernel_debug_string_process_name
	mov  rsi, kernel_debug_string_process_name
	call kernel_video_string
	mov  cl, byte [rdi + KERNEL_TASK_STRUCTURE.length]
	mov  rsi, rdi
	add  rsi, KERNEL_TASK_STRUCTURE.name
	call kernel_video_string

	mov  ecx, kernel_debug_string_pid_end - kernel_debug_string_pid
	mov  rsi, kernel_debug_string_pid
	call kernel_video_string
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid]
	mov  bl, STATIC_NUMBER_SYSTEM_hexadecimal
	xor  ecx, ecx
	call kernel_video_number
	mov  ecx, kernel_debug_string_pid_close_end - kernel_debug_string_pid_close
	mov  rsi, kernel_debug_string_pid_close
	call kernel_video_string

	call kernel_debug_registers

	mov rsi, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.SIZE]

	cmp qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.SIZE + KERNEL_TASK_STRUCTURE_IRETQ.cs], KERNEL_STRUCTURE_GDT.cs_ring0
	je  .rip

	cmp qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.SIZE + KERNEL_TASK_STRUCTURE_IRETQ.cs], KERNEL_STRUCTURE_GDT.cs_ring3
	je  .rip

	mov rsi, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.SIZE + STATIC_QWORD_SIZE_byte]

.rip:
	call kernel_debug_memory

	call kernel_debug_task

	call kernel_debug_page

	jmp $

macro_debug "kernel_debug"

kernel_debug_assembly:

	ret

kernel_debug_page:
	mov  dword [kernel_video_cursor.x], KERNEL_DEBUG_PAGE_offset
	mov  dword [kernel_video_cursor.y], KERNEL_DEBUG_PAGE_offset_in_row
	call kernel_video_cursor_set

	mov  ecx, kernel_debug_string_page_end - kernel_debug_string_page
	mov  rsi, kernel_debug_string_page
	call kernel_video_string

	mov  dword [kernel_video_cursor.x], KERNEL_DEBUG_PAGE_offset
	call kernel_video_cursor_set

	mov  rax, qword [kernel_page_total_count]
	mov  bl, STATIC_NUMBER_SYSTEM_decimal
	xor  ecx, ecx
	call kernel_video_number

	mov  ecx, kernel_debug_string_separator_end - kernel_debug_string_separator
	mov  rsi, kernel_debug_string_separator
	call kernel_video_string

	sub  rax, qword [kernel_page_free_count]
	xor  ecx, ecx
	call kernel_video_number

	mov  ecx, kernel_debug_string_separator_end - kernel_debug_string_separator
	mov  rsi, kernel_debug_string_separator
	call kernel_video_string

	mov  rax, qword [kernel_page_free_count]
	xor  ecx, ecx
	call kernel_video_number

	ret

macro_debug "kernel_debug_page"

kernel_debug_task:
	mov  dword [kernel_video_cursor.x], KERNEL_DEBUG_TASK_offset
	mov  dword [kernel_video_cursor.y], KERNEL_DEBUG_TASK_offset_in_row
	call kernel_video_cursor_set

	mov  ecx, kernel_debug_string_task_end - kernel_debug_string_task
	mov  rsi, kernel_debug_string_task
	call kernel_video_string

	mov  dword [kernel_video_cursor.x], KERNEL_DEBUG_TASK_offset
	call kernel_video_cursor_set

	mov rax, qword [kernel_task_size_page]
	mov rcx, rax
	shl rax, STATIC_MULTIPLE_BY_PAGE_shift
	shl rcx, STATIC_MULTIPLE_BY_QWORD_shift
	sub rax, rcx

	mov  bl, STATIC_NUMBER_SYSTEM_decimal
	xor  ecx, ecx
	call kernel_video_number

	mov  ecx, kernel_debug_string_separator_end - kernel_debug_string_separator
	mov  rsi, kernel_debug_string_separator
	call kernel_video_string

	mov  rax, qword [kernel_task_count]
	xor  ecx, ecx
	call kernel_video_number

	mov  ecx, kernel_debug_string_separator_end - kernel_debug_string_separator
	mov  rsi, kernel_debug_string_separator
	call kernel_video_string

	mov  rax, qword [kernel_task_free]
	xor  ecx, ecx
	call kernel_video_number

	ret

macro_debug "kernel_debug_task"

kernel_debug_memory:
	push rsi

	mov r8, 0x10

	mov  dword [kernel_video_cursor.x], STATIC_EMPTY
	mov  dword [kernel_video_cursor.y], 18
	call kernel_video_cursor_set

	mov  ecx, kernel_debug_string_memory_end - kernel_debug_string_memory
	mov  rsi, kernel_debug_string_memory
	call kernel_video_string

	mov rsi, qword [rsp]
	and si, STATIC_WORD_mask - STATIC_BYTE_LOW_mask

	mov rsi, qword [kernel_memory_map_address]

.row:
	mov  rax, rsi
	mov  bl, STATIC_NUMBER_SYSTEM_hexadecimal
	mov  ecx, STATIC_QWORD_DIGIT_length
	mov  edx, STATIC_ASCII_DIGIT_0
	call kernel_video_number

	push rsi

	mov r9, 16

.memory:
	mov  eax, STATIC_ASCII_SPACE
	mov  ecx, 0x01
	call kernel_video_char

	lodsb
	mov  cl, 0x02
	call kernel_video_number

	dec r9
	jnz .memory

	mov  eax, STATIC_ASCII_SPACE
	mov  ecx, 0x01
	call kernel_video_char

	mov rsi, qword [rsp]

	mov r9, 16

.ascii:
	lodsb

	cmp al, STATIC_ASCII_SPACE
	jb  .hidden
	cmp al, STATIC_ASCII_TILDE
	jb  .show

.hidden:
	mov al, STATIC_ASCII_DOT

.show:
	mov  cl, 0x01
	call kernel_video_char

	dec r9
	jnz .ascii

	mov  al, STATIC_ASCII_NEW_LINE
	call kernel_video_char

	pop rsi

	add rsi, 0x10

	dec r8
	jnz .row

	pop rsi

	ret

macro_debug "kernel_debug_memory"

kernel_debug_registers:
	mov  dword [kernel_video_cursor.x], STATIC_EMPTY
	mov  dword [kernel_video_cursor.y], KERNEL_DEBUG_FLOW_offset
	call kernel_video_cursor_set

	mov bl, STATIC_NUMBER_SYSTEM_hexadecimal

	mov edx, STATIC_ASCII_DIGIT_0

	mov  ecx, kernel_debug_string_rax_end - kernel_debug_string_rax
	mov  rsi, kernel_debug_string_rax
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rax + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rbx_end - kernel_debug_string_rbx
	mov  rsi, kernel_debug_string_rbx
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rbx + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rcx_end - kernel_debug_string_rcx
	mov  rsi, kernel_debug_string_rcx
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rcx + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rdx_end - kernel_debug_string_rdx
	mov  rsi, kernel_debug_string_rdx
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rdx + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rsi_end - kernel_debug_string_rsi
	mov  rsi, kernel_debug_string_rsi
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rsi + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rdi_end - kernel_debug_string_rdi
	mov  rsi, kernel_debug_string_rdi
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rdi + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_rbp_end - kernel_debug_string_rbp
	mov  rsi, kernel_debug_string_rbp
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.rbp + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r8_end - kernel_debug_string_r8
	mov  rsi, kernel_debug_string_r8
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r8 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r9_end - kernel_debug_string_r9
	mov  rsi, kernel_debug_string_r9
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r9 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r10_end - kernel_debug_string_r10
	mov  rsi, kernel_debug_string_r10
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r10 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r11_end - kernel_debug_string_r11
	mov  rsi, kernel_debug_string_r11
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r11 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r12_end - kernel_debug_string_r12
	mov  rsi, kernel_debug_string_r12
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r12 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r13_end - kernel_debug_string_r13
	mov  rsi, kernel_debug_string_r13
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r13 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r14_end - kernel_debug_string_r14
	mov  rsi, kernel_debug_string_r14
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r14 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	mov  ecx, kernel_debug_string_r15_end - kernel_debug_string_r15
	mov  rsi, kernel_debug_string_r15
	call kernel_video_string
	mov  rax, qword [rsp + KERNEL_DEBUG_STRUCTURE_PRESERVED.r15 + STATIC_QWORD_SIZE_byte]
	mov  ecx, STATIC_QWORD_DIGIT_length
	call kernel_video_number

	ret

macro_debug "kernel_debug_registers"
