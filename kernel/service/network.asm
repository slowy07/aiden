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

SERVICE_NETWORK_MAC_mask equ 0x0000FFFFFFFFFFFF
SERVICE_NETWORK_PORT_SIZE_page equ 0x01
SERVICE_NETWORK_PORT_FLAG_empty equ 000000001b
SERVICE_NETWORK_PORT_FLAG_received equ 000000010b
SERVICE_NETWORK_PORT_FLAG_send equ 000000100b
SERVICE_NETWORK_PORT_FLAG_BIT_empty equ 0
SERVICE_NETWORK_PORT_FLAG_BIT_received equ 1
SERVICE_NETWORK_PORT_FLAG_BIT_send equ 2

SERVICE_NETWORK_STACK_SIZE_page equ 0x01
SERVICE_NETWORK_STACK_FLAG_busy equ 10000000b
SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp equ 0x0608
SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip equ 0x0008
SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet equ 0x0100
SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4 equ 0x0008
SERVICE_NETWORK_FRAME_ARP_HAL_mac equ 0x06
SERVICE_NETWORK_FRAME_ARP_PAL_ipv4 equ 0x04
SERVICE_NETWORK_FRAME_ARP_OPCODE_request 0x0100
SERVICE_NETWORK_FRAME_ARP_OPCODE_answer equ 0x0200
SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_default equ 0x05
SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask equ 0x0F
SERVICE_NETWORK_FRAME_IP_VERSION_4 equ 0x4a
SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP equ 0x01
SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP equ 0x06
SERVICE_NETWORK_FRAME_IP_PROTOCOL_UDP equ 0x11
SERVICE_NETWORK_FRAME_IP_TTL_default equ 0x40
SERVICE_NETWORK_FRAME_IP_F_AND_F_do_not_fragment equ 0x0040

SERVICE_NETWORK_FRAME_ICMP_TYPE_REQUEST equ 0x08
SERVICE_NETWORK_FRAME_ICMP_TYPE_REPLY equ 0x00

SERVICE_NETWORK_FRAME_TCP_HEADER_LENGTH_default 0x50
SERVICE_NETWORK_FRAME_TCP_FLAGS_fin equ 0000000000000001b
SERVICE_NETWORK_FRAME_TCP_FLAGS_syn equ 0000000000000010b
SERVICE_NETWORK_FRAME_TCP_FLAGS_rst equ 0000000000000100b
SERVICE_NETWORK_FRAME_TCP_FLAGS_psh equ 0000000000001000b
SERVICE_NETWORK_FRAME_TCP_FLAGS_ack equ 0000000000010000b
SERVICE_NETWORK_FRAME_TCP_FLAGS_urg equ 0000000000100000b
SERVICE_NETWORK_FRAME_TCP_FLAGS_bsy equ 0000100000000000b
SERVICE_NETWORK_FRAME_TCP_FLAGS_bsy_bit equ 11
SERVICE_NETWORK_FRAME_TCP_OPTION_MSS_default equ 0xB4050402
SERVICE_NETWORK_FRAME_TCP_OPTION_KIND_mss equ 0x02
SERVICE_NETWORK_FRAME_TCP_PROTOCOL_default equ 0x06
SERVICE_NETWORK_FRAME_TCP_WINDOW_SIZE_default equ 0x05B4

