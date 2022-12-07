#!/bin/bash

# run TbusOS.
#
# Copyright (C) 2022.07.31 by liaowenxiong <571550728@qq.com>
#
# SPDX-License-Identifier: GPL-2.0

QEMU=${TbusOS}/TbusOS/qemu/qemu-system-arm
MACH=vexpress-a9
RAM_SIZE=128
LINUX_DIR=${TbusOS}/TbusOS/kernel
ARCH=arm
ROOTFS=${TbusOS}/TbusOS/rootfs
CMDLINE="earlycon root=/dev/ram rdinit=sbin/init console=ttyAMA0"

#Run OS
do_run()
{
    [ ${1}X = "debug"X -o ${2}X = "debug"X ] && ARGS+="-s -S "
    #ARGS+="-D ${}/qemu-system/TbusOS-QEMU.log "

    ${QEMU} ${ARGS} \
    -M ${MACH} \
    -m ${RAM_SIZE}M \
    -kernel ${LINUX_DIR}/zImage \
    -dtb ${LINUX_DIR}/vexpress-v2p-ca9.dtb \
    -nographic \
    -initrd ${ROOTFS}/rootfs.img \
    -append "${CMDLINE}"
}

case $1 in
    --help | -h)
        echo "[Usage] ./run.sh"
        echo "Lunch TbusOS"
    ;;
    "")
        do_run
        ;;
esac

