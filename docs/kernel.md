↴ [var/aliases/kernel.sh](../var/aliases/kernel.sh)  
Cf. [initramfs](initramfs.md) to create a RAM disk  
Cf. [bootstrap](bootstrap.md) to create a rootfs

Download the latest Linux from  [www.kernel.org](https://www.kernel.org/)


```bash
## -- Build a Linux kernel -- ##
apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev
cd $KERNEL && version=4.11.7
wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${version}.tar.xz | tar -xvJ
make x86_64_defconfig                                   # x86_64 configuration 
make kvmconfig                                          # enable KVM support
make -j4                                                # compile on multi-core
kernel=$KERNEL/linux-${version}-basic && echo $kernel
cp -v arch/x86/boot/bzImage $kernel && cp -v .config ${kernel}.config
                                                        # save kernel and its configuration
make modules                                            # compiles modules
make modules_install INSTALL_MOD_PATH=${kernel}.modules # installs kernel modules
## -- Boot custom kernel with with a dedicated root file-system -- ##
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs -initrd /srv/kernel/linux-4.8.11-basic.initramfs
```

Kernel instrumentation [BBC](https://github.com/iovisor/bcc)

