AIDEN_GRAPHICS_MODE_INFO_BLOCK_SIZE_byte equ 0x1000

AIDEN_GRAPHICS_DEPTH_bit equ 32
AIDEN_GRAPHICS_MODE_clean equ 0x8000
AIDEN_GRAPHICS_MODE_linear equ 0x4000

struc         AIDEN_STRUCTURE_GRAPHICS_VGA_INFO_BLOCK
.vesa_signature resb 4
.vesa_version resb 2
.oem_string_ptr resb 4
.capabilities resb 4
.video_mode_ptr resb 4
.total_memory resb 2
.reserved     resb 236
endstruc

struc      AIDEN_STRUCTURE_GRAPHICS_MODE_INFO_BLOCK
.mode_attributes resb 2
.win_a_attributes resb 1
.win_b_attributes resb 1
.win_granularity resb 2
.win_size resb 2
.win_a_segment resb 2
.win_b_segment resb 2
.win_func_ptr resb 4
.bytes_per_scanline resb 2
.x_resolution resb 2
.y_resolution resb 2
.x_char_size resb 1
.y_char_size resb 1
.number_of_planes resb 1
.bits_per_pixel resb 1
.number_of_banks resb 1
.memory_model resb 1
.bank_size resb 1
.number_of_image_pages resb 1
.reserved0 resb 1
.red_mask_size resb 1
.red_field_position resb 1
.green_mask_size resb 1
.green_field_position resb 1
.blue_mask_size resb 1
.blue_field_position resb 1
.rsvd_mask_size resb 1
.direct_color_mode_info resb 2
.physical_base_address resb 4
.reserved1 resb 212
endstruc

aiden_graphics:
	call aiden_page_align_up

	mov dword [aiden_graphics_mode_info_block_address], edi

	mov ax, 0x4F00
	add edi, AIDEN_GRAPHICS_MODE_INFO_BLOCK_SIZE_byte
	int 0x10

	test ax, 0x4F00
	jnz  .error

	mov esi, dword [di + AIDEN_STRUCTURE_GRAPHICS_VGA_INFO_BLOCK.video_mode_ptr]

.loop:
	cmp word [esi], 0xFFFF
	je  .error

	mov ax, 0x4F01
	mov cx, word [esi]
	mov edi, dword [aiden_graphics_mode_info_block_address]
	int 0x10

	cmp word [di + AIDEN_STRUCTURE_GRAPHICS_MODE_INFO_BLOCK.x_resolution], SELECTED_VIDEO_WIDTH_pixel
	jne .next

	cmp word [di + AIDEN_STRUCTURE_GRAPHICS_MODE_INFO_BLOCK.y_resolution], SELECTED_VIDEO_HEIGHT_pixel
	jne .next

	cmp byte [di + AIDEN_STRUCTURE_GRAPHICS_MODE_INFO_BLOCK.bits_per_pixel], AIDEN_GRAPHICS_DEPTH_bit
	je  .found

.next:
	add esi, 0x02

	jmp .loop

.error:
	jmp $

.found:
	mov ax, 0x4F02
	mov bx, word [esi]
	or  bx, AIDEN_GRAPHICS_MODE_linear | AIDEN_GRAPHICS_MODE_clean
	int 0x10

	test ah, ah
	jnz  .error
