████████╗██████╗ ██╗   ██╗███████╗ ██████╗ ███████╗
╚══██╔══╝██╔══██╗██║   ██║██╔════╝██╔═══██╗██╔════╝
   ██║   ██████╔╝██║   ██║███████╗██║   ██║███████╗
   ██║   ██╔══██╗██║   ██║╚════██║██║   ██║╚════██║
   ██║   ██████╔╝╚██████╔╝███████║╚██████╔╝███████║
   ╚═╝   ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝
   ------------------------------------------------


How to use:
1.Run "./scripts/apt.sh" install the necessary packages. 
2.Run "source ./scripts/env.sh -A" to set environment variables.
3.Run "./scripts/download_package.sh -A" to download all packages that TbusOS needed.
4.Run "./scripts/toolchains.sh --download" to unzip toolchains package.
5.Run "./scripts/compile.sh -A" to compile qemu, kernel, busybox.
6.Run "./scripts/install.sh -A" to install qemu, kernel and loop device rootfs.
7.Run "./scripts/run.sh --virt" to run TbusOS by virt.


Currently supported functions:  
1.  

Fuction to be supported later:  
1.Support choice kernel, qemu, busybox, toolchain by options.  
2.Support for packaging TbusOS.  
3.Support clean_env.sh.   
4.Support tab out the parameters of each script.
