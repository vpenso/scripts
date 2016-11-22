Fully Automated Installation → [FAI](http://fai-project.org/)

* Non-interactive system to install custom Linux
* Uses an NFS server to mount a live root file system including the configuration space for automated installation

```bash
>>> apt-get -y install fai-quickstart syslinux-common tftpd-hpa
>>> fai-setup -v                                 # build the NFS root directory in /srv/fai/nfsroot
>>> cp -a /usr/share/doc/fai-doc/examples/simple/* /srv/fai/config/
                                                 # copy the example configiration space
```

Using an ISO image for deployment:

```
>>> fai-mirror -c LINUX,AMD64,FAIBASE,DEBIAN,GRUB_PC -v /srv/fai/mirror | tee /var/log/fai-mirror.log
                                                 # Create a package mirror for a FAI CD
>>> tree /srv/fai/mirror/                        # mirror package tree 
>>> fai-cd -m /srv/fai/mirror/ /tmp/fai.iso      # create a FAI CD
```

## Boot

Boot over TFTP with PXELINUX

```bash
>>> fai-chboot -IFv -u nfs://$(ip route get 1 | awk '{print $NF;exit}')/srv/fai/config default 
>>> cat /srv/tftp/fai/pxelinux.cfg/default               # default PXE configuration
```

Boot over HTTP with iPXE

```bash
>>> apt install lighttpd                                     # install a web-server
>>> grep server.document-root /etc/lighttpd/lighttpd.conf    # configure the document root
server.document-root        = "/srv/http"
>>> systemctl restart lighttpd                               # load ne configuration
>>> cp /srv/fai/nfsroot/boot/{initrd,vmlinuz}* /srv/http/fai # copy the kernel and init RAM disk
>>> cat /srv/http/fai/default                                # default iPXE configuration
#!ipxe
initrd initrd.img-3.16.0-4-amd64
kernel vmlinuz-3.16.0-4-amd64 ip=dhcp rw aufs root=10.1.1.27:/srv/fai/nfsroot:vers=3,nolock FAI_CONFIG_SRC=nfs://10.1.1.27/srv/fai/config FAI_FLAGS=verbose,sshd,createvt FAI_ACTION=install DOMAIN=devops.test
boot
```

KVM virtual machine for testing

```bash
>>> qemu-img create -f qcow2 /tmp/disk.img 100G  # disk image for the test virtual machine
>>> alias kvm='kvm -m 2G -drive file=/tmp/disk.img,if=virtio,cache=writeback -netdev user,id=n0,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n0'
                                                 # KVM configuration use to start a test virual machine
## ---  Hit CTRL-B to enter the iPXE shell -- ##
>>> dhcp                                        # enable the network interface
>>> chain tftp://10.1.1.27/fai/pxelinux.0       # chain load PXELINUX  confgiuration from the FAI server using TFTP
>>> chain http://10.1.1.27/fai/default          # chain load iPXE configuration from the FAI server over HTTP
```

