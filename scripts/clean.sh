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
    rm -rf ${TbusOS}/build/linux-5.15.53
}

clean_busybox()
{
    rm -rf ${TbusOS}/build/busybox-1.35.0
}

case $1 in
    --help | -h | *)
        echo "[Usage] ./clean.sh"
        echo "Clean up qemu, kernel, busybox"
        ;;
    --qemu)
	    clean_qemu
	;;
    --kernel)
	    clean_kernel
	;;
    --busybox)
	    clean_busybox
	;;
    --all | -A)
        clean_qemu
		clean_kernel
		clean_busybox
        ;;
esac

