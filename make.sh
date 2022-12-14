#!/bin/bash

clear

rm -rf build && mkdir build > /dev/null 2>&1
rm -rf iso && mkdir iso > /dev/null 2>&1
LDFLAGS="-nostdlib -zmax-page-size=0x1000 -static -no-dynamic-linker"

nasm -f elf64 kernel/init.asm -o build/kernel.o
ld build/kernel.o -o build/kernel -T linker.kernel
gzip -fk build/kernel

lib=""
for shared in `(cd system && ls lib*)`; do lib="${lib} -l${shared:3:$(expr ${#shared} - 6)}"; done

if [ `ls software | wc -l` -ne 0 ]; then
	for software in `(cd software && ls *.asm)`; do
		name=`echo $software | cut -d '.' -f 1`
		nasm -f elf64 software/${name}.asm -o build/${name}.o || exit 1
		ld --as-needed -L./system build/${name}.o -o system/${name} ${lib} -T linker.software ${LDFLAGS}
	done
fi

rm -f build/*.o

cp gfx/* system

clang pkg.c -o pkg && ./pkg && gzip -fk build/system.pkg && mv build/system.pkg.gz build/system.gz

git submodule update --init

cp limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso/
cp build/{kernel.gz,system.gz} iso

xorriso -as mkisofs -b limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot limine-cd-efi.bin -efi-boot-part --efi-boot-image --protective-msdos-label iso -o build/aiden.iso > /dev/null 2>&1

(git submodule update --init && cd limine && make ) > /dev/null 2>&1
limine/limine-deploy build/aiden.iso > /dev/null 2>&1

echo -e "\nbuild:"
ls -lah build/ | tail -n +4 | awk '//{printf "%16s %8s\n",$(NF),$5 }'
echo -e "\nsystem:"
ls -lah system/ | tail -n +4 | awk '//{printf "%16s %8s\n",$(NF),$5 }'