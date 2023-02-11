#!/bin/bash

# Install TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

pack_rootfs()
{
	mkdir -p ${TbusOS}/TbusOS/rootfs/{dev,etc/init.d,lib,proc,sys}

	cp -raf ${TbusOS}/build/busybox-${BUSYBOX_VERSION}/_install/* ${TbusOS}/TbusOS/rootfs
	
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty1 c 4 1
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty2 c 4 2
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty3 c 4 3
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty4 c 4 4
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/console c 5 1
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/null c 1 3

	cp ${TbusOS}/scripts/other/rcS ${TbusOS}/TbusOS/rootfs/etc/init.d/rcS

	chmod +x ${TbusOS}/TbusOS/rootfs/etc/init.d/rcS

	cd ${TbusOS}/TbusOS/

	find ./rootfs | cpio -o --format=newc > ./rootfs.img
}

pack_rootfs_loop_dev()
{
	mkdir -p ${TbusOS}/TbusOS/rootfs

	sudo dd if=/dev/zero of=${TbusOS}/TbusOS/rootfs.ext4 bs=1M count=32
	sudo mkfs.ext4 ${TbusOS}/TbusOS/rootfs.ext4
	sudo mount -t ext4 ${TbusOS}/TbusOS/rootfs.ext4 ${TbusOS}/TbusOS/rootfs/ -o loop

	sudo mkdir -p ${TbusOS}/TbusOS/rootfs/{dev,etc/init.d,lib,proc,sys}
	sudo cp -raf ${TbusOS}/build/busybox-${BUSYBOX_VERSION}/_install/* ${TbusOS}/TbusOS/rootfs

	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty1 c 4 1
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty2 c 4 2
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty3 c 4 3
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/tty4 c 4 4
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/console c 5 1
	sudo mknod -m 666 ${TbusOS}/TbusOS/rootfs/dev/null c 1 3

	sudo cp ${TbusOS}/scripts/other/rcS ${TbusOS}/TbusOS/rootfs/etc/init.d/rcS

	sudo chmod +x ${TbusOS}/TbusOS/rootfs/etc/init.d/rcS
	sudo umount ${TbusOS}/TbusOS/rootfs

	sudo chmod 666 ${TbusOS}/TbusOS/rootfs.ext4
}

install_qemu()
{
	mkdir -p ${TbusOS}/TbusOS/qemu

	cp ${TbusOS}/build/qemu-${QEMU_VERSION}/qemu_build/qemu-system-arm ${TbusOS}/TbusOS/qemu
}

install_kernel()
{
    if [ ! -d "${TbusOS}/TbusOS/kernel" ]; then
		mkdir -p ${TbusOS}/TbusOS/kernel
	fi
	cp ${TbusOS}/build/linux-${KERNEL_VERSION}/arch/arm/boot/zImage ${TbusOS}/TbusOS/kernel
	cp ${TbusOS}/build/linux-${KERNEL_VERSION}/arch/arm/boot/dts/vexpress-v2p-ca9.dtb ${TbusOS}/TbusOS/kernel
}

if [ ! -d "${TbusOS}/TbusOS" ]; then
	mkdir -p ${TbusOS}/TbusOS
fi

if [ ! -f "${TbusOS}/TbusOS/TbusOS_run.sh" ]; then
	cp ${TbusOS}/scripts/other/TbusOS_run.sh ${TbusOS}/TbusOS
fi

case $1 in
	--rootfs)
		pack_rootfs
		;;
	--rootfs_loop_dev)
		pack_rootfs_loop_dev
		;;
	--qemu)
		install_qemu
		;;
    --kernel)
        install_kernel
        ;;
	-A | --all)
		install_kernel
		install_qemu
		pack_rootfs_loop_dev
		;;
    --help | -h | *)
        echo "[Usage] ./install.sh"
        echo "--rootfs	install rootfs"
		echo "--rootfs_loop_dev   install loop device rootfs"
        echo "--qemu		install qemu"
        echo "--kernel		install kernel"
		echo "-A, --all	install qemu, kernel and loop device rootfs"
        ;;
esac
