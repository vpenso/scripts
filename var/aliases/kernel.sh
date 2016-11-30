export KERNEL=/srv/kernel
export ROOTFS=/srv/rootfs

function kernel-boot-rootfs() {
  local kernel=${1:?Expecting path to kernel}
  local rootfs=${2:?Expecting path to rootfs}
  /usr/bin/kvm -nographic \
    -kernel $kernel -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=/tmp/$rootfs,if=virtio \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0
}

alias kbfs=kernel-boot-rootfs
