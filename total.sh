#!/bin/bash

# TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

TbusOS=/home/ubuntu/TbusOS

# Lunching TbusOS
case $1 in
	--setup)
		source ${TbusOS}/setup.sh
		;;
	--install)
		source ${TbusOS}/install.sh
		;;
	--clean)
		source ${TbusOS}/clean.sh
		;;
	--run)
		source ${TbusOS}/run.sh
		;;
	--auto)
		source ${TbusOS}/setup.sh
		source ${TbusOS}/install.sh
		source ${TbusOS}/run.sh
		;;
	--help | -h)
		echo "[Usage] ./total.sh [option]"
		echo "--setup		Download the required apt package and set the environment variables"
		echo "--install	Compile kernel, qemu, busybox"
		echo "--run 		Lunch TbusOS"
		echo "--clean		Clean up kernel, qemu, busybox"
		echo "--auto		Automatically execute the above three options"
		;;
esac
