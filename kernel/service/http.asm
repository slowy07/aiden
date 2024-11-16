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

%define SERVICE_HTTP_version "1"
%define SERVICE_HTPP_revision "1"

%MACRO service_http_macro_foot 0
  db "<hr/>", STATIC_ASCII_NEW_LINE
  db "Aiden version", KERNEL_version, ".", KERNEL_revision, " (HTTP service version", SERVICE_HTTP_version, "." SERVICE_HTPP_revision, ")"
  db "<style>* { font: 12px/150% 'Courier New', 'DejaVu Sans Mono', Monospace, Verdana; color: #F5F5F5;} body { background-colro: #282922; }</style>", STATIC_ASCII_NEW_LINE
%ENDMACRO

service_http_ipc_message:
  times KERNEL_IPC_STRUCTURE_LIST.SIZE db STATIC_EMPTY

service_http:
  mov cx, 80
  call service_network_tcp_port_assign
  jc service_http

.loop:
  mov rdi, service_http_ipc_message
  call kernel_ipc_receive
  jc .loop

  mov rbx, qword [rdi + KERNEL_IPC_STRUCTURE_LIST.other]
  
  mov ecx, service_http_get_root_end - service_http_get_root
  mov rdi, service_http_get_root
  call library_string_compare
  jc .no

  mov ecx, service_http_200_default_end - service_http_200_default
  mov rsi, service_http_200_default

  jmp .answer

.no:
  mov ecx, service_http_404_end - service_http_404
  mov rsi, service_http_404

.answer:
  xchg bx, bx
  call service_network_tcp_port_send
  jmp $

service_http_get_root db "GET / "
service_http_get_root_end:

service_http_200_default db "HTTP/1.0 200 OK", STATIC_ASCII_NEW_LINE
                         db "Content-Type: text/html", STATIC_ASCII_NEW_LINE
                         db STATIC_ASCII_NEW_LINE
                         db '<span style="color: #f62670;">Wello,</span><span style="color: #A9DE40;">Aiden</span>', STATIC_ASCII_NEW_LINE
                         service_http_macro_foot
service_http_200_default_end:

service_http_404 db "HTTP/1.0 404 NOT FOUND", STATIC_ASCII_NEW_LINE
                 db "Content-Type: text/html", STATIC_ASCII_NEW_LINE
                 db STATIC_ASCII_NEW_LINE
                 db "404 Content not found", STATIC_ASCII_NEW_LINE
                 service_http_macro_foot
service_http_404_end:
