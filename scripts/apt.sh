#!/bin/bash

# SetUp TbusOS.
#
# Copyright (C) 2022.08.04 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

do_apt()
{
	sudo apt-get install libglib2.0-dev
	sudo apt-get install libpixman-1-dev
	sudo apt-get install ninja-build
	sudo apt-get install ncurses-dev
	sudo apt-get install libgmp-dev
	sudo apt-get install libmpc-dev
	sudo apt-get install flex bison g++ 
}

case $1 in
    "")
        do_apt
        ;;
    --help | -h | *)
        echo "[Usage] ./apt.sh"
        echo "Download the required apt package"
        ;;
 
esac

