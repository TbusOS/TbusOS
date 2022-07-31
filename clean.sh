#!/bin/bash

# Clean TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

TbusOS=/home/ubuntu/TbusOS

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
	--help | -h)
		echo "[Usage] ./clean.sh"
		echo "Clean up qemu, kernel, busybox"
		;;
	"")
		do_clean
		;;
esac
