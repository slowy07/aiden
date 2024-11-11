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

service_shell_string_prompt_with_new_line db STATIC_ASCII_NEW_LINE
service_shell_string_prompt db STATIC_COLOR_ASCII_RED_LIGHT
service_shell_string_prompt_type db ">> "
service_shell_string_prompt_type_end db STATIC_COLOR_ASCII_DEFAULT

service_shell_cache:
  times SERVICE_SHELL_CACHE_SIZE_SIZE_byte db STATIC_EMPTY

service_shell_command_clean db "clean"
service_shell_command_clean_end:

service_shell_command_ip db "ip"
service_shell_command_ip_end:

service_shell_command_ip_set db "set"
service_shell_command_ip_set_end:

service_shell_command_unknown equ "?"
service_shell_command_unknown_end:

service_shell_string_error_ipv4_format db STATIC_ASCII_NEW_LINE, "wrong ipv4 address"
service_shell_string_error_ipv4_format_end:
