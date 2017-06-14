### Prerequisites

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

### Boot Configuration

Boot into the interactive installation:

```bash
>>> cat /var/www/html/menu.ipxe 
#!ipxe
set base http://lxdev01.devops.test/centos
kernel ${base}/images/pxeboot/vmlinuz initrd=initrd.img inst.repo=${base} inst.text inst.ks=http://lxdev01.devops.test/ks.cfg
initrd ${base}/images/pxeboot/initrd.img
boot || goto shell
```

List of kernel arguments:

```
inst.repo=http://                    # location of the install source
inst.proxy=http://                   # HTTP proxy for the installation
inst.ks=http://...                   # location of the kickstart file
inst.text                            # use text-base UI
inst.headless                        # no display during installation
inst.sshd                            # SSH login during installation
inst.loglevel=<debug|info|warning|error|critical>
```

Cf. [Kickstart Documentation](https://github.com/rhinstaller/pykickstart/blob/master/docs/kickstart-docs.rst)

# Kickstarter

Kickstart provides method to **automate** the installation of CentOS. 


The **kickstart file** contains answers for the Anaconda installer program:

* Simple text file, containing a list of items, each identified by a keyword.
* Omitting required installation items prompts the user for an interactive answer.

Sections must be specified in order:

| Section     | Description                        |
|-------------|------------------------------------|
| common      | Base configuration of the OS       |
| %package    | Custom list of packages to install |
| %pre, %post | Pre- & post-installation scripts   |

## Common Section

Install a new operating system to disk:

```bash
install # install a fresh system
url --url="http://...."                 # install from a remote server over HTTP
```

After successful installation following:

```
reboot                                  # reboot automatically
halt                                    # (default) wait for operator input
shutdown                                # shutdown
poweroff                                # shutdown and power off
```

Localization:

```bash
keyboard --vckeymap=us                  # keyboard layout
lang en_US.UTF-8                        # system language
timezone Europe/Berlin                  # system timezone
```

Authentication and users:

```bash
auth --enableshadow --passalgo=sha512   # authentication options
# dummy accounts for a test environment
rootpw --plaintext root
user --name=devops --password=devops --plaintext
rootpw --iscrypted <hash>
```


### Storage

Access the storage log in the Anaconda text-UI with **CTRL+ALT+F4**

```bash
zerombr                                       # initialize invalid partition table
ignoredisk --drives=sdc,sdd,sde               # ignore disk sdc,sdd,sde during installation
ignoredisk --only-use=sda                     # ignore disks except of sda
clearpart --none                              # do not remove partions
clearpart --initlabel --all                   # overwrite all partitions
clearpart --initlabel --drives=vda,vdb        # overwrite devices vda,vdb
bootloader --location=mbr --boot-drive=vda    #how the boot loader should be installed
```

Partition a single disk:

```bash
part /     --ondisk=vda --asprimary --fstype=ext4 --size=8192
part /var  --ondisk=vda             --fstype=ext4 --size=8192
part /tmp  --ondisk=vda             --fstype=ext4 --size=8192 --maxsize=20480 --grow
part /srv  --ondisk=vda --asprimary --fstype=ext4 --size=10240                --grow
```

## Package Section

Minimal package configuration:

```
%packages --nobase --excludedocs
@core --nodefaults
%end
```
