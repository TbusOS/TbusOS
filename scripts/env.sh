#!/bin/bash

# SetUp TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

do_env()
{
    export TbusOS=$PWD/..
    export PATH=${TbusOS}/qemu/qemu_build:${TbusOS}/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}

case $1 in
    "")
        do_env $1
        ;;
    --help | -h | *)
        echo "[Usage] ./env.sh"
        echo "set the environment variables"
        ;;
esac

