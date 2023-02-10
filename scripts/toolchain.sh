#!/bin/bash

# SetUp TbusOS toolchain.
#
# Copyright (C) 2022.12.07 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

TOOLCHAIN_PACKAGE=gcc-linaro-${TOOLCHAIN_VERSION}-x86_64_arm-linux-gnueabi.tar.xz

download_toolchain()
{
    if [ ! -f "${TbusOS}/dl/${TOOLCHAIN_PACKAGE}" ]; then
        ${TbusOS}/scripts/download_package.sh --toolchain
    fi
    if [ ! -d "${TbusOS}/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi" ]; then
        cp ${TbusOS}/dl/${TOOLCHAIN_PACKAGE} ${TbusOS}/toolchains/
		tar xvf ${TbusOS}/toolchains/${TOOLCHAIN_PACKAGE} -C ${TbusOS}/toolchains/
		rm ${TbusOS}/toolchains/${TOOLCHAIN_PACKAGE}
    fi
}

if [ ! -d "${TbusOS}/toolchains" ]; then
	mkdir -p ${TbusOS}/toolchains
fi

case $1 in
	--download)
		download_toolchain
	;;
	--set_env)
		source ${TbusOS}/scripts/env.sh --toolchain	
	;;
    --help | -h | *)
        echo "[Usage] ./toolchain.sh [option]"
        echo "--download	download and unpack toolchain"
        echo "--set_env		set toolchain environment variables"
        ;;
esac
