export KERNEL=~/projects/kernel
export ROOTFS=~/projects/rootfs

mkdir -p $KERNEL >/dev/null
mkdir -p $ROOTFS >/dev/null

function kernel-boot-rootfs() {
  local kernel=${1:?Expecting path to kernel}
  shift
  local rootfs=${1:?Expecting path to rootfs}
  shift
  /usr/bin/kvm -nographic \
    -kernel $kernel -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=$rootfs,if=virtio \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0 $@
}

alias kbfs=kernel-boot-rootfs
