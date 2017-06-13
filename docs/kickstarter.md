## Prerequisites

Install/configure DHCP (cf. [net/dnsmasq.md](net/dnsmasq.md)), and HTTP services:

```bash
## Install a web-server
>>> yum -y install httpd && systemctl enable httpd && systemctl start httpd
>>> firewall-cmd --permanent --add-service=http && firewall-cmd --reload
# Disable SELinux
>>> grep ^SELINUX= /etc/selinux/config
SELINUX=disabled
>>> setenforce 0 && sestatus
```

Add an iPXE configuration to the DHCP server, cf. [pxe.md](pxe.md)

```
>>> yum -y install tftp-server 
>>> cat /etc/dnsmasq.d/ipxe.conf
enable-tftp
tftp-root=/var/lib/tftpboot
dhcp-userclass=set:ipxe,iPXE
dhcp-boot=tag:#ipxe,undionly.kpxe
dhcp-boot=tag:ipxe,http://10.1.1.27:80/menu.ipxe
## restart dnsmasq
## build iPXE and copy the boot image
>>> yum -y install gcc binutils make perl syslinux xz-devel genisoimage git
>>> git clone git://git.ipxe.org/ipxe.git ipxe && cd ipxe/src
>>> make bin/undionly.kpxe && cp bin/undionly.kpxe /var/lib/tftpboot
```

Extract boot images from the official source, [CentOS mirros](http://isoredirect.centos.org/centos/7/isos/x86_64/)

```bash
curl -o /tmp/centos.iso http://centos.mirror.net-d-sign.de/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso
mount -o loop /tmp/centos.iso /mnt
mkdir /var/www/html/centos && cp -r /mnt /var/www/html/centos/
umount /mnt
```

More then 1GB memory required for the CentOS LiveOS!

## Boot Configuration

Boot into the interactive installation:

```bash
>>> cat /var/www/html/menu.ipxe 
#!ipxe
set base http://lxdev01.devops.test/centos
kernel ${base}/images/pxeboot/vmlinuz initrd=initrd.img inst.repo=${base} inst.text ip=dhcp
initrd ${base}/images/pxeboot/initrd.img
boot || goto shell
```


# Kickstarter

```bash
yum install pykickstart
```

