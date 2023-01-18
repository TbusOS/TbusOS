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
	export PATH=${TbusOS}/build/qemu-${QEMU_VERSION}/qemu_build:$PATH
}

set_toolchain_env()
{
	export PATH=${TbusOS}/toolchains/gcc-linaro-${TOOLCHAIN_VERSION}-x86_64_arm-linux-gnueabi/bin:$PATH
}

set_package_version()
{
	source ${TbusOS}/scripts/other/version.sh $@
}

if [ "$OLD_PATH" = "" ]
then
	export OLD_PATH=$PATH
fi


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
	--package_version)
		set_package_version ${@: 2}
		;;
    --all | -A)
        set_TbusOS_env
		set_qemu_env
		set_toolchain_env
		set_package_version --qemu=7.0.0 --kernel=5.15.53 --busybox=1.35.0 --toolchain=7.5.0
		;;
    --help | -h | *)
        echo "[Usage] ./env.sh"
        echo "--toolchain	set toolchain PATH"
		echo "--qemu		set qemu PATH"
		echo "--TbusOS		set TbusOS dir"
		echo "--package_version [arg]	input "--package_version -h" to see more arg"
		echo "--all, -A		set toolchain, qemu, TbusOS enviroment variables"
        ;;
esac

