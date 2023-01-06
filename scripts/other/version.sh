#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2023.01.05 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

SHELL_ARGS=`getopt -o h --long qemu:,kernel:,busyxbox:,toolchain:,help -- "$@"`

eval set -- "${SHELL_ARGS}"

while true
do
	case $1 in
		--qemu)
			export QEMU_VERSION=$2
			shift 2
			;;
		--kernel)
			export KERNEL_VERSION=$2
			shift 2
			;;
		--busybox)
			export BUSYBOX_VERSION=$2
			shift 2
			;;
		--toolchain)
			export TOOLCHAIN_VERSION=$2
			shift 2
			;;
		--)
			shift
			if [ "$1" = "" ]
			then
				break
			fi
			;;
		--help | -h | *)
			echo "[Usage]"
			echo "--qemu=[version]	set qemu version"
			echo "--kernel=[version]	set kernel version"
			echo "--busybox=[version]	set busybox version"
			echo "--toolchain=[version]	set toolchain version"
			break
			;;
	esac
done
