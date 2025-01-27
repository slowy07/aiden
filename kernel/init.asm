%include "kernel/init/long_mode.asm"
%include "kernel/init/panic.asm"
%include "kernel/init/data.asm"
%include "kernel/init/multiboot.asm"

	[BITS 64]

	%include "kernel/init/apic.asm"

kernel_init_long_mode:
	%include "kernel/init/video.asm"
	%include "kernel/init/memory.asm"
	%include "kernel/init/acpi.asm"
	%include "kernel/init/page.asm"
	%include "kernel/init/gdt.asm"
	%include "kernel/init/idt.asm"
	%include "kernel/init/rtc.asm"
	%include "kernel/init/task.asm"

	call kernel_init_apic

	mov dword [rsi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz

	mov dword [rsi + KERNEL_APIC_EOI_register], STATIC_EMPTY
