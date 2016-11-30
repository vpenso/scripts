

function kvm-one-way() {
  local kernel=${1:?Expecting path to kernel}
  local rootfs=${2:?Expecting path to rootfs}
  local fsname=${rootfs##*/}
  cp -v $rootfs /tmp/$fsname
  /usr/bin/kvm -nographic \
    -kernel $kernel -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=/tmp/$fsname,if=virtio \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0
}

alias k1w=kvm-one-way
