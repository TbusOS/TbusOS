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
3.download_package.sh: Download kernel, qemu, busybox package. If you want to download a non-default version, you need to run the env.sh setting package version first.
4.install.sh: Install qemu, kernel and rootfs.
