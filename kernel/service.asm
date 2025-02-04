kernel_service:
  cmp al, KERNEL_SERVICE_PROCESS
  je .process

.end:

.process:
  jmp kernel_service.end
