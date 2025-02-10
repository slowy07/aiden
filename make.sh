#!/usr/bin/sh

WIDTH=640
HEIGHT=480

	nasm -f bin software/init.asm		-o build/init
	nasm -f bin software/shell.asm		-o build/shell
	nasm -f bin software/hello.asm		-o build/hello
	nasm -f bin software/free.asm		-o build/free
	nasm -f bin software/console.asm	-o build/console

	nasm -f bin kernel/init/boot.asm	-o build/boot
	nasm -f bin kernel/kernel.asm		-o build/kernel \
		-dMULTIBOOT_VIDEO_WIDTH_pixel=${WIDTH} \
		-dMULTIBOOT_VIDEO_HEIGHT_pixel=${HEIGHT}
	nasm -f bin aiden/aiden.asm		-o build/disk.raw \
		-dMULTIBOOT_VIDEO_WIDTH_pixel=${WIDTH} \
		-dMULTIBOOT_VIDEO_HEIGHT_pixel=${HEIGHT}

