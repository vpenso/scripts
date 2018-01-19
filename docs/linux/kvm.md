# KVM 

KVM (Kernel Based Virtual Machine):

* Requires hardware virtualisation extensions like Intel VT or AMD-V.
* Kernel module `kvm.ko` with processor specific extensions `kvm-{amd,intel}.ko`.
* Th kernel module **allows user-space to run a virtual machine as ordinary process**.
* Uses QEMU (generic machine emulator and virtualizer).
* Can be manage via the libvirt API and tools.


```bash
egrep -c '(vmx|svm)' /proc/cpuinfo       # check if the hardware supports KVM
apt install -y qemu-kvm                  # install on Debian
lsmod | grep kvm                         # check if the kernel modules are loaded
dmesg | grep kvm                         # check kernel messages
qemu-system-x86_64 -enable-kvm ...       # QEMU with KVM enabled
kvm ...                                  # ^^
```

Make sure `$USER` can access the KVM device:

```bash
>>> ls -la /dev/kvm
crw-rw----+ 1 root kvm 10, 232 Sep 18 09:00 /dev/kvm
>>> sudo adduser $USER kvm
## or
>>> sudo usermod -a -G kvm $USER
```



Using the `kvm` command:

```bash
# boot the host kernel with custom initramfs
kvm -m 2048 -kernel /boot/vmlinuz-$(uname -r) -initrd /tmp/initramfs.cpio.gz
# attach a network interface
kvm -netdev user,id=net0 -device virtio-net-pci,netdev=net0 ...
# redirect serial console to terminal
kvm -nographic .. -append console=ttyS0 ..
```


## Nested virtualization

Allow to run a VM within a VM with hardware acceleration:

```bash
>>> cat /etc/modprobe.d/kvm-nested.conf
options kvm-intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1
# reload the kernel module (stop all VMs beforehand)
>>> modprobe -r kvm_intel && modprobe -a kvm_intel
# check for the support
>>> cat /sys/module/kvm_intel/parameters/nested
Y
```

Configure [Libvirt](https://libvirt.org) to pass all features of the host CPU:

```bash
>>> grep 'cpu mode' libvirt_instance.xml
  <cpu mode="host-passthrough"></cpu>
```
