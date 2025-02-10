%define SERVICE_HTTP_version "1"
%define SERVICE_HTTP_revision "0"

	%MACRO service_http_macro_foot 0
	db     "<hr />", STATIC_ASCII_NEW_LINE
	db     "Aiden Operating System v", KERNEL_version, ".", KERNEL_revision, " (HTTP Service v", SERVICE_HTTP_version, ".", SERVICE_HTTP_revision, ")"
	db     "<style>* { font: 12px/150% 'Courier New', 'DejaVu Sans Mono', Monospace, Verdana;color: #F5F5F5;} body { background-color: #282922;}</style>", STATIC_ASCII_NEW_LINE
	%ENDMACRO

service_http_ipc_message:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY

service_http:
	mov  cx, 80
	call service_network_tcp_port_assign
	jc   service_http

.loop:
	mov  rdi, service_http_ipc_message
	call kernel_ipc_receive
	jc   .loop

	mov rbx, qword [rdi + KERNEL_IPC_STRUCTURE.other]

	mov  ecx, service_http_get_root_end - service_http_get_root
	mov  rsi, qword [rdi + KERNEL_IPC_STRUCTURE.pointer]
	mov  rdi, service_http_get_root
	call include_string_compare
	jc   .no

	mov ecx, service_http_200_default_end - service_http_200_default
	mov rsi, service_http_200_default

	jmp .answer

.no:
	mov ecx, service_http_404_end - service_http_404
	mov rsi, service_http_404

.answer:
	call service_network_tcp_port_send

	jmp $

service_http_get_root  db "GET / "

service_http_get_root_end:

	service_http_200_default db "HTTP/1.0 200 OK", STATIC_ASCII_NEW_LINE
	db "Content-Type: text/html", STATIC_ASCII_NEW_LINE
	db STATIC_ASCII_NEW_LINE
	db '<span style="color: #F62670;">Hello,</span> <span style="color: #A9DE40;">World!</span>', STATIC_ASCII_NEW_LINE
	service_http_macro_foot

service_http_200_default_end:

	service_http_404  db "HTTP/1.0 404 Not Found", STATIC_ASCII_NEW_LINE
	db "Content-Type: text/html", STATIC_ASCII_NEW_LINE
	db STATIC_ASCII_NEW_LINE
	db "404 Content not found.", STATIC_ASCII_NEW_LINE
	service_http_macro_foot

service_http_404_end:
