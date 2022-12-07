#!/bin/bash

# SetUp TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

set_all_env()
{
    export TbusOS=$PWD/..
    export PATH=${TbusOS}/build/qemu-7.0.0/qemu_build:${TbusOS}/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}

set_qemu_env()
{
	export PATH=${TbusOS}/build/qemu-7.0.0/qemu_build:$PATH
}

set_toolchain_env()
{
	export PATH=${TbusOS}/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}


case $1 in
	--toolchain)
		set_toolchain_env
		;;
	--qemu)
		set_qemu_env
		;;
    --all | -A)
        set_all_env $1
        ;;
    --help | -h | *)
        echo "[Usage] ./env.sh"
        echo "set the environment variables"
        ;;
esac

