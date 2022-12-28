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
CMDLINE_RAM="earlycon root=/dev/ram rdinit=sbin/init console=ttyAMA0"
CMDLINE_SD="earlycon root=/dev/mmcblk0 rw rootfstype=ext4 rdinit=sbin/init console=ttyAMA0"
CMDLINE_VIRT="earlycon root=/dev/vda rw rootfstype=ext4 rdinit=sbin/init console=ttyAMA0"

#Run OS
do_run()
{
    #[ ${1}X = "debug"X -o ${2}X = "debug"X ] && ARGS+="-s -S "
    #ARGS+="-D ${}/qemu-system/TbusOS-QEMU.log "
	sd_arg="--sd"
	virt_arg="--virt"
	if [ "$1" = $sd_arg ]
	then
		DEVICE_ARG="-drive if=sd,format=raw,file=${TbusOS}/TbusOS/rootfs.ext4,id=sd0"
		CMDLINE=${CMDLINE_SD}
	elif [ "$1" = $virt_arg ]
	then
		DEVICE_ARG="-device virtio-blk-device,drive=hd0 -drive format=raw,file=${TbusOS}/TbusOS/rootfs.ext4,id=hd0"
		CMDLINE=${CMDLINE_VIRT}
	else
		DEVICE_ARG=-initrd ${ROOTFS}/rootfs.img
		CMDLINE=${CMDLINE_RAM}
	fi

    sudo ${QEMU} ${ARGS} \
    -M ${MACH} \
    -m ${RAM_SIZE}M \
    -kernel ${LINUX_DIR}/zImage \
    -dtb ${LINUX_DIR}/vexpress-v2p-ca9.dtb \
    -nographic \
	${DEVICE_ARG} \
	-append "${CMDLINE}"
}

case $1 in
    --help | -h)
        echo "[Usage] ./run.sh"
		echo "--sd	use sd as mounted device"
		echo "--virt	use virt device as mounted device"
		echo "if not arg	use ram as mounted device"
    ;;
    "" | --sd | --virt)
		do_run $1
        ;;
esac

