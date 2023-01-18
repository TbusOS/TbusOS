#!/bin/bash

# Download the required packages to compile TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

QEMU_PACKAGE=qemu-${QEMU_VERSION}.tar.xz
QEMU_WEB=https://download.qemu.org/${QEMU_PACKAGE}

KERNEL_PACKAGE=linux-${KERNEL_VERSION}.tar.xz
if [ ${KERNEL_PACKAGE:0:1} = "1" ] ||  [ ${KERNEL_PACKAGE:0:1} = "2" ] then
	KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v${KERNEL_PACKAGE:0:1}.${KERNEL_PACKAGE:1:1}/${KERNEL_PACKAGE}
else
	KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v${KERNEL_PACKAGE:0:1}.x/${KERNEL_PACKAGE}
fi

BUSYBOX_PACKAGE=busybox-${BUSYBOX_VERSION}.tar.bz2
BUSYBOX_WEB=https://busybox.net/downloads/${BUSYBOX_PACKAGE}

TOOLCHAIN_PACKAGE=gcc-linaro-${TOOLCHAIN_VERSION}-x86_64_arm-linux-gnueabi.tar.xz
TOOLCHAIN_WEB=https://releases.linaro.org/components/toolchain/binaries/${TOOLCHAIN_VERSION}/arm-linux-gnueabi/${TOOLCHAIN_PACKAGE}

download_qemu()
{
    cd ${TbusOS}/dl
    wget $1
}

download_kernel()
{
    cd ${TbusOS}/dl
    wget $1
}

download_toolchain()
{
	cd ${TbusOS}/dl
	wget $1
}

download_busybox()
{
	cd ${TbusOS}/dl
	wget $1
}

if [ ! -d "${TbusOS}/dl" ]; then
	mkdir -p ${TbusOS}/dl
fi

case $1 in
    --kernel)
    	download_kernel $2
	;;
    --busybox)
		download_busybox $2
	;;
    --qemu)
		download_qemu $2
	;;
	--toolchain)
		download_toolchain $2
	;;
	-A | --all)
		download_qemu ${QEMU_WEB}
		download_kernel ${KERNEL_WEB}
		download_busybox ${BUSYBOX_WEB}
		download_toolchain ${TOOLCHAIN_WEB}
		;;
    --help | -h | *)
		echo "[Usage] ./download_package.sh [option]"
        echo "--kernel		download kernel"
        echo "--qemu		download qemu"
        echo "--busybox		download busybox"
        echo "--toolchain		download toolchain"
		echo "-A, --all	download kernel qemu busybox toolchain"
	;;
esac