struc SERVICE_NETWORK_STRUCTURE_MAC
  .0 resb 1
  .1 resb 1
  .2 resb 1
  .3 resb 1
  .4 resb 1
  .5 resb 1
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET
  .target resb 0x06
  .source resb 0x06
  .type resb 0x02
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_ARP
  .htype resb 0x02
  .ptype resb 0x02
  .hal resb 0x01
  .opcode resb 0x01
  .source_mac resb 0x06
  .source_ip resb 0x04
  .target_mac resb 0x06
  .target_ip resb 0x04
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_IP
  .version_and_ihl resb 0x01
  .dscp_and_ecn resb 0x01
  .total_length resb 0x02
  .identification resb 0x02
  .f_and_f resb 0x02
  .ttl resb 0x01
  .protocol resb 0x01
  .checksum resb 0x02
  .source_address resb 0x04
  .destination_address resb 0x04
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_ICMP
  .type resb 0x01
  .code resb 0x01
  .checksum resb 0x02
  .reserved resb 0x04
  .data resb 0x20
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_UDP
  .port_source resb 0x02
  .port_target resb 0x02
  .length resb 0x02
  .checksum resb 0x02
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_TCP
  .port_source resb 0x02
  .port_target resb 0x02
  .sequence resb 0x04
  .acknowledgement resb 0x04
  .header_length resb 0x01
  .flags resb 0x01
  .window_size resb 0x02
  .checksum_and_urgent_pointer:
  .checksum resb 0x02
  .urgent_pointer resb 0x02
  .SIZE:
  .options:
endstruc

struc SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER
  .source_ipv4 resb 4
  .target_ipv4 resb 4
  .reserved resb 1
  .protocol resb 1
  .segment_length resb 2
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_TCP_STACK
  .source_mac resb 8
  .source_ipv4 resb 4
  .source_sequence resb 4
  .host_sequence resb 4
  .request_acknowledgement resb 4
  .window_size resb 2
  .source_port resb 2
  .host_port resb 2
  .status resb 2
  .flags resb 2
  .flags_request resb 2
  .identification resb 2
  .SIZE:
endstruc

struc SERVICE_NETWORK_STRUCTURE_PORT
  .pid resb 8
  .SIZE:
endstruc

service_network_pid dq STATIC_EMPTY
service_network_rx_count dq STATIC_EMPTY
service_network_port_semaphore db STATIC_FALSE
service_network_port_table dq STATIC_EMPTY
service_network_stack_address dq STATIC_EMPTY
service_network_ipc_message:
  times KERNEL_IPC_STRUCTURE_LIST.SIZE db STATIC_EMPTY

service_network:
  xor ebp, ebp
  
  call kernel_task_active
  mov rax, qword [rdi + KERNEL_STRUCTURE_TASK.pid]
  mov qword [service_network_pid], rax

.loop:
  mov rdi, service_network_ipc_message
  call kernel_ipc_receive
  jc .loop

  mov rcx, qword [rdi + KERNEL_IPC_STRUCTURE_LIST.size]
  mov rsi, qword [rsi + KERNEL_IPC_STRUCTURE_LIST.pointer]

  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
  je service_network_arp

  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
  je service_network_ip

  xchg bx, bx

.end:
  test rsi, rsi
  jz .loop

  mov rdi, rsi
  call kernel_memory_release_page
  jmp .loop

  macro_debug "service_network"

service_network_transfer:
  push rbx
  push rcx
  push rsi

  mov rbx, qword [service_tx_pid]
  test rbx, rbx
  jz .error

  mov rcx, rax
  mov rsi, rdi
  call kernel_ipc_insert
  jnc .end

.error:
  stc

.end:
  pop rsi
  pop rcx
  pop rbx

  ret

service_network_tcp_port_send:
  push rax
  push rbx
  push rcx
  push rsi
  push rdi

  call kenrel_memory_alloc_page
  jc .end

  push rcx
  push rdi

  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
  rep movsb

  pop rdi
  pop rcx

  inc dword [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence]
  mov byte [rbx + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  add rcx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + 0x01
  mov rsi, rbx
  mov bl, SERVICE_NETWORK_FRAME_TCP_HEADER_LENGTH_default
  call service_network_tcp_wrap

  mov rax, rcx
  add rax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
  call service_network_transfer

.end:
  pop rdi
  pop rsi
  pop rcx
  pop rbx
  pop rax

  ret

service_network_ip:
  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP
  je service_network_icmp

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP
  je service_network_tcp

.end:
  jmp service_network.end
  macro_debug "service_network_ip"

service_network_tcp:
  push rax
  push rax
  push rdx

  movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]

  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  
  cmp ax, 512
  jnb .end

  mov ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
  mul ecx
  add rax, qword [service_network_port_table]
  cmp qword [rax], STATIC_EMPTY
  je .end

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_sync
  je service_network_tcp_syn

  call service_network_tcp_find
  jc .end

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
  je service_network_tcp_ack

  test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_fin
  jnz service_network_tcp_fin

  test byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_psh | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

