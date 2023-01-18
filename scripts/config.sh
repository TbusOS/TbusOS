#!/bin/bash

# Configure TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

kernel()
{
    cd ${TbusOS}/build/linux-${KERNEL_VERSION}
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
}

busybox()
{
    cd ${TbusOS}/build/busybox-${BUSYBOX_VERSION}
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
}

case $1 in
    --kernel)
	    kernel
	;;
    --busybox)
	    busybox
	;;
    --help | -h | *)
        echo "[Usage] ./config.sh [option]"
        echo "--kernel		make kernel menuconfig"
        echo "--busybox		make busybox menuconfig"
        ;;
esac
