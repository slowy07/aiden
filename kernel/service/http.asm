service_http:
	mov	cx,	80
	call kernel_network_tcp_port_assign
	jmp	$