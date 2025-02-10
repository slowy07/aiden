%include "include/unit/config.asm"
%include "include/unit/data.asm"
%include "include/unit/font.asm"

include_unit:
	push rax
	push rbx
	push rdi
	push rsi
	push rcx

	mov r8, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov r9, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]

	mov r10, r8
	shl r10, KERNEL_VIDEO_DEPTH_shift

	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline], r10

	mov rax, r10
	mul r9
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.size], rax

	test qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.flags], INCLUDE_UNIT_WINDOW_FLAG_unregistered
	jnz  .unregistered

	mov al, SERVICE_RENDER_WINDOW_create
	int SERVICE_RENDER_IRQ

	mov qword [rsp], rcx

.unregistered:
	mov eax, INCLUDE_UNIT_WINDOW_BACKGROUND_color
	mov rcx, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.size]
	shr rcx, KERNEL_VIDEO_DEPTH_shift
	mov rdi, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.address]
	rep stosd

	call include_unit_elements

	pop rcx
	pop rsi
	pop rdi
	pop rbx
	pop rax

	ret

include_unit_elements_specification:
	push rax
	push rsi

	xor r8, r8

	xor r9, r9

	add rsi, INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.SIZE

.loop:
	cmp dword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.type], STATIC_EMPTY
	je  .end

	cmp dword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.type], INCLUDE_UNIT_ELEMENT_TYPE_chain
	je  .next

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x]
	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]

	cmp rax, r8
	jbe .y

	mov r8, rax

.y:
	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]

	cmp rax, r9
	jbe .next

	mov r9, rax

.next:
	add rsi, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.size]

	jmp .loop

.end:
	pop rsi
	pop rax

	ret

include_unit_elements:
	push rax
	push rbx
	push rcx
	push rsi

	mov rbx, include_unit_element_entry

	mov rdi, rsi

	add rsi, INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.SIZE

.loop:
	mov eax, dword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.type]
	cmp eax, STATIC_EMPTY
	je  .ready

	cmp eax, INCLUDE_UNIT_ELEMENT_TYPE_draw
	je  .leave

	call qword [rbx + rax * STATIC_QWORD_SIZE_byte]

.leave:
	add rsi, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.size]

	jmp .loop

.ready:
	pop rsi
	pop rcx
	pop rbx
	pop rax

	ret

include_unit_element_header:
	push rax
	push rbx
	push rcx
	push rdx
	push r11
	push r12
	push r13
	push r15
	push rdi
	push rsi

	mov rbx, rdi

	mov r11, r8

	mov r12, INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel
	mov r13, r11
	shl r13, KERNEL_VIDEO_DEPTH_shift

	mov rdi, qword [rbx + INCLUDE_UNIT_STRUCTURE_WINDOW.address]

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_HEADER.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	mul r10
	add rdi, rax

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_HEADER.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	add rdi, rax

	mov  eax, INCLUDE_UNIT_ELEMENT_HEADER_BACKGROUND_color
	call include_unit_element_drain

	mov   ebx, INCLUDE_UNIT_ELEMENT_HEADER_FOREGROUND_color
	movzx rcx, byte [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_HEADER.length]
	add   rsi, INCLUDE_UNIT_STRUCTURE_ELEMENT_HEADER.string
	add   rdi, INCLUDE_UNIT_ELEMENT_HEADER_PADDING_LEFT_pixel << KERNEL_VIDEO_DEPTH_shift
	call  include_unit_string

	pop rsi
	pop rdi
	pop r15
	pop r13
	pop r12
	pop r11
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

include_unit_string:
	push rax
	push rdi
	push r9
	push r13

	xor rax, rax

.loop:
	lodsb

	call include_unit_char

	add rdi, INCLUDE_UNIT_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift

	dec rcx
	jz  .end

	sub r11, INCLUDE_UNIT_FONT_WIDTH_pixel
	jns .loop

.end:
	pop r13
	pop r9
	pop rdi
	pop rax

	ret

