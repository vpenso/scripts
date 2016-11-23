Fully Automated Installation → [FAI](http://fai-project.org/)

```bash
>>> grep -i pretty /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 8 (jessie)"
>>> wget -O - http://fai-project.org/download/074BCDE4.asc | apt-key add -
>>> echo "deb http://fai-project.org/download jessie koeln" > /etc/apt/sources.list.d/fai.list
>>> apt update && apt -y upgrade && apt -y install fai-quickstart
>>> sed -i -e 's/^#deb/deb/' /etc/fai/apt/sources.list
>>> sed -i -e 's/#LOGUSER/LOGUSER/' /etc/fai/fai.conf
>>> fai-setup -v                                 # build the NFS root directory in /srv/fai/nfsroot
>>> cp -a /usr/share/doc/fai-doc/examples/simple/* /srv/fai/config/
                                                 # copy the example configiration space
>>> grep fai /etc/exports                                                                                                           
/srv/fai/nfsroot *(async,ro,no_subtree_check,no_root_squash)
/srv/fai/config *(async,ro,no_subtree_check,no_root_squash)
>>> systemctl restart nfs-kernel-server
>>> exportfs 
```

Stand alone ISO CD images for offline deployment:

```bash
>>> fai-mirror -c LINUX,AMD64,FAIBASE,DEBIAN,GRUB_PC -v /srv/fai/mirror | tee /var/log/fai-mirror.log
                                                 # Create a package mirror for a FAI CD
>>> tree /srv/fai/mirror/                        # mirror package tree 
>>> fai-make-nfsroot -l
>>> fai-cd -m /srv/fai/mirror/ /srv/http/fai.iso # create a stand alone FAI CD for offline deployment
```

## Boot

Boot over TFTP with PXELINUX

```bash
>>> netstat -anp|grep :69                                # check if the TFTP server is listening
>>> cat /etc/default/tftpd-hpa                           # TTP server configuration
>>> fai-chboot -IFv -u nfs://$(ip route get 1 | awk '{print $NF;exit}')/srv/fai/config default 
>>> cat /srv/tftp/fai/pxelinux.cfg/default               # default PXE configuration
```

Boot over HTTP with iPXE

```bash
>>> apt -y install lighttpd                                     # install a web-server
>>> grep server.document-root /etc/lighttpd/lighttpd.conf    # configure the document root
server.document-root        = "/srv/http"
>>> systemctl restart lighttpd                               # load ne configuration
>>> cp /srv/fai/nfsroot/boot/{initrd,vmlinuz}* /srv/http/fai # copy the kernel and init RAM disk
>>> cat /srv/http/fai/default                                # default iPXE configuration
#!ipxe
initrd initrd.img-3.16.0-4-amd64 
kernel vmlinuz-3.16.0-4-amd64 ip=dhcp ro root=10.1.1.27:/srv/fai/nfsroot aufs FAI_FLAGS=verbose,sshd,createvt FAI_CONFIG_SRC=nfs://10.1.1.27/srv/fai/config FAI_ACTION=install
boot
```

Kernel Configuration

→ [Dracut NFS](https://www.kernel.org/pub/linux/utils/boot/dracut/dracut.html#_nfs)

```bash
console=tty0 console=ttyS1,115200n8                           # Configure the serial console
rd.shell rd.debug log_buf_len=1M                              # Kernel debugging
FAI_FLAGS=[…],sshd,createvt                                   # enable SSH login during deployment
                                                              # access another console with ALT-F2, and ALT-F3
```



KVM virtual machine for testing

```bash
>>> qemu-img create -f qcow2 disk.img 100G  # disk image for the test virtual machine
>>> virsh-config -Nv -m 02:FF:0A:0A:06:1C libvirt_instance.xml
## ---  Hit CTRL-B to enter the iPXE shell -- ##
>>> dhcp                                        # enable the network interface
>>> chain tftp://10.1.1.27/fai/pxelinux.0       # chain load PXELINUX confgiuration from the FAI server using TFTP
>>> chain http://10.1.1.27/fai/default          # chain load iPXE configuration from the FAI server over HTTP
## -- Shift-Up/Down to scroll con qemu console -- ##
```



