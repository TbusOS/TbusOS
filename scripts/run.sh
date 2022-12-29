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
		QEMU_DEVICE_ARG="-drive if=sd,format=raw,file=${TbusOS}/TbusOS/rootfs.ext4,id=sd0"
		CMDLINE=${CMDLINE_SD}
	elif [ "$1" = $virt_arg ]
	then
		QEMU_DEVICE_ARG="-device virtio-blk-device,drive=hd0 -drive file=${TbusOS}/TbusOS/rootfs.ext4,format=raw,id=hd0"
		CMDLINE=${CMDLINE_VIRT}
	else
		QEMU_DEVICE_ARG=-initrd ${ROOTFS}/rootfs.img
		CMDLINE=${CMDLINE_RAM}
	fi


	if [ "$SMP_ARG" != "" ]
	then
		SMP_ARG="-smp $SMP_ARG"
		if [ "$MAXCPUS_ARG" != "" ]
		then
			SMP_ARG+=",maxcpus=$MAXCPUS_ARG"
		fi
		if [ "$SOCKETS_ARG" != "" ]
		then
			SMP_ARG+=",sockets=$SOCKETS_ARG"
		fi
		if [ "$DIES_ARG" != "" ]
		then
			SMP_ARG+=",dies=$DIES_ARG"
		fi
		if [ "$CLUSTERS_ARG" != "" ]
		then
			SMP_ARG+=",clusters=$CLUSTERS_ARG"
		fi
		if [ "$CORES_ARG" != "" ]
		then
			SMP_ARG+=",cores=$CORES_ARG"
		fi
		if [ "$THREADS_ARG" != "" ]
		then
			SMP_ARG+=",threads=$THREADS_ARG"
		fi
	fi

    sudo ${QEMU} ${ARGS} ${SMP_ARG} \
    -M ${MACH} \
    -m ${RAM_SIZE}M \
    -kernel ${LINUX_DIR}/zImage \
    -dtb ${LINUX_DIR}/vexpress-v2p-ca9.dtb \
    -nographic \
	${QEMU_DEVICE_ARG} \
	-append "${CMDLINE}"
}

SHELL_ARGS=`getopt -o h --long smp:,cores:,threads:,sockets:,maxcpus:,dies:,clusters:,ram,sd,virt,help -- "$@"`

eval set -- "${SHELL_ARGS}"

while true
do
	case $1 in
		--smp)
			SMP_ARG=$2
			shift 2
			;;
		--cores)
			CORES_ARG=$2
			shift 2
			;;
		--threads)
			THREADS_ARG=$2
			shift 2
			;;
		--sockets)
			SOCKETS_ARG=$2
			shift 2
			;;
		--maxcpus)
			MAXCPUS_ARG=$2
			shift 2
			;;
		--dies)
			DIES_ARG=$2
			shift 2
			;;
		--clusters)
			CLUSTERS_ARG=$2
			shift 2
			;;
		--ram | --sd | --virt)
			DEVICE_ARG=$1
			shift
			;;
		--)
			shift
			if [ "$1" = "" ]
			then
				break
			fi
			;;
		--help | -h | *)
		    echo "[Usage] ./run.sh"
			echo "--sd	use sd as mounted device"
			echo "--virt	use virt device as mounted device"
			echo "--ram	use ram as mounted device"
			echo "--smp=n	set the number of initial CPUs to 'n', you need to select this option in order to select the following 6 options"
			echo "--maxcpus=n	maximum number of total CPUs, including offline CPUs for hotplug,etc"
			echo "--sockets=n	number of sockets on the machine board"
			echo "--dies=n	number of dies in one socket"
			echo "--clusters=n	number of clusters in one die"
			echo "--cores=n	number of cores in one cluster"
			echo "--threads=n	number of threads in one core"
			break
			;;
	esac
done

if [ "$DEVICE_ARG" != "" ]
then
	do_run $DEVICE_ARG
fi
