%include "software/console/config.asm"

console:
	%include "software/console/init.asm"

.loop:
	mov ax, KERNEL_SERVICE_PROCESS_ipc_receive
	mov rdi, console_ipc_data
	int KERNEL_SERVICE
	jc  .loop

	cmp byte [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.type], SERVICE_RENDER_IPC_KEYBOARD
	jne .loop

	mov rax, qword [rdi + KERNEL_IPC_STRUCTURE.data + SERVICE_RENDER_STRUCTURE_IPC.value0]

	cmp rax, STATIC_ASCII_SPACE
	jb  .loop
	cmp rax, STATIC_ASCII_DELETE
	jae .loop

	mov  ecx, 1
	call include_terminal_char

	mov al, SERVICE_RENDER_WINDOW_update
	or  qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.flags], INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush

	jmp .loop

%include "software/console/data.asm"
%include "include/unit.asm"
%include "include/font.asm"
%include "include/page_from_size.asm"
%include "include/terminal.asm"
