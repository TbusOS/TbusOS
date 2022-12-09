#!/bin/bash

# SetUp TbusOS env.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

set_TbusOS_env()
{
	export TbusOS=$PWD/..
}

set_qemu_env()
{
	export PATH=${TbusOS}/build/qemu-7.0.0/qemu_build:$PATH
}

set_toolchain_env()
{
	export PATH=${TbusOS}/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}


case $1 in
	--toolchain)
		set_toolchain_env
		;;
	--qemu)
		set_qemu_env
		;;
	--TbusOS)
		set_TbusOS_env
		;;
    --all | -A)
        set_TbusOS_env
		set_qemu_env
		set_toolchain_env
		;;
    --help | -h | *)
        echo "[Usage] ./env.sh"
        echo "--toolchain	set toolchain PATH"
		echo "--qemu		set qemu PATH"
		echo "--TbusOS		set TbusOS dir"
		echo "--all, -A		set toolchain, qemu, TbusOS enviroment variables"
        ;;
esac

