#!/bin/bash
pathToUdk=/home/estude/Documents/UefiApp/Source/UDK2014.SP1
#prepare UDK
rm -fr $pathToUdk/Build
make -C $pathToUdk/BaseTools
cd $pathToUdk
export EDK_TOOLS_PATH=$pathToUdk/BaseTools
. edksetup.sh BaseTools

#ovmf build
#Pre-requisitos
sudo apt-get install build-essential uuid-dev texinfo bison flex libgmp3-dev libmpfr-dev subversion nasm ials

#Compilando ovmf
cd $pathToUdk/OvmfPkg
./build.sh -a X64 -b DEBUG -t GCC46

#build MdeModulePkg
cd $pathToUdk/edk2
export EDK_TOOLS_PATH=$pathToUdk/BaseTools
. edksetup.sh BaseTools
build -p MdeModulePkg/MdeModulePkg.dsc -a X64 -t GCC46 -m MdeModulePkg/Application/HelloWorld/HelloWorld.inf

#prepare vm
rm -fr $pathToUdk/run-ovmf
mkdir $pathToUdk/run-ovmf
mkdir $pathToUdk/run-ovmf/hda-contents
cd $pathToUdk/run-ovmf
cp $pathToUdk/Build/OvmfX64/DEBUG_GCC46/FV/OVMF.fd bios.bin

#copy files to vm
cp $pathToUdk/Build/MdeModule/DEBUG_GCC46/X64/HelloWorld.efi $pathToUdk/run-ovmf/hda-contents/HelloWorld.efi

#run qemu
qemu-system-x86_64 -L . -bios bios.bin -serial file:serial.log -hda fat:hda-contents

#change gcc
#ln -s /usr/bin/gcc-4.6 /usr/bin/gcc
