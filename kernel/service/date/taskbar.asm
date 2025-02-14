service_date_taskbar:
	;    Save register
	push rax
	push rbx
	push rdx
	push rdx
	push rsi
	push rdi
	;    Load the last modification time of the service render object list
	mov  rax, qword [service_render_object_list_modify_time]
	;    Compare it with the stored modification time of the taskbar window
	cmp  qword [service_date_window_taskbar_modify_time], rax
	je   .end; If they are equal, no update is needed, so exit

	mov qword [service_date_window_taskbar_modify_time], rax

	; Acquire a lock on the service render object semaphore to ensure thread safety
	macro_lock service_render_object_semaphore, 0

	;    Compute memory required for taskbar elements
	mov  eax, INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.SIZE + INCLUDE_UNIT_WINDOW_NAME_length
	mul  qword [service_render_object_list_records]; Multiply by the number of records
	push rax; Save the computed size on the stack

	;   Check if allocated space is sufficient
	cmp rax, qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.size]
	jbe .enough; If space is sufficient, skip allocation

	;    Allocate or Reallocate Memory for Taskbar Elements
	mov  rcx, qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.size]
	test rcx, rcx
	jz   .new; If zero, new allocation is needed

	;    If memory is already allocated, release it before reallocation
	call include_page_from_size
	mov  rdi, qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.address]
	call kernel_memory_release

.new:
	;    Allocate new memory for the taskbar elements
	mov  rcx, rax; Set required size
	call include_page_from_size
	call kernel_memory_alloc

	;   Store the new memory address in the taskbar element chain
	mov qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.address], rdi

.enough:
	;   Load the address of the taskbar element chain
	mov rdi, qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.address]

	; Compute Button Width for Taskbar Entries

	;   Load taskbar window width
	mov rax, qword [service_date_window_taskbar + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	;   Subtract the width occupied by the clock element
	sub rax, qword [service_date_window_taskbar.element_label_clock + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	;   Compute the number of visible taskbar entries (excluding fixed elements)
	mov rcx, qword [service_render_object_list_records]
	sub rcx, SERVICE_DATE_WINDOW_count; Exclude static taskbar elements
	xor edx, edx
	div rcx; Divide remaining space among dynamic elements

	mov rbx, rax; Store computed button width

	;   Begin Iteration Over Rendered Objects
	mov rax, qword [service_date_pid]; Load process ID
	xor edx, edx
	mov rsi, qword [service_render_object_list_address]; Load object list start address

.loop:
	;   Skip entries with empty flags
	cmp qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], STATIC_EMPTY
	je  .ready; Exit loop if empty entry is reached

	;   Skip entries belonging to the same process (already managed)
	cmp qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.pid], rax
	je  .next

	;    Add Taskbar Button for Process Entry
	push rsi
	push rdi

	;   Set element type to "button"
	mov dword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.type], INCLUDE_UNIT_ELEMENT_TYPE_button
	;   Set element size
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.size], INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.SIZE
	;   Set button position (X-coordinate)
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], rdx
	;   Set button position (Y-coordinate, default)
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], STATIC_EMPTY
	;   Set button width (computed earlier)
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width], rbx
	;   Set button height (taskbar height)
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height], SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel
	;   Set default event handler (empty for now)
	mov qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT.event], STATIC_EMPTY

	;     Retrieve object name length and store in button structure
	movzx ecx, byte [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.length]
	mov   byte [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.length], cl
	;     Update size to include the text length
	add   qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.size], rcx
	;     Copy object name into taskbar button text
	add   rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.name
	add   rdi, INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.string
	rep   movsb; Copy name string

	pop rdi
	pop rsi

	;   Move to the next taskbar entry
	add rdi, qword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT_BUTTON.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.size]
	add rdx, rbx; Update X-position

.next:
	;   Move to the next object in the render list
	add rsi, SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE
	jmp .loop; Continue iteration

.ready:
	;   Restore the saved taskbar element chain size
	pop qword [service_date_window_taskbar.element_chain_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.size]
	;   Mark the end of the element chain
	mov dword [rdi + INCLUDE_UNIT_STRUCTURE_ELEMENT.type], STATIC_EMPTY

	;   Reset the semaphore to indicate that the taskbar update is complete
	mov byte [service_render_object_semaphore], STATIC_FALSE

	;    Refresh Taskbar UI Elements
	mov  rsi, service_date_window_taskbar.element_chain_0
	mov  rdi, service_date_window_taskbar
	call include_unit_element_chain

	;   Trigger UI Update via System Interrupt
	mov al, SERVICE_RENDER_WINDOW_update
	mov rsi, service_date_window_taskbar
	int SERVICE_RENDER_IRQ

.end:
	;   Restore register
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret
