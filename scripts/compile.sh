#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

compile_qemu()
{
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
    --help | -h)
        echo "[Usage] ./install.sh"
        echo "Compile kernel, qemu, busybox"
        ;;
    compile_kernel)
	    compile_kernel
        ;;
    compile_busybox)
	    compile_busybox
	;;
    compile_qemu)
	    compile_qemu
	;;
esac

