#!/bin/bash

# Build system.
#
# (C) 2022.07.21 TbusOS by liaowenxiong(571550728@qq.com)

TbusOS=/home/ubuntu/TbusOS
TOOLCHAIN_WEB=https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabi/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar.xz
QEMU_PACKAGE=qemu-7.0.0.tar.xz
QEMU_WEB=https://download.qemu.org/${QEMU_PACKAGE}
KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v5.x/linux-5.15.53.tar.xz
BUSYBOX=${TbusOS}/busybox/busybox-1.35.0
ROOTFS=${TbusOS}/rootfs
BUSYBOX_PACKAGE=busybox-1.35.0.tar.bz2

do_install()
{
	#set up toolchain
	mkdir -p ${TbusOS}/toolchain
	cd ${TbusOS}/toolchain
	if [ ! -f "gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar.xz" ]; then
		wget ${TOOLCHAIN_WEB}
	fi
	if [ ! -d "gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi" ]; then
		tar xvf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar.xz
	fi

	#compile qemu
	mkdir -p ${TbusOS}/qemu
	cd ${TbusOS}/qemu
	if [ ! -f "${QEMU_PACKAGE}" ]; then
		wget ${QEMU_WEB}
	fi
	if [ ! -d "qemu-7.0.0" ]; then
		tar xvf ${QEMU_PACKAGE}
	fi
	mkdir -p qemu_build && cd qemu_build
	../qemu-7.0.0/configure
	make
	make install

	#compile kernel
	mkdir -p ${TbusOS}/kernel
	cd ${TbusOS}/kernel
	if [ ! -f "linux-5.15.53.tar.xz" ]; then
		wget ${KERNEL_WEB}
	fi
	if [ ! -d "${TbusOS}/kernel/linux-5.15.53" ]; then
		tar xvf linux-5.15.53.tar.xz
	fi
	cd linux-5.15.53
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- vexpress_defconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j2

	#compile busybox
	mkdir -p ${TbusOS}/busybox
	cd ${TbusOS}/busybox
	if [ ! -f "${BUSYBOX_PACKAGE}" ]; then
		wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
	fi
	if [ ! -d "busybox-1.35.0" ]; then
		tar xvf busybox-1.35.0.tar.bz2
	fi
	cd busybox-1.35.0

	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j4
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install

	#Package file system
	mkdir -p ${ROOTFS}/{dev,etc/init.d,lib,proc,sys}

	cp -raf ${BUSYBOX}/_install/* ${ROOTFS}

	sudo mknod -m 666 ${ROOTFS}/dev/tty1 c 4 1
	sudo mknod -m 666 ${ROOTFS}/dev/tty2 c 4 2
	sudo mknod -m 666 ${ROOTFS}/dev/tty3 c 4 3
	sudo mknod -m 666 ${ROOTFS}/dev/tty4 c 4 4
	sudo mknod -m 666 ${ROOTFS}/dev/console c 5 1
	sudo mknod -m 666 ${ROOTFS}/dev/null c 1 3

	cp ${TbusOS}/rcS ${ROOTFS}/etc/init.d/rcS

	sudo chmod +x ${ROOTFS}/etc/init.d/rcS

	cd ${ROOTFS}

	find ./ | cpio -o --format=newc > ./rootfs.img

}

case $1 in
	--help | -h)
		echo "[Usage] ./install.sh"
		echo "Compile kernel, qemu, busybox"
		;;
	"")
		do_install
		;;
esac
