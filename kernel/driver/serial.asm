; Serial Port Base Addresses:
;   COM1: 0x03F8
;   COM2: 0x02F8
;
; Registers:
;   - Data Register (offset 0) → Holds data to be sent/received
;   - Interrupt Enable Register (offset 1) → Controls interrupts
;   - Interrupt Identification / FIFO Control Register (offset 2) → FIFO buffer
;   - Line Control Register (offset 3) → Configures baud rate, parity, stop bits
;   - Modem Control Register (offset 4) → Controls modem status
;   - Line Status Register (offset 5) → Indicates transmission status
;   - Modem Status Register (offset 6) → Monitors modem control lines
;   - Scratch Register (offset 7) → General-purpose storage

; Define Base Addresses for Serial Ports
DRIVER_SERIAL_PORT_COM1 equ 0x03F8
DRIVER_SERIAL_PORT_COM2 equ 0x02F8

; Define the structure for Serial Port Registers
struc    DRIVER_SERIAL_STRUCTURE_REGISTERS
.data_or_divisor_low   resb 1 ; Offset 0 - Data Register / Divisor Latch Low
.interrupt_enable_or_divisor_high resb 1 ; Offset 1 - Interrupt Enable / Divisor Latch High
.interrupt_identification_or_fifo resb 1 ; Offset 2 - Interrupt ID / FIFO Control
.line_control_or_dlab resb 1 ; Offset 3 - Line Control / DLAB
.modem_control resb 1 ; Offset 4 - Modem Control
.line_status resb 1 ; Offset 5 - Line Status
.modem_status resb 1 ; Offset 6 - Modem Status
.scratch resb 1 ; Offset 7 - Scratch Register
endstruc

; Configures COM1 for communication.
; - Disables interrupts
; - Enables DLAB to set baud rate
; - Configures data format (8 bits, no parity, 1 stop bit)
; - Enables FIFO buffer
driver_serial:
  ; Save register
	push rax
	push rdx

  ; Disable Serial Port Interrupts
	mov al, 0x00
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_enable_or_divisor_high
	out dx, al

  ; Enable DLAB (Divisor Latch Access Bit) to set baud rate
	mov al, 0x80 ; Set DLAB=1 (enables baud rate divisor setting)
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_control_or_dlab
	out dx, al

  ; Set Baud Rate to 38400 (Divisor = 3)
	mov al, 0x03 ; Divisor Latch Low Byte (3 → 38400 baud rate)
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.data_or_divisor_low
	out dx, al
	mov al, 0x00 ; Divisor Latch High Byte (0)
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_enable_or_divisor_high
	out dx, al

  ; Configure Line Control Register (8N1 Format)
	mov al, 0x03 ; 8 data bits, no parity, 1 stop bit (8N1)
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_control_or_dlab
	out dx, al

  ; Enable FIFO, Clear Buffers, Set 14-Byte Threshold
	mov al, 0xC7 ; Enable FIFO, clear TX/RX, set 14-byte threshold
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_identification_or_fifo
	out dx, al

  ; Restore Registers
	pop rdx
	pop rax

	ret

; Sends a null-terminated string over the serial port (COM1).
; - Loops through each character in RSI
; - Calls driver_serial_ready to check if the port is ready
; - Sends character when ready
;
; Parameters:
;   RSI - Pointer to null-terminated string
driver_serial_send:
  ; Save register
	push rax
	push rdx
	push rsi

  ; Set up Data Register Address
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.data_or_divisor_low

.loop:
  lodsb ; Load next byte from RSI into AL
  jz .end ; If AL == 0 (null terminator), exit
  ; Wait for the port to be ready
	call driver_serial_ready
  ; Send character to serial port
	out dx, al
  ; Repeat for next character
	jmp .loop

.end:
  ; Restore registers
	pop rsi
	pop rdx
	pop rax

	ret

; Waits until the serial port is ready to transmit data.
; - Reads Line Status Register
; - Checks Transmitter Holding Register Empty (THRE) and Transmitter Empty (TEMT)
;
; Output:
;   Returns when the port is ready for the next byte.
driver_serial_ready:
  ; Save register
	push rax
	push rdx

  ; Set up Line Status Register Address
	mov dx, DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_status

.loop:
	in al, dx ; Read Line Status Register

	test al, 01100000b ; Check THRE (bit 5) and TEMT (bit 6)
	jz   .loop ; If not ready, keep checking

  ; Restore register
	pop rdx
	pop rax

	ret
