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

```bash
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
www=/var/www/html
curl -o /tmp/centos.iso http://centos.mirror.net-d-sign.de/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso
mount -o loop /tmp/centos.iso /mnt
mkdir -p ${www}/boot/centos/7/1611 && cp -r /mnt/* ${www}/boot/centos/7/1611
umount /mnt
ln -s ${www}/boot/centos/7/1611 ${www}/boot/centos/current
```

More then 1GB memory required for the CentOS LiveOS!

### Boot Configuration

Boot into the interactive installation:

```bash
>>> cat /var/www/html/centos/boot/menu.ipxe 
#!ipxe
set base http://lxdev01.devops.test/centos/boot
kernel ${base}/images/pxeboot/vmlinuz initrd=initrd.img inst.repo=${base} inst.text inst.ks=http://lxdev01.devops.test/kickstart/base.cfg
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


# Kickstarter

Cf. [Kickstart Documentation](http://pykickstart.readthedocs.io/en/latest/kickstart-docs.html), [Anaconda Logging](https://fedoraproject.org/wiki/Anaconda/Logging)

Kickstart provides method to **automate** the installation of CentOS. 

The **kickstart file** contains answers for the Anaconda installer program:

* Simple text file, containing a list of items, each identified by a keyword.
* Omitting required installation items prompts the user for an interactive answer.

Simple kickstart file:

```bash
## Common Section ##

install                       # install a fresh system
url --url="http://...."       #  from a remote server over HTTP
reboot                        # reboot automatically

keyboard --vckeymap=us        # keyboard layout
lang en_US.UTF-8              # system language
timezone Europe/Berlin        # system timezone

# dummy accounts for a test environment
auth --enableshadow --passalgo=sha512
rootpw --plaintext root
user --name=devops --password=devops --plaintext

# enable DHPC, no IPv6
network  --bootproto=dhcp --noipv6

zerombr                      # initialize invalid partition table
ignoredisk --only-use=vda    # ingnore disks except of vda
clearpart --initlabel --all  # overwrite all partitions
# partition layout and file-systems
part /     --ondisk=vda --asprimary --fstype=ext4 --size=8192
part /var  --ondisk=vda             --fstype=ext4 --size=8192
part /tmp  --ondisk=vda             --fstype=ext4 --size=8192 --maxsize=20480 --grow
part /srv  --ondisk=vda --asprimary --fstype=ext4 --size=10240                --grow
```

## Package Section

Lists the packages you would like to install:

* `%packages` begins the section listing packages, must end with the `%end` 
* Leading *dash* excludes packages//groups from the installation

Minimal base system:

```
## Package Section ##

%packages --nobase --excludedocs
@core --nodefaults
%end
```

Deploy a configuration management e.g. Chef:


```bash
## This repository should host the chef packages from chef.io
repo --name=site --baseurl="http://lxdev01.devops.test/repo"

## Add the client package to be installed
%packages
...
chef
%end
```

## Post Install Section

Add the FQDN to `/etc/hostname`:

```bash
%post --log=/var/log/post-install.log
echo "Write hostname to /etc/hostname"
/bin/hostname -f > /etc/hostname
%end
```

Install custom SSH keys for the root user:

```bash
%post --log=/var/log/post-install.log
echo "Install SSH keys for the root user"
mkdir -m 0700 /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
  ..........KEYS...........
EOF
chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh/
%end
```