.end:
  pop rdx
  pop rcx
  pop rax

  jmp service_network.end

  macro "service_network_tcp"

service_network_tcp_psh_ack:
  push rax
  push rbx
  push rcx
  push rdx
  push rdi
  push rsi

  movzx eax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov ecx, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
  mul ecx

  movzx ecx, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.total_length]
  rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift
  sub cx, bx

  push rcx

  movzx edx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.header_length]
  shr dl, STATIC_MOVE_AL_HALF_TO_HIGH_shift
  shl dx, STATIC_MULTIPLE_BY_4_shift
  mov rdi, rsi

  add rsi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
  add rsi, rbx
  add rsi, rdx

  rep movsb
  
  mov rcx, KERNE_PAGE_SIZE_byte
  sub rcx, qword [rsp]
  rep stosb

  mov rbx, qword [service_network_port_table]
  mov rbx, qword [rbx + rax]

  xor ecx, ecx
  mov rsi, rsp
  call kernel_ipc_insert

  add rsp, STATIC_QWORD_SIZE_byte

  mov qword [rsp], STATIC_EMPTY

.end:
  pop rsi
  pop rdi
  pop rdx
  pop rcx
  pop rbx
  pop rax

  jmp service_network_tcp.end

  macro_debug "service_network_tcp_psh_ack"

service_network_tcp_fin:
  push rax
  push rbx
  push rcx
  push rsi
  push rdi

  xchg rsi, rdi
  and byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  mov eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
  bswap eax
  inc eax
  mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence], eax

  inc eax
  mov dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement], eax

  mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack | SERVICE_NETWORK_FRAME_TCP_FLAGS_fin

  mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  mov word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  call kernel_memory_alloc_page
  jc .error

  mov bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
  call service_network_tcp_wrap

  mov ax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
  call service_network_transfer
  jmp .end

.error:
  mov byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], STATIC_EMPTY

.end:
  pop rdi
  pop rsi
  pop rcx
  pop rbx
  pop rax

  jmp service_network_tcp.end

  macro_debug "service_network_tcp_fin"

service_network_tcp_stack:
  push rsi
  push rdi

  test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
  jz .end

  and word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], ~SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  test word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_TCP_FLAGS_fin | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
  jz .end

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], STATIC_EMPTY

.end:
  pop rdi
  pop rsi

  jmp service_network_tcp.end

  macro_debug "service_network_tcp_ack"

service_network_tcp_find:
  push rax
  push rcx
  push rbx
  push rdi

  movzx ebx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
  and bl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
  shl bl, STATIC_MULTIPLE_BY_4_shift

  mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
  mov rdi, qword [service_network_stack_address]
  
.loop:
  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
  rol rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
  mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source + SERVICE_NETWORK_STRUCTURE_MAC.4]
  ror rax, STATIC_REPLACE_EAX_WITH_HIGH_shift
  cmp qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rax
  jne .next

  mov eax, dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
  cmp dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWRK_STRUCTUER_FRAME_IP.source_address], eax
  jne .next

  mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port]
  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.size + rbx  + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target], ax
  jne .next

  mov ax, word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port]
  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + rbx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source], ax
  je .found

.next:
  add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE

  dec rcx
  jnz .loop

  stc

.found:
  mov qword [rsp + STATIC_QWORD_SIZE_byte], rbx
  mov qword [rsp], rdi

.end:
  pop rdi
  pop rbx
  pop rcx
  pop rax

  ret

  macro_debug "service_networ_tcp_find"

