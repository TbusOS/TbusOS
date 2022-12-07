#!/bin/bash

# SetUp TbusOS.
#
# Copyright (C) 2022.12.07 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

TOOLCHAIN_WEB=https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabi/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar.xz
TOOLCHAIN_PACKAGE=gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar

download_toolchain()
{
    if [ ! -f "${TbusOS}/toolchains/${TOOLCHAIN_PACKAGE}" ]; then
        ${TbusOS}/scripts/download_package.sh --toolchain ${TOOLCHAIN_WEB}
    fi
    if [ ! -d "${TbusOS}/build/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi" ]; then
        cp ${TbusOS}/dl/${TOOLCHAIN_PACKAGE} ${TbusOS}/build/
		tar xvf ${TbusOS}/build/${TOOLCHAIN_PACKAGE} -C ${TbusOS}/build/
		rm ${TbusOS}/build/${TOOLCHAIN_PACKAGE}
    fi
}

case $1 in
	--download)
		download_toolchain
	;;
	--set_env)
		${TbusOS}/scripts/env.sh --toolchain	
	;;
esac
