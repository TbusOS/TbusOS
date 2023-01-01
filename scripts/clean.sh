#!/bin/bash

# Clean compile.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

distclean_qemu()
{
    rm -rf ${TbusOS}/build/qemu-7.0.0
}

distclean_kernel()
{
    rm -rf ${TbusOS}/build/linux-5.15.53
}

distclean_busybox()
{
    rm -rf ${TbusOS}/build/busybox-1.35.0
}

clean_qemu()
{
	cd ${TbusOS}/build/qemu-7.0.0

	make clean
	make distclean
	rm -rf qemu_build
}

clean_kernel()
{
	cd ${TbusOS}/build/linux-5.15.53

	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
}

clean_busybox()
{
	cd ${TbusOS}/build/busybox-1.35.0

	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
}

clean_toolchain()
{
	rm -rf ${TbusOS}/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi
}

case $1 in
    --distclean_qemu)
	    distclean_qemu
	;;
    --distclean_kernel)
	    distclean_kernel
	;;
    --distclean_busybox)
	    distclean_busybox
	;;
	--distclean_toolchain)
		distclean_toolchain
	;;
	--clean_kernel)
		clean_kernel
	;;
	--clean_qemu)
		clean_qemu
	;;
	--clean_busybox)
		clean_busybox
	;;
    --all | -A)
        distclean_qemu
		distclean_kernel
		distclean_busybox
		distclean_toolchain
        ;;
    --help | -h | *)
        echo "[Usage] ./clean.sh"
        echo "--distclean_qemu	distclean qemu"
        echo "--distclean_busybox	distclean busybox"
        echo "--distclean_kernel	distclean kernel"
        echo "--clean_qemu	clean qemu"
        echo "--clean_kernel	clean kernel"
        echo "--clean_busybox	clean busybox"
        echo "--distclean_toolchain	clean toolchain"
        echo "--all, -A	clean all"
        ;;
esac

