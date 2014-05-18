#!/bin/bash
#prepare UDK
rm -fr ~/src/edk2/Build
make -C ~/src/edk2/BaseTools
cd ~/src/edk2
export EDK_TOOLS_PATH=$HOME/src/edk2/BaseTools
. edksetup.sh BaseTools


#ovmf build
cd ~/src/edk2/OvmfPkg
./build.sh -a X64 -b DEBUG -t GCC46

#build MdeModulePkg
cd ~/src/edk2
export EDK_TOOLS_PATH=$HOME/src/edk2/BaseTools
. edksetup.sh BaseTools
build -p MdeModulePkg/MdeModulePkg.dsc -a X64 -t GCC46 -m MdeModulePkg/Application/HelloWorld/HelloWorld.inf

#prepare vm
rm -fr ~/run-ovmf
mkdir ~/run-ovmf
mkdir ~/run-ovmf/hda-contents
cd ~/run-ovmf
cp ~/src/edk2/Build/OvmfX64/DEBUG_GCC46/FV/OVMF.fd bios.bin

#copy files to vm
cp ~/src/edk2/Build/MdeModule/DEBUG_GCC46/X64/HelloWorld.efi ~/run-ovmf/hda-contents/HelloWorld.efi


#run qemu
qemu-system-x86_64 -L . -bios bios.bin -serial file:serial.log -hda fat:hda-contents

#change gcc
#ln -s /usr/bin/gcc-4.6 /usr/bin/gcc