service_network_tcp_syn:
  push rax
  push rbx
  push rcx
  push rsi
  push rdi

  mov rcx, (SERVICE_NETWORK_STACK_SIZE_page << KERNEL_PAGE_SIZE_shift) / SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
  mov rdi, qword [service_network_stack_address]

.search:
  lock bts word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], SERVICE_NETWORK_STACK_FLAG_busy
  jnc .found
  add rdi, SERVICE_NETWORK_STRUCTURE_TCP_STACK.SIZE
  dec rcx
  jnz .search

  jmp .end

.found:
  movzx ecx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
  and cl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
  shl cl, STATIC_MULTIPLE_BY_4_shift
  
  add ecx, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE

  mov ax, word [si + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target]
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port], ax

  mov ax, word [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source]
  mov word [rdi + SERVICE_NETWOKR_STRUCTURE_TCP_STACK.source_port], ax

  mov eax, dword [rsi + rcx + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence]
  bswap eax
  inc eax
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence], eax

  mov rcx, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
  shl rcx, STATIC_MOVE_AX_TO_HIGH_shift
  shr rcx, STATIC_MOVE_HIGH_TO_AX_shift
  mov qword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac], rcx

  mov ecx, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4], ecx

  mov	word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.request_acknowledgement],	STATIC_EMPTY + 0x01

	mov	dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence],	STATIC_EMPTY

	mov	word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.window_size],	SERVICE_NETWORK_FRAME_TCP_WINDOW_SIZE_default

  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags], SERVICE_NETWORK_FRAME_TCP_FLAGS_syn | SERVICE_NETWORK_FRAME_TCP_FLAGS_ack
  
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags_request], SERVICE_NETWORK_FRAME_TCP_FLAGS_ack

  mov rsi, rdi

  call kernel_memory_alloc_page
  jc .error

  mov bl, (SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE >> STATIC_DIVIDE_BY_4_shift) << STATIC_MOVE_AL_HALF_TO_HIGH_shift
  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE
  call service_network_tcp_wrap

  mov ax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.SIZE + STATIC_DWORD_SIZE_byte
  call service_network_transfer

  jmp .end

.error:
  mov byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.status], STATIC_EMPTY

.end:
  pop rdi
  pop rsi
  pop rcx
  pop rbx
  pop rax

  jmp service_network_tcp.end

 macro_debug "service_network_tcp_syn"

service_network_tcp_wrap:
  push rax
  push rbx
  push rcx
  push rdi

  mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_port]
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_source], ax
  mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_port]
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.port_target], ax

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.host_sequence]
  bswap eax
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.sequence], eax

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_sequence]
  bswap eax
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.acknowledgement], eax

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.header_length], bl

  mov al, byte [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.flags]
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.flags], al

  mov ax, word [rsi + SERVICE_NETWOKR_STRUCTURE_TCP_STACK.window_size]
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.window_size], ax

  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP.checksum_and_urgent_pointer], STATIC_EMPTY

  call service_network_tcp_pseudo_header

  shr ecx, STATIC_DIVIDE_BY_2_shift
  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
  call service_network_checksum
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov word [rdi + SERVICE_NETWRK_STRUCTURE_FRAME_TCP.checksum], al

  mov rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_mac]
  mov bl, SERVICE_NETWORK_FRAME_IP_PROTOCOL_TCP
  shl ecx, STATIC_MULTIPLE_BY_2_shift
  sbu rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
  call service_network_ip_wrap

  pop rdi
  pop rcx
  pop rbx
  pop rax

  ret

  macro_debug "service_network_tcp_wrap"

