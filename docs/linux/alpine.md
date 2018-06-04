# Alpine Linux

This example uses virtual machines setup with vm-tools:

<https://github.com/vpenso/vm-tools>

Get the latest Alpine Linux ISO:

<https://alpinelinux.org/downloads/>

```bash
mkdir -p $VM_IMAGE_PATH/alpine && cd $VM_IMAGE_PATH/alpine
wget -O alpine.iso http://dl-cdn.alpinelinux.org/alpine/v3.7/releases/x86_64/alpine-standard-3.7.0-x86_64.iso
virt-install --name alpine --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio --cdrom alpine.iso
```

Login as user root and execute `setup-alpine`, for most dialog just continue with enter, except:

* Select keyboard layout `us`, variant `us`
* Hostname `alpine`
* Find fastest mirror with `f`
* Disk device `vda` use as `sys`

Reboot! Make sure an SSH service is running and the `devops` user exists:

```bash
apk add bash openssh sudo rsync vim
rc-update add sshd && rc-service sshd start
adduser -h /home/devops devops
poweroff
```

Customize the VM image:

```bash
virsh-config --vnc && virsh create libvirt_instance.xml
ssh-config-instance
# customize the VM image
ssh-instance "su -lc 'echo \"devops ALL = NOPASSWD: ALL\" > /etc/sudoers.d/devops'"
ssh-instance 'mkdir -p -m 0700 /home/devops/.ssh ; sudo mkdir -p -m 0700 /root/.ssh'
rsync-instance keys/id_rsa.pub :.ssh/authorized_keys
ssh-instance -s 'cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys'
ssh-instance -s 'poweroff'
```

Start a VM instance:

```bash
vm shadow alpine lxdev01
vm login lxdev01 -r
```

## Usage

<https://wiki.alpinelinux.org/wiki/>

Packages:

```bash
/etc/apk/repositories              # list of repositories
apk update                         # update repo metadata
apk search -v <package>            # search a package
apk info <package>                 # package stats
apk add <package>...               # install package
apk del <package>...               # remove package
apk upgrade                        # upgrade all packages
apk -vv info|sort                  # alphabetical list of installed packages
```

Services (Init):

```bash
rc-status                          # running service
rc-status -s                       # all service
# enable/disable service
rc-update add <service> [<runlevel>]
rc-update del <service> [<runlevel>]
# start/stop service
rc-service <service> start|stop|restart
# power cycle
reboot
poweroff
```

### Work Environment

```bash
# enable ACPI support
rc-update add acpid
# install a terminal
apk add rxvt-unicode
# install a window manager
apk add i3wm-gaps i3status
# install a display server
setup-xorg-base
# install tool-chain
apk add firefox git
```

```bash
# start the GUI
xinit /usr/bin/i3
# screen resolution
xrandr --output qxl-0 --mode 1920x1080
```



