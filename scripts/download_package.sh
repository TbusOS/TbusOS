#!/bin/bash

# Build TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

download_qemu()
{
    cd ${TbusOS}/dl
    wget $1
}

case $1 in
    --kernel)
    	download_kernel
	;;
    --busybox)
	download_busybox
	;;
    --qemu)
	download_qemu $2
	;;
    --help | -h | *)
	echo "[Usage] ./download_package.sh [option]"
        echo "--kernel		download kernel"
        echo "--qemu		download qemu"
        echo "--busybox		download busybox"
