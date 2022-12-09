#!/bin/bash

# Clean compile.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

clean_qemu()
{
    rm -rf ${TbusOS}/build/qemu-7.0.0
}

clean_kernel()
{
    rm -rf ${TbusOS}/build/linux-5.15.53
}

clean_busybox()
{
    rm -rf ${TbusOS}/build/busybox-1.35.0
}

clean_toolchain()
{
	rm -rf ${TbusOS}/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi
}

case $1 in
    --qemu)
	    clean_qemu
	;;
    --kernel)
	    clean_kernel
	;;
    --busybox)
	    clean_busybox
	;;
	--toolchain)
		clean_toolchain
	;;
    --all | -A)
        clean_qemu
		clean_kernel
		clean_busybox
		clean_toolchain
        ;;
    --help | -h | *)
        echo "[Usage] ./clean.sh"
        echo "--qemu	clean qemu"
        echo "--kernel	clean kernel"
        echo "--busybox	clean busybox"
        echo "--toolchain	clean toolchain"
        echo "--all, -A	clean all"
        ;;
esac

