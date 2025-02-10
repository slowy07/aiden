%include "kernel/service/network/config.asm"
%include "kernel/service/network/data.asm"
%include "kernel/service/network/checksum.asm"
%include "kernel/service/network/arp.asm"
%include "kernel/service/network/icmp.asm"
%include "kernel/service/network/tcp.asm"

service_network:
	xor ebp, ebp

	call kernel_task_active
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid]

	mov qword [service_network_pid], rax

.loop:
	mov  rdi, service_network_ipc_message
	call kernel_ipc_receive
	jc   .loop

	mov rcx, qword [rdi + KERNEL_IPC_STRUCTURE.size]
	mov rsi, qword [rdi + KERNEL_IPC_STRUCTURE.pointer]

	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
	je  service_network_arp

	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
	je  service_network_ip

	xchg bx, bx

.end:
	test rsi, rsi
	jz   .loop

	mov  rdi, rsi
	call kernel_memory_release_page

	jmp .loop

macro_debug "service_network"

service_network_ip:
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP
	je  service_network_icmp

	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP
	je  service_network_tcp

.end:
	jmp service_network.end

macro_debug "service_network_ip"

service_network_transfer:
	push rbx
	push rcx
	push rsi

	mov  rbx, qword [service_tx_pid]
	test rbx, rbx
	jz   .error

	mov  rcx, rax
	mov  rsi, rdi
	call kernel_ipc_insert
	jnc  .end

.error:
	stc

.end:
	pop rsi
	pop rcx
	pop rbx

	ret
