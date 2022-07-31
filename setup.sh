#!/bin/bash

# SetUp TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

do_setup()
{
	sudo apt-get install libglib2.0-dev
	sudo apt-get install libpixman-1-dev
	sudo apt-get install ninja-build
	sudo apt-get install ncurses-dev
	sudo apt-get install libgmp-dev
	sudo apt-get install libmpc-dev
	sudo apt-get install flex bison g++ 

	TbusOS=/home/ubuntu/TbusOS

	export PATH=${TbusOS}/qemu/qemu_build:${TbusOS}/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}


case $1 in
	--help | -h)
        echo "[Usage] ./setup.sh"
		echo "Download the required apt package and set the environment variables"
		;;
	"")
		do_setup
		;;
esac
