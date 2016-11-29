
[kernel.org](https://www.kernel.org/)

Minimal Debian user-space:

```bash
>>> ostree=/tmp/jessie osimg=/tmp/os.img
>>> mkdir $ostree && debootstrap jessie $ostree                      # minimal Debian user-space
>>> dd if=/dev/zero of=$osimg bs=1M seek=4095 count=1                # crate an disk image file
>>> sudo mkfs.ext4 -F $osimg                                         # initialize a file-system
>>> sudo mount -o loop $osimg /mnt                                   # mount the disk image
>>> sudo cp -a $ostree/. /mnt                                        # copy user-space
>>> sudo chroot /mnt /bin/bash                                       # in order to modify the disk image
## -- Modify the user-space image with chroot -- ##
chroot> sed -i '/^root/ { s/:x:/::/ }' /etc/passwd                   # make root passwordless 
chroot> exit
>>> sudo umount /mnt
```

Build Linux with a minimal configuration for a virtual machine:

```bash
>>> apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev 
>>> wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.8.11.tar.xz | tar -xvJ
                                                            # get the Linux kernel source code
>>> make x86_64_defconfig && make kvmconfig                 # x86_64 confgiuration with KVM support
>>> make -jX                                                # compile on multi-core
>>> kvm -kernel arch/x86/boot/bzImage -drive file=$osimg,if=virtio -nographic -append "console=ttyS0 root=/dev/vda"
                                                            # boot the kernel
```
[kernel parameters](https://www.kernel.org/doc/Documentation/kernel-parameters.txt)
