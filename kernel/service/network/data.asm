service_network_pid dq STATIC_EMPTY ; Process ID associated with the service network

service_network_rx_count dq STATIC_EMPTY ; Received packet count
service_network_tx_count dq STATIC_EMPTY ; Transmitted packet count

service_network_port_semaphore db STATIC_FALSE ; Semaphore for controlling port access
service_network_port_table dq STATIC_EMPTY ; Table storing network port information

service_network_stack_address dq STATIC_EMPTY ; Stack address for network operations

; IPC Message Buffer
; This buffer is used for inter-process communication (IPC) within the kernel
service_network_ipc_message:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY