#!/bin/bash

# Clean TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

clean_qemu()
{
    rm -rf ${TbusOS}/build/qemu-7.0.0
    #clean TbusOS/qemu
}

clean_kernel()
{
    cd ${TbusOS}/kernel/linux-5.15.53/
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
    cd -
}

clean_busybox()
{
    cd ${TbusOS}/busybox/busybox-1.35.0
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
    cd -
}

do_clean()
{
    #clean qemu
    cd ${TbusOS}/qemu/qemu_build/
    make distclean
    cd -

    #clean kernel
    cd ${TbusOS}/kernel/linux-5.15.53/
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
    cd -

    #clean busybox
    cd ${TbusOS}/busybox/busybox-1.35.0
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
    cd -
}

case $1 in
    --help | -h | *)
        echo "[Usage] ./clean.sh"
        echo "Clean up qemu, kernel, busybox"
        ;;
    clean_qemu)
	    clean_qemu
	;;
    clean_kernel)
	    clean_kernel
	;;
    clean_busybox)
	    clean_busybox
	;;
    "")
        do_clean
        ;;
esac