service_network_ip_wrap:
  push rcx
  push rax

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl], SERVICE_NETWORK_FRAME_IP_VERSION_4 | SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_default

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.dscp_and_ecn], STATIC_EMPTY

  add cx, SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE
  rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.length], cx

  inc word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.identification]
  mov ax, word [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.identification]
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.identification], ax

  mov word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.f_and_f], SERVICE_NETWORK_FRAME_IP_F_AND_F_do_not_fragment

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.tll], SERVICE_NETWORK_FRAME_IP_TTL_default

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol], bl

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], STATIC_EMPTY

  mov eax, dword [driver_nic_i82540em_ipv4_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address], eax

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.destination_address], eax

  xor eax, eax
  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE >> STATIC_DIVIDE_BY_2_shift
  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
  call service_network_checksum
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  sub rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], ax

  pop rax
  mov cx, SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
  call service_network_ethernet_wrap

  pop rcx
  ret
  macro_debug "service_network_ip_wrap"

service_network_tcp_pseudo_header:
  push rcx
  push rdi

  mov eax, dword [driver_nic_i82540em_ipv4_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.source_ipv4], eax

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_TCP_STACK.source_ipv4]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.target_ipv4], ea
  
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.reserved], STATIC_EMPTY

  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.protocol], SERVICE_NETWORK_FRAME_TCP_PROTOCOL_default

  rol cx, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.segment_length], cx

  xor eax, eax
  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE >> STATIC_DIVIDE_BY_2_shift
  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_TCP_PSEUDO_HEADER.SIZE
  call service_network_checksum_part
  
  pop rdi
  pop rcx
  ret

  macro_debug "service_network_tcp_pseudo_header"

service_network_tcp_port_assign:
  push rax
  push rcx
  push rdx
  push rdi

  macro_close service_network_port_semaphore, 0

  cmp cx, 512
  jnb .error

  mov eax, SERVICE_NETWORK_STRUCTURE_PORT.SIZE
  and ecx, STATIC_WORD_mask
  mul ecx

  call kernel_task_active
  mov rcx, qword [rdi + KERNEL_STRUCTURE_TASK.pid]

  mov rdi, qword [service_network_port_table]
  
  cmp qword [rdi + rcx + SERVICE_NETWORK_STRUCTURE_PORT.pid], STATIC_EMPTY
  jne .error

  mov qword [rdi + rax + SERVICE_NETWORK_STRUCTURE_PORT.pid], rcx
  jmp .end

.error:
  stc

.end:
  mov byte [service_network_port_semaphore], STATIC_FALSE
  pop rdi
  pop rdx
  pop rcx
  pop rax
  ret
  macro_debug "service_network_tcp_port_assign"

service_network_arp:
  push rax

  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.htype], SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet
  jne .omit

  cmp word [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.ptye], SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4
  jne .omit

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.hal], SERVICE_NETWORK_FRAME_ARP_HAL_mac
  jne .omit

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.pal], SERVICE_NETWORK_FRAME_ARP_PAL_ipv4
  jne .omit

  mov eax, dword [driver_nic_i82540em_ipv4_address]
  cmp eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_ip]
  jne .omit

  push rdi

  call kernel_memory_alloc_page
  jc .error

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.htype], SERVICE_NETWORK_FRAME_ARP_HTYPE_ethernet
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.ptye], SERVICE_NETWORK_FRAME_ARP_PTYPE_ipv4
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.hal], SERVICE_NETWORK_FRAME_ARP_HAL_mac
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.pal], SERVICE_NETWORK_FRAME_ARP_PAL_ipv4
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.opcode], SERVICE_NETWORK_FRAME_ARP_OPCODE_answer

  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_ip], eax

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_ip]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_ip], eax

  mov rax, qword [driver_nic_i82540em_ipv4_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source], eax

  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac], eax
  shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source + SERVICE_NETWORK_STRUCTURE_MAC.4], ax
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac + SERVICE_NETWORK_STRUCTURE_MAC.4], ax

  mov rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_mac], eax
  shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.target_mac + SERVICE_NETWORK_STRUCTURE_MAC.4], eax
  
  mov rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.source_mac]
  mov cx, SERVICE_NETWORK_FRAME_ETHERNET_TYPE_arp
  call service_network_ethernet_wrap
  
  mov eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ARP.SIZE
  call service_network_transfer

.error:
  pop rdi

