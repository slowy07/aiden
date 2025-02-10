service_render_object_by_id:
	push rcx
	push rsi

	cmp qword [service_render_object_list_records], STATIC_EMPTY
	je  .error

	mov rcx, qword [service_render_object_list_records]

	mov rsi, qword [service_render_object_list_address]

.loop:
	cmp qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rbx
	je  .found

	add rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

	dec rcx
	jnz .loop

.error:
	stc

	jmp .end

.found:
	mov qword [rsp], rsi

.end:
	pop rsi
	pop rcx

	ret

macro_debug "service_render_object_by_id"

service_render_object_insert:
	push rax
	push rdx
	push rdi
	push rcx
	push rsi

	cmp qword [service_render_object_list_records_free], STATIC_EMPTY
	je  .end

	mov rdi, qword [service_render_object_list_address]

	mov rax, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE
	mul qword [service_render_object_list_records]

	add rdi, rax

	mov qword [rsp], rdi

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_arbiter
	jz   .insert

	cmp byte [service_render_object_arbiter_semaphore], STATIC_FALSE
	jne .insert

	mov byte [service_render_object_arbiter_semaphore], STATIC_TRUE

.insert:
	push rsi
	push rdi

	mov rcx, (SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE) >> STATIC_DIVIDE_BY_QWORD_shift
	rep movsq

	inc qword [service_render_object_list_records]

	pop rdi
	pop rsi

	call kernel_task_active_pid
	mov  qword [rdi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid], rax

.end:
	pop rsi
	pop rcx
	pop rdi
	pop rdx
	pop rax

	ret

macro_debug "service_render_object_insert"

service_render_object:
	push rbx
	push rsi

	mov rbx, qword [service_render_object_list_records]

	mov rsi, qword [service_render_object_list_address]

.loop:
	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_visible
	jz   .next

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush
	jz   .next

	call service_render_zone_insert_by_object

	and qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], ~SERVICE_RENDER_OBJECT_FLAG_flush

	or qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

.next:
	add rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

	dec rbx
	jnz .loop

	call service_render_zone

.end:
	pop rsi
	pop rbx

	ret

macro_debug "service_render_object"

service_render_object_id_get:
	macro_lock service_render_object_id_semaphore, 0

	mov rcx, qword [service_render_object_id]

	inc qword [service_render_object_id]

	mov byte [service_render_object_id_semaphore], STATIC_FALSE

	ret

macro_debug "service_render_object_id_get"

service_render_object_find:
	push rax
	push rcx
	push rdx
	push rsi

	cmp qword [service_render_object_list_records], STATIC_EMPTY
	je  .error

	mov rcx, qword [service_render_object_list_records]

	mov rax, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE
	mul rcx

	mov rsi, qword [service_render_object_list_address]
	add rsi, rax

.next:
	sub rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_visible
	jz   .fail

	cmp r8, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	jl  .fail

	cmp r9, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]
	jl  .fail

	mov rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	add rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width]
	cmp r8, rax
	jge .fail

	mov rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]
	add rax, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.height]
	cmp r9, rax
	jge .fail

	mov qword [rsp], rsi

	clc

	jmp .end

.fail:
	dec rcx
	jnz .next

.error:
	stc

.end:
	pop rsi
	pop rdx
	pop rcx
	pop rax

	ret

macro_debug "service_render_object_find"

service_render_object_up:
	push rsi

	call service_render_object_insert

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid], rax

	xchg rsi, qword [rsp]

	call service_render_object_remove

	pop rsi

	sub rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

	ret

macro_debug "service_render_object_up"

service_render_object_remove:
	push rcx
	push rsi
	push rdi

	mov rdi, rsi
	add rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

.loop:
	mov rcx, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE
	rep movsb

	cmp qword [rdi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width], STATIC_EMPTY
	jne .loop

	dec qword [service_render_object_list_records]

	pop rdi
	pop rsi
	pop rcx

	ret

macro_debug "service_render_object_remove"

service_render_object_move:
	push rbx
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

	mov rbx, qword [service_render_object_list_address]

	mov rsi, qword [service_render_object_selected_pointer]

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_fixed_xy
	jnz  .end

	mov r8, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x]
	mov r9, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y]
	mov r10, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width]
	mov r11, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.height]

	mov r12, r8
	mov r13, r10

	test r14, r14
	jz   .y

	add qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.x], r14

	cmp r14, STATIC_EMPTY
	jl  .to_left

	mov r10, r14

	mov  rdi, rbx
	call service_render_zone_insert_by_register

	add r8, r14

.to_left:
	cmp r14, STATIC_EMPTY
	jnl .x_done

	neg r14

	add r8, r10
	sub r8, r14
	mov r10, r14

	mov  rdi, rbx
	call service_render_zone_insert_by_register

	mov r8, r12

.x_done:
	mov r10, r13
	sub r10, r14

.y:
	mov r12, r9
	mov r13, r11

	test r15, r15
	jz   .ready

	add qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.y], r15

	cmp r15, STATIC_EMPTY
	jl  .to_up

	mov r11, r15

	mov  rdi, rbx
	call service_render_zone_insert_by_register

	add r9, r15

.to_up:
	cmp r15, STATIC_EMPTY
	jnl .y_done

	neg r15

	add r9, r11
	sub r9, r15
	mov r11, r15

	mov  rdi, rbx
	call service_render_zone_insert_by_register

	mov r9, r12

.y_done:
	mov r11, r13
	sub r11, r15

.ready:
	or qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush

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
	pop rbx

	ret

macro_debug "service_render_object_move"

service_render_object_hide:
	push rbx
	push rcx
	push rsi

	mov rcx, qword [service_render_object_list_records]

	mov rsi, qword [service_render_object_list_address]

.loop:
	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_visible
	jz   .next

	test qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_fragile
	jz   .next

	and qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], ~SERVICE_RENDER_OBJECT_FLAG_visible

	call service_render_zone_insert_by_object

.next:
	add rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE

	dec rcx
	jnz .loop

.end:
	pop rsi
	pop rcx
	pop rbx

	ret

macro_debug "service_render_object_hide"

service_render_object_id_new:
	macro_lock service_render_object_id_semaphore, 0

	mov rcx, qword [service_render_object_id]

	inc qword [service_render_object_id]

	mov byte [service_render_object_id_semaphore], STATIC_FALSE

	ret

macro_debug "service_render_object_id"
