**Guide to use virtual machines for development and testing on the local workstation**, based on tools available in all modern Linux distributions: [KVM](http://www.linux-kvm.org), [Libvirt](http://libvirt.org/), [SSH](http://www.openssh.com/), [Rsync](http://rsync.samba.org/i), [SSHfs](http://fuse.sourceforge.net/sshfs.html), and [Chef](https://wiki.opscode.com).

# Libvirt 

Deployment and configuration of [libvirt](http://libvirt.org/docs.html) on a workstation

```bash
# related packages in Debian
>>> sudo apt-get -y install libvirt-daemon-system libvirt-dev libvirt-clients \
                            virt-manager virt-viewer virt-top virtinst qemu-utils \ 
                            qemu-kvm libguestfs-tools ovmf
>>> sudo dnf -y install @virtualization          # related packages in Fedora
# enable your user account to manage virtual machines
>>> sudo usermod -a -G libvirt,kvm `id -un`      # re-login to activate these group rights
# configure the Libvirt service to run with your user ID, e.g.:
>>> sudo grep -e '^user' -e '^group' /etc/libvirt/qemu.conf
user = "vpenso"
group = "vpenso"
>>> sudo systemctl restart libvirtd
```

Connect with the libvirt service ↴ [var/aliases/libvirt.sh](../var/aliases/libvirt.sh)

```
virsh -c qemu:///session […]                     # connect with user session
virsh -c qemu:///system […]                      # connect with system session
export LIBVIRT_DEFAULT_URI=qemu:///system        # define the default connection
virsh -c qemu+ssh://root@lxhvs01.devops.test/system list
                                                 # connect to a remote session
virt-manager -c qemu+ssh://root@lxhvs01.devops.test/system
virt-top -c qemu+ssh://root@lxhvs01.devops.test/system
```

## Network

↴ [virsh-nat-bridge][virsh-nat-bridge] creates a configuration **nat_bridge**:

* NAT Bridge `nbr0` connects virtual machine instances to the external network
* Default network **10.1.1.0/24**, MAC-addresses prefix **02:FF**
* Domain is called **devops.test**:

```bash
virsh-nat-bridge config                             # show XML configuration file
virsh-nat-bridge start                              # sue this configuration
virsh net-list                                      # list networks
brctl show nbr0                                     # show bridge state
virsh-nat-bridge --network 192.168.0 --bridge br0 --nodes node1,node2[…]
                                                    # configure custom NAT bridge
```

↴ [virsh-config][virsh-config] creates custom virtual machine [XML configuration](http://libvirt.org/formatdomain.html)

```bash
virsh-nat-bridge list                                    # list DNS configuration
virsh-nat-bridge lookup <name>                           # show hostname, IP- and MAC-address triplet
virsh-config -n <name> -m <mac> […] libvirt_instance.xml # create XML configuration
virsh create|define libvirt_instance.xml                 # start/define VM instance
```

## Login

Login with ↴ [ssh-instance][ssh-instance] password-less SSH configuration

* Uses `instance` as target hostname, and `devops` as login
* Requires an pre-generated SSH key-pair without password lock

```bash
cd $VM_IMAGE_PATH/$name                    
mkdir keys ; ssh-keygen -q -t rsa -b 2048 -N '' -f keys/id_rsa
                                            # password-less SSH key-pair
ssh-instance -i keys/id_rsa 10.1.1.26       # custom SSH configuration written to ssh_config
ssh -F ssh_config instance -C […]
                                            # use custom SSH configuration to connect 
```

↴ [ssh-exec][ssh-exec] and ↴ [ssh-sync][ssh-sync] use `ssh_config` if present in the working directory:

```bash
ssh-exec                                    # login as devops
ssh-exec -s                                 # login as devops, and sudo to root shell
ssh-exec -r                                 # login as root
ssh-exec […]                                # execute command as devops
ssh-sync <spath> :<dpath>                   # rsync local path into VM instance
ssh-sync -r :<spath> <dpath>                # rsync from VM instance to local path as root
```

## Images

Create a virtual machine image:

```bash 
## required environment variables
>>> env | grep VM_  
VM_IMAGE_PATH=/srv/vms/images
VM_INSTANCE_PATH=/srv/vms/instances
VM_DOMAIN=devops.test
## create a directory for the virtual machine image, e.g.:
>>> mkdir -p $VM_IMAGE_PATH/debian9 && cd $VM_IMAGE_PATH/debian9
## Install Centos 7 from a mirror
>>> virt-install --name centos7 --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
               --disk path=disk.img,size=100,format=qcow2,sparse=true,bus=virtio \
               --graphics none --console pty,target_type=serial --extra-args 'console=ttyS0,115200n8 serial' \
               --location 'http://mirror.centos.org/centos-7/7.3.1611/os/x86_64/'
## Install Debian 9 from a mirror
>>> virt-install --name debian9 --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --graphics none --console pty,target_type=serial --extra-args 'console=ttyS0,115200n8 serial' \
             --location http://deb.debian.org/debian/dists/stable/main/installer-amd64/
## Install Archlinux with an ISO image downloaded from https://www.archlinux.org/download/
>>> virt-install --name arch --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --cdrom /tmp/archlinux-2017.07.01-x86_64.iso
```

Set the following configuration options during installation:

* Keymap: English
* Host name is the distribution nick-name (e.g squeeze or lucid)
* Domain name `devops.test`
* Single primary partition for `/` (no SWAP).
* Use the password "root" for the `root` account
* Create a user `devops` with password "devops"
* Only standard system, no desktop environment (unless really needed), no services, no development environment, no editor, nothing except a bootable Linux.

Libvirt and SSH configuration for the virtual machine image:

```bash
# create a defaultc configuration for LibVirt
>>> virsh-config
Domain name lxdev01.devops.test with MAC-address 02:FF:0A:0A:06:1C
Using disk image with path: /srv/vms/images/debian9/disk.img
Libvirt configuration: /srv/vms/images/debian9/libvirt_instance.xml
>>> virsh-nat-bridge lookup lxdev01     
lxdev01.devops.test 10.1.1.28 02:FF:0A:0A:06:1C
# start the virtual machine instance
>>> virsh create libvirt_instance.xml
# generate an SSH configuration
>>> ssh-instance   
Password-less SSH key-pair create in /srv/vms/images/debian9/keys
SSH configuration: /srv/vms/images/debian9/ssh_config
```

Configure the virtual machine image:

```bash
# install required packages on Debian Stretch
>>> ssh-exec "su -lc 'apt install rsync sudo'"  # login as devops, execute command as root user
# install required packages on CentOS
>>> ssh-exec -r 'yum install rsync sudo'
# Sudo configuration for user devops
>>> ssh-exec "su -lc 'echo \"devops ALL = NOPASSWD: ALL\" > /etc/sudoers.d/devops'"
# paths for the SSH key
>>> ssh-exec 'mkdir -p -m 0700 /home/devops/.ssh ; sudo mkdir -p -m 0700 /root/.ssh'
# deploy the SSH key for password-less login
>>> ssh-sync keys/id_rsa.pub :.ssh/authorized_keys
>>> ssh-exec -s 'cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys'
```

## Instances

Virtual machine instance [lifecycle](http://wiki.libvirt.org/page/VM_lifecycle):

```bash
vm (c)reate|(l)ist|(s)tart                  # alias to manage virtual machine life cycle
   (d)efine|(u)ndefine
   (r)emove|s(h)utdown|(k)ill
virsh-instance list                         # list template images
virsh-instance clone <image> <name>         # start copied instance from image
virsh-instance shadow <image> <name>        # start shadow instance from image
virsh-instance remove <name>                # undefine/stop instance
```

### Start

Start a **virtual machine instance** with the name `lxdev03`:

```bash
## list the virtual machine images
>>> virsh-instance list            
Images in /srv/vms/images:
  debian9
## start a virtual machine instance
>>> virsh-instance shadow debian9 lxdev03
Domain name lxdev03.devops.test with MAC-address 02:FF:0A:0A:06:1E
Using disk image with path: /srv/vms/instances/lxdev03.devops.test/disk.img
Libvirt configuration: /srv/vms/instances/lxdev03.devops.test/libvirt_instance.xml
SSH configuration: /srv/vms/instances/lxdev03.devops.test/ssh_config
Domain lxdev03.devops.test defined from /srv/vms/instances/lxdev03.devops.test/libvirt_instance.xml
Domain lxdev03.devops.test started
```

### Cycle

Resources create for the virtual machine instance:

```bash
## directory of the VM instance
>>> virsh-instance path lxdev03
/srv/vms/instances/lxdev03.devops.test
## contents
>>> tree $(virsh-instance path lxdev03)       
/srv/vms/instances/lxdev03.devops.test
├── disk.img
├── keys
│   ├── id_rsa
│   └── id_rsa.pub
├── libvirt_instance.xml
└── ssh_config
## differential disk image (shadow image)
>>> ls -lh $(virsh-instance path lxdev03)/disk.img
-rw-r--r--. 1 root root 3.0M Oct 10 14:50 /srv/vms/instances/lxdev03.devops.test/disk.img
## delete the VM instance
>>> virsh-instance remove lxdev03
Domain lxdev03.devops.test destroyed
Domain lxdev03.devops.test has been undefined
```

### Login

```bash
## login as root user
>>> virsh-instance login lxdev03
## execute a command in the VM instance 
>>> virsh-instance exec lxdev03 'ip a | grep inet'
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet 10.1.1.30/24 brd 10.1.1.255 scope global ens3
    inet6 fe80::ff:aff:fe0a:61e/64 scope link 
## rsync a file into the virtual machine
>>> virsh-instance sync lxdev03 /bin/bash :/tmp
sending incremental file list
bash

sent 1,137,020 bytes  received 35 bytes  2,274,110.00 bytes/sec
total size is 1,136,624  speedup is 1.00
```



### Management

* **Transient** "undefined" virtual machines exist until they are shutdown
* **Persistent** virtual machines have a permanent "defined" configuration

```bash
virsh list --all                            # list vm insatnces in all states
virsh shutdown|destroy <name|id>            # graceful halt, force immediate stop
virsh dumpxml <name|id>                     # show instance XML configuration
virsh define <xml_config>                   # create persistent configuration
virsh undefine <name|id>                    # remove persistent configuration
virt-df                                     # list file-systems of VM instances
virt-ls -l -d <name> <path> [<path>]        # list files on VM instance device
```

# Provisioning

This section introduces methods to configured nodes using the [Chef](https://wiki.opscode.com) Configuration Management System. It is assumed that Chef cookbooks and roles are available in the local file-system (by default in `~/chef/`). The ↴[chef-remote][chef-remote] script uploads these to a define remote node and executes `chef-solo` (depends on ↴[ssh-exec][ssh-exec] and ↴[ssh-sync][ssh-sync]) on the targeted system.

    » ssh-exec -r 'apt install chef rsync'
    […]
    » chef-remote cookbook sys
    Cookbook 'sys' added
    » chef-remote role ~/chef/cookbooks/sys/tests/roles/sys_apt_test.rb
    Role [sys_apt_test.rb] added.
    […]
    » chef-remote --run-list "role[sys_apt_test]" solo
    […]

Make sure that Chef and Rsync are installed on the remote node. Furthermore it is required that the login user can execute Chef with root privileges. The first execution of `chef-remote` generates a scaffolding configuration structure in the working directory:

    ├── chef_attributes.json
    ├── chef_config.rb
    ├── cookbooks
    │   └── sys -> ~/chef/cookbooks/sys
    ├── data-bags
    └── roles
        └── sys_apt_test.rb -> ~/chef/cookbooks/sys/tests/roles/sys_apt_test.rb

All files and directories will by synchronized with the target node when the `solo` command will be invoked. The configuration is stored to `/var/tmp/chef` on the node. Defined an alternative path with `-d path`. The `chef_config.rb` file contains the Chef configuration used to execute `chef-solo`. On interesting parameter to adjust is `log_level` which support :fatal, :warn, :info, and :debug.

The file `chef_attributes.json` contains the node-specific configuration formated in JSON: 

    { 
      "run_list": [ 
        "recipe[sys::time]",
        "recipe[sys::resolv]",
        "role[sys_apt_test]"
      ],
      "sys": {
        "time": {
          "zone": "Europe/Berlin"
        },
        "resolv": {
          "nameserver": [ "10.1.1.1" ],
          "search": "devops.test"
        }
      } 
    }

It defines the `run_list` of recipes and roles to be applied, also. By default the file contains an empty run-list and no attributes. Add a single recipe or role to the run-list with option `-r role|recipe` like in the example from the previous paragraph.

`cookbook` links to existing cookbooks found in `~/chef/cookbooks` or `~/chef/site-cookbooks`. 

    » chef-remote cookbook apt ntp resolv
    Cookbook 'apt' added
    Cookbook 'ntp' added
    Cookbook 'resolv' added

The command `role` adds a link to a file containing a Chef role. Alternatively copy cookbooks and roles into the corresponding directories. Make sure to checkout the required version of a cookbook beforehand.

# Examples

In this example we will add some very simple additional functionality to the [sys][sys] Chef cookbooks. Beforehand clone the cookbook repository:

    » mkdir -p ~/chef/cookbooks 
    » git clone https://github.com/GSI-HPC/sys-chef-cookbook.git ~/chef/cookbook/sys

Setup a basic virtual machine instance and prepare Chef. Since we will extend the `sys::apt` recipe, add the test role, and deploy it to verify its functionality: 

    » virsh-instance shadow debian64-7.2.0-chef-client-0.10.12 lxdev01.devops.test
    […]
    » cd /srv/vms/instances/lxdev01.devops.test
    » chef-remote cookbook sys
    Cookbook 'sys' added
    » chef-remote role ~/chef/cookbooks/sys/tests/roles/sys_apt_test.rb   
    Role [sys_apt_test.rb] added.
    » chef-remote -r "role[sys_apt_test]" solo
    […]
    [2013-11-19T15:12:55+01:00] INFO: Chef Run complete in 0.174789226 seconds
    [2013-11-19T15:12:55+01:00] INFO: Running report handlers
    [2013-11-19T15:12:55+01:00] INFO: Report handlers complete

Development starts with extending the test role with attributes covering the functionality in development. 

    […]
    default_attributes(
      "sys" => {
        "apt" => {
          […]
          "packages" => [
            "build-essential",
            "psutils",
            "dnsutils",
            "less"
          ],
    […]

Furthermore the _sys.apt.package_ is included in `attributes/apt.rb` and following linse of code are added to `recipes/apt.rb`.

```{.ruby}
# Install additional packages defined by attribute
unless node.sys.apt.packages.empty?
  node.sys.apt.packages.each do |pkg|
    package pkg
  end
end
```

Execute the _chef-remote_ to test the new developments. Then start a new virtual machine instance and verify if everything works from scratch:

    » chef-remote solo
    […]
    [2013-11-19T15:23:30+01:00] INFO: package[build-essential] installed version 11.5
    [2013-11-19T15:23:36+01:00] INFO: package[psutils] installed version 1.17.dfsg-1
    [2013-11-19T15:23:53+01:00] INFO: package[dnsutils] installed version 1:9.8.4.dfsg.P1-6+nmu2+deb7u1
    [2013-11-19T15:23:58+01:00] INFO: package[less] installed version 444-4
    [2013-11-19T15:23:58+01:00] INFO: Chef Run complete in 123.672484067 seconds
    [2013-11-19T15:23:58+01:00] INFO: Running report handlers
    [2013-11-19T15:23:58+01:00] INFO: Report handlers complete
    » virsh-instance shadow debian64-7.2.0-chef-client-0.10.12 lxdev01.devops.test
    […]
    » chef-remote solo
    […]
    » virsh-instance remove lxdev01.devops.test
    Domain lxdev01.devops.test is being shutdown
    Domain lxdev01.devops.test has been undefined
    » cd ; rm -rf /srv/vms/instances/lxdev01.devops.test

Remove all development artifacts when finished.










[virsh-nat-bridge]: ../bin/virsh-nat-bridge
[virsh-instance]: ../bin/virsh-instance
[virsh-config]: ../bin/virsh-config
[ssh-instance]: ../bin/ssh-instance
[ssh-exec]: ../bin/ssh-exec
[ssh-sync]: ../bin/ssh-sync
[ssh-fs]: ../bin/ssh-fs
[chef-remote]: ./bin/chef-remote
[sys]: https://github.com/GSI-HPC/sys-chef-cookbook
