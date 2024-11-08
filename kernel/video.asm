;MIT License
;
;Copyright (c) 2024 arfy slowy
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

KERNEL_VIDEO_BASE_address equ 0x000B8000
KERNEL_VIDEO_BASE_limit equ KERNEL_VIDEO_BASE_address + KERNEL_VIDEO_SIZE_byte
KERNEL_VIDEO_WIDTH_char equ 80
KERNEL_VIDEO_HEIGHT_char equ 25
KERNEL_VIDEO_CHAR_SIZE_byte equ 0x02
KERNEL_VIDEO_LINE_SIZE_byte equ KERNEL_VIDEO_WIDTH_char * KERNEL_VIDEO_CHAR_SIZE_byte
KERNEL_VIDEO_SIZE_byte equ KERNEL_VIDEO_LINE_SIZE_byte * KERNEL_VIDEO_HEIGHT_char

kernel_video_width dq KERNEL_VIDEO_WIDTH_char
kernel_video_heigh dq KERNEL_VIDEO_HEIGHT_char
kernel_video_char_size_byte dq KERNEL_VIDEO_CHAR_SIZE_byte
kernel_video_line_size_byte dq KERNEL_VIDEO_LINE_SIZE_byte
kernel_video_size_byte dq KERNEL_VIDEO_LINE_SIZE_byte * KERNEL_VIDEO_HEIGHT_char

kernel_video_pointer dq KERNEL_VIDEO_BASE_address
kernel_video_cursor dd STATIC_EMPTY ; x
                    dd STATIC_EMPTY ; y

kernel_video_dump:
  push rax
  push rcx
  push rdi

  mov rax, 0x0720072007200720
  mov ecx, (KERNEL_VIDE_LINE_SIZE_byte * KERNEL_VIDEO_WIDTH_char)
  mov rdi, KERNEL_VIDEO_BASE_address
  rep stosq

  pop rdi
  pop rcx
  pop rax

  ret

kernel_video_cursor_set:
  push rax
  push rcx
  push rdx

  mov eax, KERNEL_VIDEO_WIDTH_char
  mul dword [kernel_video_cursor + STATIC_DWORD_SIZE_byte]
  add eax, dword [kernel_video_cursor]

  mov cx, ax

  mov al, 0x0F
  mov dx, 0x03D4
  out dx, al

  inc dx
  mov al, cl
  out dx, al

  mov al, 0x0E
  dec dx
  out dx, al

  inc dx
  mov al, ch
  out dx, al

  pop rdx
  pop rcx
  pop rax
  
  ret

kernel_video_string:
  push rax
  push rbx
  push rcx
  push rdx
  push rsi
  push rdi

  mov rdi, qword [kernel_video_pointer]
  
  test rcx, rcx
  jc .end

  mov ah, 0x07

  mov ebx, dword [kernel_video_cursor]
  mov edx, dword [kernel_video_cursor + STATIC_DWORD_SIZE_byte]

.loop:
  lodsb
  test al, al
  jz .end

  push rcx

  mov ecx, 1
  call kernel_video_char

  pop rcx
  dec rcx
  jnz .loop

.end:
  mov qword [kernel_video_pointer], rdi

  mov dword [kernel_video_cursor], ebx
  mov dword [kernel_video_cursor + STATIC_DWORD_SIZE_byte], edx

  call kernel_video_cursor_set

  pop rdi
  pop rsi
  pop rdx
  pop rcx
  pop rbx
  pop rax

  ret

kernel_video_char:
  push rax
  push rcx

.loop:
  cmp al, STATIC_ASCII_NEW_LINE
  je .new_line

  cmp al, STATIC_ASCII_BACKSPACE
  je .backspace

  stosw
  inc ebx

  cmp ebx, KERNEL_VIDEO_WIDTH_char
  inc edx

  cmp edx, KERNEL_VIDEO_HEIGHT_char
  jb .continue

  dec edx

  call kernel_video_scroll

.continue:
  dec rcx
  jnz .loop

  pop rcx
  pop rax

  ret

.new_line:
  push rax
  mov eax, ebx
  shl eax, STATIC_MULTIPLE_BY_2_shift
  sub rdi, rax
  xor ebx, ebx

  inc edx
  add rdi, KERNEL_VIDEO_LINE_SIZE_byte

  pop rax
  jmp .continue

.backspace:
  xchg bx, bx
  test ebx, ebx
  jz .begin

  dec ebx
  jmp .clear

.begin:
  test edx, edx
  jz .clear

  dec edx
  mov ebx, KERNEL_VIDEO_WIDTH_char - 0x01

.clear:
  sub rdi, KERNEL_VIDEO_CHAR_SIZE_byte
  mov word [rdi], 0x0720
  jmp .continue

kernel_video_scroll:
