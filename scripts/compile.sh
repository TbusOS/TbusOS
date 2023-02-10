#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

QEMU_PACKAGE=qemu-${QEMU_VERSION}.tar.xz
QEMU_WEB=https://download.qemu.org/${QEMU_PACKAGE}
KERNEL_PACKAGE=linux-${KERNEL_VERSION}.tar.xz
if [ ${KERNEL_VERSION:0:1} = "1" ] ||  [ ${KERNEL_VERSION:0:1} = "2" ]
then
	KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v${KERNEL_VERSION:0:1}.${KERNEL_VERSION:2:1}/${KERNEL_PACKAGE}
else
	KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v${KERNEL_VERSION:0:1}.x/${KERNEL_PACKAGE}
fi
BUSYBOX_PACKAGE=busybox-${BUSYBOX_VERSION}.tar.bz2
BUSYBOX_WEB=https://busybox.net/downloads/${BUSYBOX_PACKAGE}

compile_qemu()
{
    if [ ! -f "${TbusOS}/dl/${QEMU_PACKAGE}" ]; then
        ${TbusOS}/scripts/download_package.sh --qemu ${QEMU_WEB}
    fi
    if [ ! -d "${TbusOS}/build/qemu-${QEMU_VERSION}" ]; then
        cp ${TbusOS}/dl/${QEMU_PACKAGE} ${TbusOS}/build/
		tar xvf ${TbusOS}/build/${QEMU_PACKAGE} -C ${TbusOS}/build/
		rm ${TbusOS}/build/${QEMU_PACKAGE}
    fi
    mkdir -p ${TbusOS}/build/qemu-${QEMU_VERSION}/qemu_build && cd ${TbusOS}/build/qemu-${QEMU_VERSION}/qemu_build
    ../configure
    make -j8
}

compile_kernel()
{
    if [ ! -f "${TbusOS}/dl/${KERNEL_PACKAGE}" ]; then
        ${TbusOS}/scripts/download_package.sh --kernel ${KERNEL_WEB}
    fi
    if [ ! -d "${TbusOS}/build/linux-${KERNEL_VERSION}" ]; then
        cp ${TbusOS}/dl/${KERNEL_PACKAGE} ${TbusOS}/build/
		tar xvf ${TbusOS}/build/${KERNEL_PACKAGE} -C ${TbusOS}/build/
		rm ${TbusOS}/build/${KERNEL_PACKAGE}
		cd ${TbusOS}/build/linux-${KERNEL_VERSION}
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- vexpress_defconfig
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
    fi
	cd ${TbusOS}/build/linux-${KERNEL_VERSION}
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
}

compile_busybox()
{
    if [ ! -f "${TbusOS}/dl/${BUSYBOX_PACKAGE}" ]; then
        ${TbusOS}/scripts/download_package.sh --busybox ${BUSYBOX_WEB}
	fi
    if [ ! -d "${TbusOS}/build/busybox-${BUSYBOX_VERSION}" ]; then
		cp ${TbusOS}/dl/${BUSYBOX_PACKAGE} ${TbusOS}/build/
		tar xvf ${TbusOS}/build/${BUSYBOX_PACKAGE} -C ${TbusOS}/build/
		rm ${TbusOS}/build/${BUSYBOX_PACKAGE}
		cd ${TbusOS}/build/busybox-${BUSYBOX_VERSION}
		patch -p0 Config.in < ${TbusOS}/scripts/other/static.patch
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig
	fi
	cd ${TbusOS}/build/busybox-${BUSYBOX_VERSION}
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install
}

if [ ! -d "${TbusOS}/build" ]; then
	mkdir -p ${TbusOS}/build
fi

case $1 in
    --kernel)
	    compile_kernel
    ;;
    --busybox)
	    compile_busybox
	;;
    --qemu)
	    compile_qemu
	;;
	-A | --all)
		compile_kernel
		compile_busybox
		compile_qemu
		;;
    --help | -h | *)
        echo "[Usage] ./install.sh [option]"
        echo "--kernel		compile kernel"
        echo "--qemu		compile qemu"
        echo "--busybox		compile busybox"
		echo "-A, --all	compile all"
        ;;
esac