.omit:
  pop rax
  jmp service_network.end
  macro_debug "service_network_arp"

service_network_icmp:
  push rax
  push rbx
  push rcx
  push rsi
  push rdi

  cmp byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.type], SERVICE_NETWORK_FRAME_ICMP_TYPE_REQUEST
  jne .end

  movzx ebx, byte [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl]
  and bl, SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_mask
  shl bl, STATIC_MULTIPLE_BY_4_shift

  call kernel_memory_alloc_page
  jc .end

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.version_and_ihl], SERVICE_NETWORK_FRAME_IP_HEADER_LENGTH_default | SERVICE_NETWORK_FRAME_IP_VERSION_4
  mov byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.total_length], (SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE >> STATIC_REPLACE_AL_WITH_HIGH_shift) | (SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE << STATIC_REPLACE_AL_WITH_HIGH_shift)
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.identification], STATIC_EMPTY
  mov	word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.f_and_f],	STATIC_EMPTY
	mov	byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.ttl],	SERVICE_NETWORK_FRAME_IP_TTL_default
	mov	byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.protocol],	SERVICE_NETWORK_FRAME_IP_PROTOCOL_ICMP
	mov	word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.type],	SERVICE_NETWORK_FRAME_ICMP_TYPE_REPLY
	mov	byte [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.code],	STATIC_EMPTY
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.reserved], STATIC_EMPTY

  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.reserved]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.reserved], eax

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.checksum], STATIC_EMPTY

  push rsi
  push rdi

  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE - SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.data
  add rsi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.data
  add rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.data
  rep movsb

  pop rdi
  pop rsi

  xor eax, eax
  mov ecx, SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE >> STATIC_DIVIDE_BY_2_shift
  call service_network_checksum

  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.checksum], ax

  sub rdi, SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE

  mov eax, dword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_IP.destination_address], eax

  mov eax, dword [driver_nic_i82540em_ipv4_address]
  mov dword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_IP.source_address], eax

  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], STATIC_EMPTY

  xor eax, eax
  mov ecx, (SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE) >> STATIC_DIVIDE_BY_2_shift
  call service_network_checksum
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_IP.checksum], ax

  sub rdi, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE
  mov rax, qword [rsi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source]
  mov cx, SERVICE_NETWORK_FRAME_ETHERNET_TYPE_ip
  call service_network_ethernet_wrap

  mov eax, SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_IP.SIZE + SERVICE_NETWORK_STRUCTURE_FRAME_ICMP.SIZE
  call service_network_transfer
  
.end:
  pop rdi
  pop rsi
  pop rcx
  pop rbx
  pop rax

  jmp service_network_ip.end

  macro_debug "service_network_icmp"

service_network_ethernet_wrap:
  push rax
  mov qword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.target], rax

  mov rax, qword [driver_nic_i82540em_mac_address]
  mov qword [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.source], rax
  mov word [rdi + SERVICE_NETWORK_STRUCTURE_FRAME_ETHERNET.type], cx

  pop rax
  ret
  macro_debug "service_network_ethernet_wrap"

service_network_checksum:
  push rbx
  push rcx
  push rdi

  xor ebx, ebx
  xchg rbx, rax

.calculate:
  mov ax, word [rdi]
  rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift

  add rbx, rax
  add rdi, STATIC_WORD_SIZE_byte

  loop .calculate

  mov ax, bx
  shr ebx, STATIC_MOVE_HIGH_TO_AX_shift
  add rax, rbx

  not ax

  pop rdi
  pop rcx
  pop rbx
  ret

  macro_debug "service_network_checksum"

service_network_checksum_part:
  push rbx
  push rcx
  push rdi

  xor ebx, ebx

.calculate:
  mov bx, word [rdi]
  rol bx, STATIC_REPLACE_AL_WITH_HIGH_shift
  add rax, rbx

  add rdi, STATIC_WORD_SIZE_byte

  loop .calculate

  pop rdi
  pop rcx
  pop rbx

  ret

  macro_debug "service_network_checksum_part"
