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

  %include "kernel/service/shell/config.asm"

service_shell:
  mov ecx, service_shell_string_prompt_end - service_shell_string_prompt_with_new_line
  mov rsi, service_shell_string_prompt_with_new_line

  cmp dword [kernel_video_cursor.x], STATIC_EMPTY
  jne .prompt

  mov ecx, service_shell_string_prompt_end - service_shell_string_prompt
  mov rsi, service_shell_string_prompt

.prompt:
  call kernel_video_string

.restart:
  xor ebx, ebx
  mov ecx, SERVICE_SHELL_CACHE_SIZE_byte
  mov rsi, service_shell_cache

  call library_input
  jc service_shell

  call library_string_trim
  jc service_shell

  call library_string_word_next

  jmp service_shell_prompt

  %include "kernel/service/shell/data.asm"
  %include "kernel/service/shell/prompt.asm"
