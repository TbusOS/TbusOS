#!/bin/bash

# Build system.
#
# (C) 2022.07.21 TbusOS by liaowenxiong(571550728@qq.com)

TbusOS=/home/ubuntu/TbusOS
QEMU=${TbusOS}/qemu/qemu_build/qemu-system-arm
MACH=vexpress-a9
RAM_SIZE=128
LINUX_DIR=${TbusOS}/kernel/linux-5.15.53/arch
ARCH=arm
ROOTFS=${TbusOS}/rootfs
CMDLINE="earlycon root=/dev/ram rdinit=sbin/init console=ttyAMA0"


#Run OS
do_run()
{
	[ ${1}X = "debug"X -o ${2}X = "debug"X ] && ARGS+="-s -S "
	#ARGS+="-D ${}/qemu-system/TbusOS-QEMU.log "

	sudo ${QEMU} ${ARGS} \
	-M ${MACH} \
	-m ${RAM_SIZE}M \
	-kernel ${LINUX_DIR}/${ARCH}/boot/zImage \
	-dtb ${LINUX_DIR}/${ARCH}/boot/dts/vexpress-v2p-ca9.dtb \
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
