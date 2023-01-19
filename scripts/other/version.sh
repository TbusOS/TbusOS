#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2023.01.05 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

declare -A linaro_pack_map

linaro_pack_map["7.5.0"]="7.5.0-2019.12"
linaro_pack_map["7.4.1"]="7.4.1-2019.02"
linaro_pack_map["4.9"]="4.9-2016.02"

declare -A linaro_web_map

linaro_web_map["7.5.0"]="7.5-2019.12"
linaro_web_map["7.4.1"]="7.4-2019.02"
linaro_web_map["4.9"]="4.9-2016.02"

SHELL_ARGS=`getopt -o h --long qemu:,kernel:,busybox:,toolchain:,help -- "$@"`

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
			for key in ${!linaro_web_map[@]}
			do
				if [ "$2" == "$key" ]
				then
					export TOOLCHAIN_WEB=${linaro_web_map[$2]}
					export TOOLCHAIN_VERSION=${linaro_pack_map[$2]}
					break
				fi
			done
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
