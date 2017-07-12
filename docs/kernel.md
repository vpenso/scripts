↴ [var/aliases/kernel.sh](../var/aliases/kernel.sh)  
Cf. [initramfs](initramfs.md) to create a RAM disk  
Cf. [bootstrap](bootstrap.md) to create a rootfs

Download the latest Linux from  [www.kernel.org](https://www.kernel.org/)


```bash
>>> apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev
## Build in a scratch location, i.e. /tmp
>>> version=4.11.7
>>> wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${version}.tar.xz | tar -xvJ
>>> cd linux-${version}
## Configure and build the kernel
>>> make x86_64_defconfig                                   # x86_64 configuration 
>>> make kvmconfig                                          # enable KVM support
# directory to store the build products
>>> kernel=${KERNEL}/${version} && echo $kernel && mkdir $kernel 
>>> log=${kernel}/build.log && echo $log
>>> make -j8 2>&1 | tee -a $log
# save kernel and its configuration
>>> cp -v arch/x86/boot/bzImage $kernel/linux && cp -v .config ${kernel}/linux.config
make modules 2>&1 | tee $log                            # compiles modules
mkdir ${kernel}/modules
# installs kernel modules
make modules_install INSTALL_MOD_PATH=${kernel}/modules 2>&1 >> tee -a $log
>>> ls -1 $kernel
build.log
linux
linux.config
modules/
## -- Boot custom kernel with with a dedicated root file-system -- ##
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs -initrd /srv/kernel/linux-4.8.11-basic.initramfs
```

Kernel instrumentation [BBC](https://github.com/iovisor/bcc)

