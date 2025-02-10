service_render_fill_insert_by_register:
	push rcx
	push rdi

	mov ecx, SERVICE_RENDER_FILL_LIST_limit

	mov rdi, qword [service_render_fill_list_address]

.loop:
	cmp qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.object], STATIC_EMPTY
	jne .next

	mov qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.x], r8
	mov qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.y], r9
	mov qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.width], r10
	mov qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.height], r11

	mov qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.object], rsi

	jmp .end

.next:
	add rdi, SERVICE_RENDER_STRUCTURE_FILL.SIZE

	dec rcx
	jnz .loop

	xchg bx, bx
	jmp  $

.end:
	pop rdi
	pop rcx

	ret

macro_debug "service_render_fill_insert_by_register"

service_render_fill_insert_by_object:
	push rax
	push rcx
	push rdi
	push rsi

	mov ecx, SERVICE_RENDER_FILL_LIST_limit

	mov rdi, qword [service_render_fill_list_address]

.loop:
	cmp qword [rdi + SERVICE_RENDER_STRUCTURE_FILL.object], STATIC_EMPTY
	jne .next

	movsq
	movsq
	movsq
	movsq

	mov rax, qword [rsp]
	mov qword [rdi], rax

	jmp .end

.next:
	add rdi, SERVICE_RENDER_STRUCTURE_FILL.SIZE

	dec rcx
	jnz .loop

	xchg bx, bx
	jmp  $

.end:
	pop rsi
	pop rdi
	pop rcx
	pop rax

	ret

macro_debug "service_render_fill_insert_by_object"

service_render_fill:
	push rax
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
	push r14
	push r15

	mov ecx, SERVICE_RENDER_FILL_LIST_limit

	mov rsi, qword [service_render_fill_list_address]

.loop:
	cmp qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.object], STATIC_EMPTY
	je  .next

	push rcx
	push rsi

	mov r8, qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	mov r9, qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.y]
	mov r10, qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.width]
	mov r11, qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.field + SERVICE_RENDER_STRUCTURE_FIELD.height]

	bt  r8, STATIC_QWORD_BIT_sign
	jnc .x_positive

	not r8
	inc r8
	sub r10, r8

	xor r8, r8

.x_positive:
	bt  r9, STATIC_QWORD_BIT_sign
	jnc .y_positive

	not r9
	inc r9
	sub r11, r9

	xor r9, r9

.y_positive:
	mov rax, r8
	add rax, r10
	cmp rax, qword [kernel_video_width_pixel]
	jb  .x_inside

	sub rax, qword [kernel_video_width_pixel]
	sub r10, rax

.x_inside:
	mov rax, r9
	add rax, r11
	cmp rax, qword [kernel_video_height_pixel]
	jb  .y_inside

	sub rax, qword [kernel_video_height_pixel]
	sub r11, rax

.y_inside:
	mov rsi, qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.object]

	mov r12, r10
	shl r12, KERNEL_VIDEO_DEPTH_shift
	mov r13, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width]
	shl r13, KERNEL_VIDEO_DEPTH_shift
	mov r14, qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width]
	shl r14, KERNEL_VIDEO_DEPTH_shift

	mov rdi, r8
	shl rdi, KERNEL_VIDEO_DEPTH_shift

	mov rax, r14
	mul r9

	add rdi, rax
	add rdi, qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.address]

	sub r8, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	js  .overflow
	sub r9, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]
	js  .overflow

	mov rax, r9
	mul r13

	shl r8, KERNEL_VIDEO_DEPTH_shift

	mov rsi, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address]
	add rsi, rax
	add rsi, r8

.row:
	mov rcx, r10

.print:
	cmp byte [rsi + 0x03], STATIC_MAX_unsigned
	je  .transparent_max

	movsd

	jmp .continue

.overflow:
	mov  rsi, qword [rsp]
	call service_render_zone_insert_by_object
	call service_render_zone

	jmp .leave

.transparent_max:
	add rsi, STATIC_DWORD_SIZE_byte
	add rdi, STATIC_DWORD_SIZE_byte

.continue:
	dec rcx
	jnz .print

	sub rdi, r12
	add rdi, r14

	sub rsi, r12
	add rsi, r13

	dec r11
	jnz .row

	or qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

.leave:
	pop rsi
	pop rcx

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_FILL.object], STATIC_EMPTY

.next:
	add rsi, SERVICE_RENDER_STRUCTURE_FILL.SIZE

	dec rcx
	jnz .loop

.end:
	pop r15
	pop r14
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
	pop rax

	ret

macro_debug "service_render_fill"
