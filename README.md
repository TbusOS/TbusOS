████████╗██████╗ ██╗   ██╗███████╗ ██████╗ ███████╗
╚══██╔══╝██╔══██╗██║   ██║██╔════╝██╔═══██╗██╔════╝
   ██║   ██████╔╝██║   ██║███████╗██║   ██║███████╗
   ██║   ██╔══██╗██║   ██║╚════██║██║   ██║╚════██║
   ██║   ██████╔╝╚██████╔╝███████║╚██████╔╝███████║
   ╚═╝   ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝
   ------------------------------------------------


How to run:
1.Run "./scripts/apt.sh" install the necessary packages. 
2.Run "source ./scripts/env.sh -A" to set environment variables.
3.Run "./scripts/download_package.sh -A" to download all packages that TbusOS needed.
4.Run "./scripts/toolchains.sh --download" to unzip toolchains package.
5.Run "./scripts/compile.sh -A" to compile qemu, kernel, busybox.
6.Run "./scripts/install.sh -A" to install qemu, kernel and loop device rootfs.
7.Run "./scripts/run.sh --virt" to run TbusOS by virt.

Scripts function:
1.apt.sh: Download the required apt package.
2.compile.sh: Compile kernel, qemu, busybox. If you want to compile a non-default version, you need to run the env.sh setting package version first.
3.download_package.sh: Download kernel, qemu, busybox, toolchain package. If you want to download a non-default version, you need to run the env.sh setting package version first.
4.install.sh: Install qemu, kernel and rootfs.
5.toolchain.sh: Download, unzip and set toolchain path env.
6.clean.sh: Clean or distclean package.
7.env.sh: set qemu, toolchain, TbusOS and package version env. Now, toolchain only support 7.5, 7.4.1, 4.9. Kernel not support which have not vepress_deconfig.
8.config.sh: Run kernel, busybox menuconfig.
9.run.sh: Run TbusOS. If you want use sd as mounted device, you should run install.sh by --rootfs. If you want use ram or virt as mounted device, you should run install.sh by --rootfs_loop_dev.

Example:
1.If you want to compile kernel that version is 4.14.139.
(1) source ./scripts/env.sh -A
(2) source ./scripts/env.sh --kernel=4.14.139
(3) ./compile.sh --kernel

2.If you want to run TbusOS by sd.
(1) ./install.sh --rootfs
(2) ./run.sh --sd

3.If you want to run TbusOS by virt or ram.
(1) ./install.sh --rootfs_loop_dev
(2) ./run.sh --virt.	Or	./run.sh --ram.

4.If you want to set multicore startup.
(1) ./run.sh --virt --smp=n
(2) For more configuration, run "./run.sh -h"
