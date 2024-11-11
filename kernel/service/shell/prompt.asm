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

service_shell_prompt_clean:
  add rsi, rbx
  sub r8, rbx

  mov rcx, r8
  call library_string_trim
  mov r8, rcx

.error:
  ret

service_shell_prompt:
  mov r8, rcx

  cmp rbx, service_shell_command_clean_end - service_shell_command_clean
  jne .clean_omit

  mov ecx, ebx
  mov rdi, service_shell_command_clean
  call library_string_compare
  jc .clean_omit

  call kernel_video_drain
  mov qword [kernel_video_cursor], STATIC_EMPTY
  call kernel_video_cursor_set

  jmp .end

.clean_omit:
  cmp rbx, service_shell_command_ip_end - service_shell_command_ip
  jne .ip_omit

  mov ecx, ebx
  mov rdi, service_shell_command_ip
  call library_string_compare
  jc .ip_omit
  
  call service_shell_prompt_clean
  jc .ip_properties

  call library_string_word_next

  cmp ebx, service_shell_command_ip_set_end - service_shell_command_ip_set
  jne .ip_unknown
  
  mov ecx, ebx
  mov rdi, service_shell_command_ip_set
  call library_string_compare
  jc .ip_unknown

  call service_shell_prompt_clean
  jc .ip_set_error

  call library_string_word_next

  cmp rbx, rcx
  jne .ip_set_error

  mov dl, 4

  xor r8d, r8d

  mov rdi, rsi
  add rdi, rbx

.ip_set_loop:
  mov al, STATIC_ASCII_DOT
  call library_string_cut

  test rcx, rcx
  jz .ip_set_error

  call library_string_digits
  jc .ip_set_error

  call library_string_to_integer
  
  cmp rax, 255
  ja .ip_set_error

  shl r8d, STATIC_MOVE_AL_TO_HIGH_shift
  mov r8b, al

  inc rcx
  add rsi, rcx

  dec dl
  jnz .ip_set_loop

  dec rsi
  cmp rsi, rdi
  jne .ip_set_error

  bswap r8d
  mov dword [driver_nic_i82540em_address], r8d

  jmp .end

.ip_set_error:
  mov ecx, service_shell_string_error_ipv4_format_end - service_shell_string_error_ipv4_format
  mov rsi, service_shell_string_error_ipv4_format
  call kernel_video_string

  jmp .end

.ip_properties:
  mov eax, STATIC_ASCII_NEW_LINE
  mov cl, 1
  call kernel_video_char

  mov bl, STATIC_NUMBER_SYSTEM_decimal
  xor cl, cl
  mov dl, 4
  mov rsi, driver_nic_i82540em_ipv4_address

.ip_properties_loop:
  lodsb
  call kernel_video_number

  dec dl
  jz .end

  mov eax, STATIC_ASCII_DOT
  mov cl, 1
  call kernel_video_char

  jmp .ip_properties_loop

.ip_unknown:
  mov al, STATIC_ASCII_NEW_LINE
  mov ecx, 1
  call kernel_video_char

  mov ecx, ebx
  call kernel_video_string

  mov ecx, service_shell_command_unknown_end - service_shell_command_unknown
  mov rsi, service_shell_command_unknown
  call kernel_video_string

  jmp .end

.ip_omit:

.end:
  jmp service_shell
