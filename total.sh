#!/bin/bash

# Build system.
#
# (C) 2022.07.21 TbusOS by liaowenxiong(571550728@qq.com)

TbusOS=$PWD
LINUX_KERNEL=${TbusOS}/kernel/linux-5.15.53
QEMU=${TbusOS}/qemu/qemu_build/qemu-system-arm
ARCH=arm
BUSYBOX=${TbusOS}/busybox/busybox-1.35.0
OUTPUT=${TbusOS}/output
CROSS_COMPILE=arm-linux-gnueabi
MACH=vexpress-a9
ROOTFS_SIZE=256
ROOTFS_NAME=ext4
RAM_SIZE=128
FS_TYPE=ext4
FS_TYPE_TOOLS=mkfs.ext4
LINUX_DIR=${TbusOS}/kernel/linux-5.15.53/arch
CMDLINE="earlycon root=/dev/ram rdinit=sbin/init console=ttyAMA0"
ROOTFS=${TbusOS}/rootfs
TOOLCHAIN_WEB=https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabi/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar.xz
KERNEL_WEB=https://mirror.bjtu.edu.cn/kernel/linux/kernel/v5.x/linux-5.15.53.tar.xz
QEMU_PACKAGE=qemu-7.0.0.tar.xz
QEMU_WEB=https://download.qemu.org/${QEMU_PACKAGE}

do_running()
{
        [ ${1}X = "debug"X -o ${2}X = "debug"X ] && ARGS+="-s -S "
        #ARGS+="-D ${}/qemu-system/TbusOS-QEMU.log "

        ${QEMU} ${ARGS} \
        -M ${MACH} \
        -m ${RAM_SIZE}M \
        -kernel ${LINUX_DIR}/${ARCH}/boot/zImage \
        -dtb ${LINUX_DIR}/${ARCH}/boot/dts/vexpress-v2p-ca9.dtb \
        -nographic \
        -initrd ${ROOTFS}/rootfs.img \
        -append "${CMDLINE}"
}

do_package()
{
        mkdir -p ${ROOTFS}/{dev,etc/init.d,lib,proc,sys}

        cp -raf ${BUSYBOX}/_install/* ${ROOTFS}

        sudo mknod -m 666 ${ROOTFS}/dev/tty1 c 4 1
        sudo mknod -m 666 ${ROOTFS}/dev/tty2 c 4 2
        sudo mknod -m 666 ${ROOTFS}/dev/tty3 c 4 3
        sudo mknod -m 666 ${ROOTFS}/dev/tty4 c 4 4
        sudo mknod -m 666 ${ROOTFS}/dev/console c 5 1
        sudo mknod -m 666 ${ROOTFS}/dev/null c 1 3

        cp ${TbusOS}/rcS ${ROOTFS}/etc/init.d/rcS

        chmod +x ${ROOTFS}/etc/init.d/rcS

        cd ${ROOTFS}

        find ./ | cpio -o --format=newc > ./rootfs.img
}

do_setup_toolchain()
{
        mkdir -p ${TbusOS}/toolchain
        cd ${TbusOS}/toolchain
        if [ ! -f "gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar" ]; then
                wget ${TOOLCHAIN_WEB}
        fi
        if [ ! -d "gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi" ]; then
                tar xvf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi.tar
        fi

        export PATH=$PWD/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin:$PATH
}

do_compile_qemu()
{
        mkdir -p ${TbusOS}/qemu
        cd ${TbusOS}/qemu
        if [ ! -f "${QEMU_PACKAGE}" ]; then
                wget ${QEMU_WEB}
        fi
        if [ ! -d "qemu-7.0.0" ]; then
                tar xvf ${QEMU_PACKAGE}
        fi
        mkdir -p qemu_build && cd qemu_build
        ../qemu-7.0.0/configure
        make -j8
        #make install
        export PATH=$PWD:$PATH
}

do_clean_qemu()
{
        cd ${TbusOS}/qemu/qemu_build/
        make distclean
        cd -
}

do_compile_kernel()
{
        mkdir -p ${TbusOS}/kernel
        cd ${TbusOS}/kernel
        if [ ! -f "linux-5.15.53.tar.xz" ]; then
                wget ${KERNEL_WEB}
        fi
        if [ ! -d "${TbusOS}/kernel/linux-5.15.53" ]; then
                tar xvf linux-5.15.53.tar.xz
        fi
        cd linux-5.15.53
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- vexpress_defconfig
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
}

do_clean_kernel()
{
        cd ${TbusOS}/kernel/linux-5.15.53/
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
        cd -
}

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

do_compile_busybox()
{
        mkdir -p ${TbusOS}/busybox
        cd ${TbusOS}/busybox
        if [ ! -f "${BUSYBOX_PACKAGE}" ]; then
                wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
        fi
        if [ ! -d "busybox-1.35.0" ]; then
                tar xvf busybox-1.35.0.tar.bz2
        fi
        cd busybox-1.35.0

        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install
}

do_clean_busybox()
{
        cd busybox/busybox-1.35.0
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
        cd -
}

# Lunching TbusOS
case $1 in
        --apt)
                do_apt
                ;;
        --compile_busybox)
                do_compile_busybox
                ;;
        --clean_busybox)
                do_clean_busybox
                ;;
        --compile_kernel)
                do_compile_kernel
                ;;
        --clean_kernel)
                do_clean_kernel
                ;;
        --compile_qemu)
                do_compile_qemu
                ;;
        --clean_qemu)
                do_clean_qemu
                ;;
        --setup_toolchain)
                do_setup_toolchain
                ;;
        --pack)
                # Package TbusOS.img
                do_package
                ;;
        --debug)
                # Debugging TbusOS
                do_running debug
                ;;
        --auto)
                do_apt
                do_setup_toolchain
                do_compile_qemu
                do_compile_kernel
                do_compile_busybox
                do_package
                do_running $1 $2
                ;;
        --clean)
                do_clean_busybox
                do_clean_kernel
                do_clean_qemu
                ;;
        --run)
                # Default Running TbusOS
                do_running $1 $2
                ;;
        --help | -h | *)
                echo "[Usage] ./total.sh [option]"
                echo "--apt               Install the necessary software"
                echo "--compile_busybox   compile busybox"
                echo "--compile_kernel    compile kernel"
                echo "--compile_qemu      compile qemu"
                echo "--setup_toolchain   download and setup environment variables of toolchain"
                echo "--pack              Package TbusOS.img"
                echo "--debug             Debugging TbusOS"
                echo "--run               Default Running TbusOS"
                echo "--auto              Automatically compile, set, and run"
                echo "--clean             clean busybox kernel qemu"
                echo "--clean_busybox     clean busybox"
                echo "--clean_kernel      clean kernel"
                echo "--clean_qemu        clean qemu"
                ;;
esac