include_unit_char:
	push rax
	push rcx
	push rdx
	push rsi
	push rdi
	push r12
	push r11

	mov rsi, include_unit_font_matrix

	sub al, byte [include_unit_font_offset]
	js  .end

	mul qword [include_unit_font_height_pixel]
	add rsi, rax

	mov eax, ebx

	mov rdx, qword [include_unit_font_height_pixel]

.next:
	mov r11, qword [rsp]

	mov rcx, qword [include_unit_font_width_pixel]
	dec rcx

.loop:
	bt  word [rsi], cx
	jnc .omit

	stosd

	mov dword [rdi], STATIC_EMPTY

	jmp .continue

.omit:
	add rdi, KERNEL_VIDEO_DEPTH_byte

.continue:
	dec r11
	jnz .continue_pixels

	shl rcx, KERNEL_VIDEO_DEPTH_shift
	add rdi, rcx

	jmp .end_of_line

.continue_pixels:
	dec rcx
	jns .loop

.end_of_line:
	sub rdi, INCLUDE_UNIT_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift
	add rdi, r10

	inc rsi

	dec r12
	jz  .end

.line_invisible:
	dec rdx
	jnz .next

.end:
	pop r11
	pop r12
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rax

	ret

include_unit_element_button:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13

	mov r8, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov r9, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	mov r10, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline]

	mov r11, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov r12, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	mov r13, r11
	shl r13, KERNEL_VIDEO_DEPTH_shift

	xor eax, eax

	mov rbx, rdi

	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	mul r13
	mov rdi, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x]
	shl rdi, KERNEL_VIDEO_DEPTH_shift
	add rdi, rax
	add rdi, qword [rbx + INCLUDE_UNIT_STRUCTURE_WINDOW.address]

	mov  eax, INCLUDE_UNIT_ELEMENT_BUTTON_BACKGROUND_color
	call include_unit_element_drain

	movzx rcx, byte [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.length]

	mov   ebx, INCLUDE_UNIT_ELEMENT_BUTTON_FOREGROUND_color
	movzx ecx, byte [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.length]
	add   rsi, INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.string
	call  include_unit_string

	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

include_unit_element_drain:
	push rcx
	push rdx
	push rdi
	push r12

.loop:
	mov rcx, r11
	rep stosd

	sub rdi, r13
	add rdi, r10

	dec r12
	jnz .loop

	pop r12
	pop rdi
	pop rdx
	pop rcx

	ret

include_unit_element_chain:
	ret

include_unit_element_label:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13

	mov r8, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov r9, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	mov r10, qword [rdi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline]

	mov r11, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov r12, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	mov r13, r11
	shl r13, KERNEL_VIDEO_DEPTH_shift

	mov rbx, rdi

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	mul r10
	mov rdi, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x]
	shl rdi, KERNEL_VIDEO_DEPTH_shift
	add rdi, rax
	add rdi, qword [rbx + INCLUDE_UNIT_STRUCTURE_WINDOW.address]

	mov  eax, INCLUDE_UNIT_ELEMENT_LABEL_BACKGROUND_color
	call include_unit_element_drain

	movzx rcx, byte [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.length]

	mov   ebx, INCLUDE_UNIT_ELEMENT_LABEL_FOREGROUND_color
	movzx ecx, byte [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.length]
	add   rsi, INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.string
	call  include_unit_string

	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

include_unit_element:
	push rax
	push rcx
	push r8
	push r9
	push rsi

	add rsi, INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.SIZE

.loop:
	cmp dword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.type], STATIC_EMPTY
	je  .error

	mov rcx, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.size]

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x]
	cmp r8, rax
	jl  .next

	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	cmp r8, rax
	jge .next

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	cmp r9, rax
	jl  .next

	add rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	cmp r9, rax
	jge .next

	clc

	mov qword [rsp], rsi

	jmp .end

.next:
	add rsi, rcx

	jmp .loop

.error:
	stc

.end:
	pop rsi
	pop r9
	pop r8
	pop rcx
	pop rax

	ret
