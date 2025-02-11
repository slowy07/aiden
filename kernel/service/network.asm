%include "kernel/service/network/config.asm"
%include "kernel/service/network/data.asm"
%include "kernel/service/network/checksum.asm"
%include "kernel/service/network/arp.asm"
%include "kernel/service/network/icmp.asm"
%include "kernel/service/network/tcp.asm"

; Main network service loop
service_network:
	xor ebp, ebp ; Clear EBP register (stack base pointer)

	call kernel_task_active ; Check if the kernel task is active
	mov  rax, qword [rdi + KERNEL_TASK_STRUCTURE.pid] ; Get the PID fo the kernel task

	mov qword [service_network_pid], rax ; Store the PID in service_network_pid

.loop:
	mov  rdi, service_network_ipc_message ; Load IPC message buffer
	call kernel_ipc_receive ; Wait for IPC message
	jc   .loop ; If there is an error (carry flag set), retry

	mov rcx, qword [rdi + KERNEL_IPC_STRUCTURE.size] ; Load message size
	mov rsi, qword [rdi + KERNEL_IPC_STRUCTURE.pointer] ; Load message pointer

	; Check if ARP frame
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
	je  service_network_arp ; Jump if ARP

	; Check if IP frame
	cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
	je  service_network_ip ; Jump if IP

	xchg bx, bx ; Debug breakpoint (NOP equivalent)

.end:
	test rsi, rsi ; Check if message pointer is null
	jz   .loop ; If null, continue loop

	mov  rdi, rsi ; Load message pointer
	call kernel_memory_release_page ; Free memory

	jmp .loop ; Repeat main loop

macro_debug "service_network"

; Handles incoming IP frames
service_network_ip:
	; Check if ICMP
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP
	je  service_network_icmp ; Jump if ICMP

	; Check if TCP
	cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP
	je  service_network_tcp ; Jump if TCP

.end:
	jmp service_network.end ; Return to main loop

macro_debug "service_network_ip"

; Transfers packets between processes
service_network_transfer:
	; Save registers
	push rbx
	push rcx
	push rsi

	mov  rbx, qword [service_tx_pid] ; Load transmission service PID
	test rbx, rbx ; Check if PID is valid
	jz   .error ; If invalid, jump to error

	mov  rcx, rax ; Save RAX (return value)
	mov  rsi, rdi ; Save RDI (message pointer)
	call kernel_ipc_insert ; Send IPC message
	jnc  .end ; If success, skip error

.error:
	stc ; Set carry flag to indicate failure

.end:
	; Restore registers
	pop rsi
	pop rcx
	pop rbx

	ret ; Return from function
