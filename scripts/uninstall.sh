#!/bin/bash

# uninstall TbusOS.
#
# Copyright (C) 2022.12.09 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

uninstall_rootfs()
{
	rm -rf ${TbusOS}/TbusOS/rootfs
	rm ${TbusOS}/TbusOS/rootfs.*
}

uninstall_qemu()
{
	rm -rf ${TbusOS}/TbusOS/qemu
}

uninstall_kernel()
{
	rm -rf ${TbusOS}/TbusOS/kernel
}

case $1 in
	--rootfs)
		uninstall_rootfs
		;;
	--qemu)
		uninstall_qemu
		;;
    --kernel)
        uninstall_kernel
        ;;
	--all | -A)
        uninstall_kernel
		uninstall_qemu
		uninstall_rootfs
		;;
    --help | -h | *)
        echo "[Usage] ./uninstall.sh"
        echo "--rootfs	uninstall rootfs"
        echo "--qemu		uninstall qemu"
        echo "--kernel		uninstall kernel"
        ;;
esac
