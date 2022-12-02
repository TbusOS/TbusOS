#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

QEMU_PACKAGE=qemu-7.0.0.tar.xz
QEMU_WEB=https://download.qemu.org/${QEMU_PACKAGE}

compile_qemu()
{
    mkdir -p ${TbusOS}/build/qemu
    cd ${TbusOS}/build/qemu
    if [ ! -f "${QEMU_PACKAGE}" ]; then
        ./download_package.sh --qemu ${QEMU_WEB}
    fi
    if [ ! -d "qemu-7.0.0" ]; then
        cp ${TbusOS}/dl/${QEMU_PACKAGE} .
	tar xvf ${QEMU_PACKAGE}
	rm ${QEMU_PACKAGE}
    fi
    mkdir -p qemu_build && cd qemu_build
    ../qemu-7.0.0/configure
    make -j8
    make install
}

compile_kernel()
{
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
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
}

compile_busybox()
{
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
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install
}

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
    --help | -h | *)
        echo "[Usage] ./install.sh [option]"
        echo "--kernel		compile kernel"
        echo "--qemu		compile qemu"
        echo "--busybox		compile busybox"
        ;;
esac

