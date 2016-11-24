Fully Automated Installation → [FAI](http://fai-project.org/)

* System to automate the installation of a Linux based operating system using a pre-defined → [configuration space](http://fai-project.org/fai-guide/#_a_id_c3_a_the_configuration_space_and_its_subdirectories)  
* FAI boots a live system over the network into the memory of the node and follows a defined list of → [tasks](http://fai-project.org/fai-guide/#tasks) to install on the local storage 

Basic FAI server deployment:

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

Stand alone ISO CD images for off-line deployment on target node:

```bash
>>> fai-mirror -c LINUX,AMD64,FAIBASE,DEBIAN,GRUB_PC -v /srv/fai/mirror | tee /var/log/fai-mirror.log
                                                 # Create a package mirror for a FAI CD
>>> tree /srv/fai/mirror/                        # mirror package tree 
>>> fai-make-nfsroot -l
>>> fai-cd -m /srv/fai/mirror/ /srv/http/fai.iso # create a stand alone FAI CD for offline deployment
```

## Configuration

Custom FAI configuration including a configuration space, an NFS root directory for the live system and the boot configuration:

```bash
>>> FAI_CONFIG=/srv/devops                      # path to the custom FAI configuration
>>> mkdir -p $FAI_CONFIG/{config,nfsroot,tftp,nfsroot-hooks} 
>>> cp -a /usr/share/doc/fai-doc/examples/simple/* $FAI_CONFIG/config && cp -r /etc/fai/* $FAI_CONFIG/
                                                # copy the default configuration
>>> grep devops $FAI_CONFIG/nfsroot.conf        # adjust the configuration to custom path
NFSROOT=/srv/devops/nfsroot
TFTPROOT=/srv/devops/tftp
NFSROOT_HOOKS=/srv/devops/nfsroot-hooks/
FAI_CONFIGDIR=/srv/devops/config
>>> fai-make-nfsroot -v -C $FAI_CONFIG          # build a basic NFS root
>>> cat $FAI_CONFIG/NFSROOT                     # packages installed into the NFS root
>>> fai-make-nfsroot -vk -C $FAI_CONFIG         # install additional packages after modifing the above file
```

### Classes

→ [The class concept](http://fai-project.org/fai-guide/#_a_id_classc_a_the_class_concept)  
→ [Defining classes](http://fai-project.org/fai-guide/#defining%20classes)

* Classes determine which configuration files to apply on a given node during installation
* Multiple nodes sharing the same configuration by having the same classes associated
* The order of the classes is important because it defines the priority of the classes from low to high
* Class names: Uppercase, no hyphen, hash, semicolon, dot, but may contain underscores and digits

```bash
ls -1 $FAI_CONFIGDIR/class/[0-9][0-9]*          # files defining classes
cat $FAI_CONFIGDIR/class/50-host-classes        # define classes depending on the host name
grep -H -oP '\b[A-Z0-9_]*[A-Z]+[A-Z0-9_]*\b' $FAI_CONFIGDIR/class/[0-9][0-9]* | cut -d: -f2 | sort | uniq
                                                # list all classes
ls -1 $FAI_CONFIGDIR/class/*.var                # files defining variables
ls -1 $FAI_CONFIGDIR/disk_config/ | grep  '^[A-Z0-9]*$'
                                                # storage configuration files
setup-storage -s -f $FAI_CONFIGDIR/disk_config/<class>
                                                # check the syntax of a storage configuration
ls -1 $FAI_CONFIGDIR/package_config/*.asc       # apt keys added during deployment
ls -1 $FAI_CONFIGDIR/package_config/ | grep  '^[A-Z0-9]*$'
                                                # package configuration files
install_packages -H                             # list of command supported in package configuration
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

→ [Dracut NFS](https://www.kernel.org/pub/linux/utils/boot/dracut/dracut.html#_nfs)  
→ [FAI Flags](http://fai-project.org/fai-guide/#_a_id_faiflags_a_fai_flags)  

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

## Installation


```bash
fai-class $FAI_CONFIGDIR /tmp/fai/FAI_CLASSES    # script used to extract class definition from configuration
/tmp/fai/fai.log                                 # common log information from the $FAI_NFSROOT/usr/sbin/fai 
source /tmp/fai/variables.log                    # load the FAI environment
setup-storage -d -f /var/lib/fai/config/disk_config/<class>
                                                 # execute storage configuration
/tmp/fai/format.log                              # log for the storage configuration
/target                                          # mount of the local file-systems
fai-do-scripts /var/lib/fai/config/scripts       
/tmp/fai/shell.lo`                               # common log for post-installation scripts
```
