**Guide to use virtual machines for development and testing on the local workstation**, based on tools available in all modern Linux distributions: [KVM](http://www.linux-kvm.org), [Libvirt](http://libvirt.org/), [SSH](http://www.openssh.com/), [Rsync](http://rsync.samba.org/i), [SSHfs](http://fuse.sourceforge.net/sshfs.html), and [Chef](https://wiki.opscode.com).

# Basics

Check if your CPU supports virtualization:

    » egrep --color '(vmx|svm)' /proc/cpuinfo

If the flags are missing enabled support for virtualization in the BIOS/EFI.

Required packages on **Debian**

    » sudo apt-get -y install libvirt-bin virt-manager virt-viewer \
       virt-top virtinst qemu-utils qemu-kvm
    […]

Installing the _dnsmasq_ package (as dependency of _libvirt-bin_) will start automatically an instance of a _dnsmasq_ daemon. Before you continue make sure to shut it down and disable it from the boot process.

    » sudo service dnsmasq stop
    » sudo update-rc.d dnsmasq disable

Required packages on **Fedora** (>=22)

    » dnf groupinfo virtualization 
    […]
    » sudo dnf -y group install with-optional virtualization
    » sudo systemctl start libvirtd && sudo systemctl enable libvirtd

Check with `lsmod` if the KVM modules are loaded:

    » lsmod | grep kvm
    […]


Enable your user account to manage virtual machines:

    » sudo usermod -a -G libvirt,kvm `id -un`

**Re-login to activate these group rights.** 

Configure **user** in `/etc/libvirt/qemu.conf` and restart the service:

    » sudo grep '^user =' /etc/libvirt/qemu.conf
    user = "vpenso"
    » sudo systemctl restart libvirtd && sudo systemctl status libvirtd

## Libvirt

Use the `--connect` or `-c` options for <kbd>virsh</kbd> to specify the libvirtd instance to connect to:

    » virsh --connect qemu:///system list
    […]
    » virsh -c qemu:///session list --all

The `//system` URI connect to a libvirtd running as root, while `//session` launches a user specific libvirtd instance with limitations in network connectivity. Define the default connection with:

    » export LIBVIRT_DEFAULT_URI=qemu:///system

→ [var/aliases/libvirt.sh](../var/aliases/libvirt.sh)

Connect to a remote libvirt instance (read the [URI Reference](http://libvirt.org/remote.html#Remote_URI_reference)):

    » virsh -c qemu+ssh://root@lxhvs01.devops.test/system list 

It is possible to use the connection option with most of the libvirt tools:

    » virt-manager -c qemu+ssh://root@lxhvs01.devops.test/system
    » virt-top -c qemu+ssh://root@lxhvs01.devops.test/system

## Virtual Machines

The <kbd>virt-install</kbd> program is used to install virtual machine images:

    » virt-install --ram 2048 --name install --graphics vnc \
       --os-type linux --virt-type kvm \
       --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
       --location http://ftp.de.debian.org/debian/dists/stable/main/installer-amd64/

The `--location` option defines a **remote source** holding the installation files like an official Debian FTP server. Alternatively install using an **ISO image as source** with option `--cdrom`. When installing on a remote server or for **unattended deployments** use option `--noautoconsole` to prevent automatic opening of a VNC connection.

    » virt-install -c qemu+ssh://root@lxhvs01.devops.test/system --noautoconsole […]

The **default location** for virtual machine images is `/var/lib/libvirt/images/`. Installation via PXE is enable with the option `--boot` network:

    » virt-install --bridge br124 --mac 02:FF:0A:0A:18:6F --boot network […]

## Mount Images

Use `qemu-nbd` (package "qemu-utils" in Debian) to mount a qcow2 virtual machine disk image (requires root):

1. Load the `nbd` (network block device) kernel module
2. Connect a qcow2 file as a network block device with `qemu-nbd -c dev path`
3. List all disk partitions with `fdisk -l dev`
4. `mount` the required partition
5. `chroot` (package _coreutils_) to work with the file-system namespace
6. `umount` partition
7. Disconnect the disk device `qemu-nbd -d dev`

Follow these steps:

    » modprobe nbd max_part=8
    » qemu-nbd --connect=/dev/nbd0 /srv/vms/images/debian32-7.2-basic/disk.img
    » fdisk /dev/nbd0 -l | grep ^/dev
    /dev/nbd0p1   *        2048    78125055    39061504   83  Linux
    » mount /dev/nbd0p1 /mnt
    » chroot /mnt
    […]
    » umount /mnt
    » qemu-nbd --disconnect /dev/nbd0
    /dev/nbd0 disconnected


## Life Cycle

Basically two types of virtual machines are distinguished. **Transient** "undefined" virtual machines exist until they are shutdown. **Persistent** virtual machines have a permanent "defined" configuration, and support for example automatic start on host reboot. Virtual machines installed with `virt-install` are defined by default. In order to **list** all defined virtual machines (including not running instances) use the option `--all`:

    » virsh list --all
     Id    Name                           State
    ----------------------------------------------------
     1     lxdev01.devops.test            running
     -     lxhvs01.devops.test            shut off

Use **shutdown** for a graceful halt of the virtual machine instance or **destroy** to force immediate stop. To remove a persistent virtual machine configuration from the system use **undefine**:

    » virsh shutdown lxhvs01.devops.test
    » virsh undefine lxhvs01.devops.test

Create a new virtual machine instance (define and start) from an existing image with `virt-install`. Copy the original image file and boot from the disk image with option `--boot hd`:

    » virt-install --ram=2048 --name lxdev02.devops.test --os-type=linux \
      --disk path=/var/lib/libvirt/lxdev02.devops.test.img,format=qcow2,bus=virtio \
      --graphics vnc --virt-type kvm --noautoconsole --boot hd
    » virsh list
     Id    Name                           State
     ----------------------------------------------------
      8     lxdev02.devops.test            running
    » virt-viewer 8

The libvirtd stores the XML configuration for defined virtual machine instances in `/etc/libvirt/qemu/`. Alternatively print the current configuration with the `dumpxml` command:

    » virsh dumpxml lxdev01.devops.test | head
    <domain type='kvm' id='8'>
      <name>lxdev01.devops.test</name>
      <uuid>591923d7-96db-89fe-0f35-95662662ae9b</uuid>
      <memory unit='KiB'>2097152</memory>
      <currentMemory unit='KiB'>2097152</currentMemory>
      <vcpu placement='static'>1</vcpu>
      <os>
        <type arch='x86_64' machine='pc-i440fx-1.4'>hvm</type>
        <boot dev='hd'/>
      </os>

Read [VM Lifecycle](http://wiki.libvirt.org/page/VM_lifecycle) for a in detail explanation.

# Network

For development it is recommended to use a host **internal network bridged to the external LAN using a NAT**. This allows communication between the local virtual machine instances, and at the same time protects these from external access as well as prevents accidental interference of local services with the LAN. 

The script ↴[virsh-nat-bridge][virsh-nat-bridge] helps you to setup a libvirt network configuration called **nat_bridge**. It deploys a bridge called `nbr0` operating as a NAT to connect local virtual machine instances to the external network.  Use **config** to print the default XML configuration passed to libvirt. The default network is **10.1.1.0/24** and MAC addresses are prefixed with **02:FF**. The internal domain is called **devops.test**:

    » virsh-nat-bridge config 
    <network> 
      <name>nat_bridge</name>
      <bridge name="nbr0" />
      <forward mode="nat"/>
      <domain name="devops.test"/>
      <dns>
    […]

The argument **start** will deploy the configuration and start the network:


    » virsh-nat-bridge start
    » virsh net-list 
     Name                 State      Autostart     Persistent
    ----------------------------------------------------------
     default              active     yes           yes
     nat_bridge           active     yes           yes
    » brctl show nbr0 
    bridge name     bridge id               STP enabled     interfaces
    nbr0            8000.525400001f4c       yes             nbr0-nic

The configuration contains a **pre-defined set of DNS host names with associated IP and MAC-addresses**.  Print a listing of all defined host names with the **list** command.

    » virsh-nat-bridge list
    lxdns01.devops.test 10.1.1.5
    lxdns02.devops.test 10.1.1.6
    lxcm01.devops.test 10.1.1.7
    lxcm02.devops.test 10.1.1.8
    lxcc01.devops.test 10.1.1.9
    lxcc02.devops.test 10.1.1.10
    […]
    » virsh-nat-bridge lookup lxdev03
    lxdev03.devops.test 10.1.1.26 02:FF:0A:0A:06:1A

Show the configuration for a single host with the **lookup** command. 

    » virsh-nat-bridge --network 192.168.0 --bridge br0 --nodes alice,bob […]


# Configuration 

The basic concept is to maintain a **dedicated directory for each node and its configuration files** (like the login credentials, or file for the configuration management). Below you can see an example directory listing:

    $ ls $VM_INSTANCE_PATH/lxdev01.devops.test
    chef_attributes.json  
    chef_config.rb  
    cookbooks/
    disk.img  
    keys/  
    libvirt_instance.xml
    libvirt_install.xml
    roles/
    ssh_config

The `VM_INSTANCE_PATH` environment variable defines the **base directory** used by ↴[virsh-instance][virsh-instance] to deploy virtual machines instances (by default `/srv/vms/instances`). The directory are called like the host name (FQDN) of the virtual machine instance. 

## Images

One of the advantages of using virtual machines is the convenience of cloning them as many times as needed. **It is recommended to maintain a set of basic virtual machine images used to clone new virtual machine instances from**. The environment variable `VM_IMAGE_PATH` is used by the `virsh-instance` command to locate these virtual machine images. 

Use the command **install** to create a new virtual machine images. Internally this script uses `virt-install` (as described above) to install Debian stable 64Bit.

    » export VM_IMAGE_PATH=/srv/vms/images
    » virsh-instance install debian64-8 $VM_IMAGE_PATH/debian64-8/disk.img
    […]
    » virsh-instance install \
        --location http://ftp.de.debian.org/debian/dists/stable/main/installer-i386
        debian32-7.2-basic $VM_IMAGE_PATH/debian32-7.2-basic/disk.img 
    […]
    » virsh-instance install --cdrom /srv/isos/debian-7.1-amd64-netinst.iso […]
    […]
    » virt-viewer debian64-7.1-basic

Installations from ISO CD images are enabled with option `--cdrom`. By default the disk image will have a maximum size of 40GB, overwrite this using the option `--disk-size`. **Connect to the console** with `virt-viewer` to proceed with the installation. While you follow the installation menu we propose to always create a minimal system configuration, which is the same across all images your create.

Set the following configuration options during installation:

* Keymap: English
* Host name is the distribution nick-name (e.g squeeze or lucid)
* Domain name `devops.test`
* Single disk partition, no SWAP!
* Username is `devops`
* Only standard system, no desktop environment (unless really needed), no services, no development environment, no editor, nothing except a bootable Linux.

Once the operating system is installed make sure to boot it another time to check if everything is working. Use a MAC- and IP-address pair from the `virsh-nat-bridge` and create a libvirt configuration with ↴[virsh-config][virsh-config]:

    […]
    » virsh undefine debian64-8
    » cd /srv/vms/images/debian64-8
    » virsh-config -n debian64-8 -m 02:FF:0A:0A:06:1A libvirt_instance.xml
    » virsh create libvirt_instance.xml
    […]

Customize your installation for example by installing packages like SSH, Sudo and Rsync:

    » apt update
    […]
    » apt install openssh-server sudo rsync chef haveged
    […]

Elevate the _devops_ user to be able to run all commands with Sudo:

    » echo "devops ALL = NOPASSWD: ALL" > /etc/sudoers.d/devops

Configure [systemd](systemd.md) basics for NTP, PAM, etc.

## Login

Enable password-less login using an SSH configuration file `ssh_config`. Defining the login account name (e.g. "devops"), the SSH key to use, and the node IP address:

    Host instance
      User devops
      HostName 10.1.1.26
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      IdentityFile /srv/vms/images/debian64-7.1-basic/keys/id_rsa

**Several scripts described below read `ssh_config` files present in their execution directory by default.** Thus the addressed remote node is automatically determined and the required login credentials used. By convention the _Host_ in the SSH configuration file needs to be called `instance`.

Use the script ↴[ssh-instance][ssh-instance] to create the SSH configuration files (targeting a host called "instance" by default). The option `-i path` points to the SSH key used for password-less login, followed by the instance IP-address.

    » cd /srv/vms/images/debian64-8
    […]
    » ssh-keygen -q -t rsa -b 2048 -N '' -f keys/id_rsa
    » ssh-instance -i keys/id_rsa 10.1.1.26 
    /srv/vms/images/debian64-8/ssh_config written.
    » ssh -F ssh_config instance -C […]

The scripts ↴[ssh-exec][ssh-exec] and ↴[ssh-sync][ssh-sync] are wrappers around the `ssh` and `rsync` commands. They automatically use an `ssh_config` file if it is present in the working directory:

    » ssh-exec "su -lc 'apt install rsync sudo'"
    » ssh-exec "su -lc 'echo \"devops ALL = NOPASSWD: ALL\" > /etc/sudoers.d/devops'"
    » ssh-exec 'mkdir -p -m 0700 /home/devops/.ssh ; sudo mkdir -p -m 0700 /root/.ssh'
    » ssh-sync keys/id_rsa.pub :.ssh/authorized_keys
    » ssh-exec -s 'cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys'


The three command above will install Rsync and Sudo (unless installed already), as well as deploy the SSH public key. Note that these scripts aren't limited to local virtual machines instances. It is possible to use password protected keys with an _ssh-agent_ and any remote node (not a virtual machine necessarily).

## Customization 

The ↴[virsh-config][virsh-config] scripts creates simple libvirt [XML configuration](http://libvirt.org/formatdomain.html) files for virtual machines. Use a MAC- and IP-address pair from the `virsh-nat-bridge`, write a configuration file, and start a new virtual machine instance:

    » virsh-nat-bridge lookup lxdev02
    lxdev02.devops.test 10.1.1.25 02:FF:0A:0A:06:19
    » virsh-config -h | grep '\-\-'
      -b,--bridge name
      -c,--vcpu num
      -D,--debug
      -d, --disks path[,path,...]
      -h,--help
      -m,--mac-address mac
      -M,--memory bytes
      -n,--name name
      -N,--net-boot
      -O,--overwrite
      -p,--vnc-port num
      -v,--vnc 
      --version
    » virsh-config -n debian64-7.1.0-basic -m 02:FF:0A:0A:06:19 […] libvirt_instance.xml
    » virsh create libvirt_instance.xml
    […]

# Instances

It is possible to start as many virtual machines instances as your hardware can sustain. Basically it's limited by memory. Before you start a virtual machine instance you need to select the host name to use.

    » virsh-nat-bridge lookup lxdev01
    lxdev01.devops.test 10.1.1.24 02:FF:0A:0A:06:18

The _virsh-instance_ command will **list** all available virtual machine images:

    » virsh-instance list
    Images in /srv/vms/images:
      debian64-7.1.0-basic
      debian64-7.0.0-chef-client-0.10.12
      debian64-7.1.0-chef-client-0.10.12
      debian64-7.rc1-basic
      debian64-7.0.0-storage

There are two different modes of creating a virtual machine instance, cloning and shadowing. Using the command **clone** will create an independent copy of the source virtual machine image, using potentially a lot of disk space. In contrast **shadow** will create a differentials disk image, thus saving local storage space. 

    » virsh-instance shadow debian64-7.1.0-chef-client-0.10.12 lxdev01.devops.test
    Overwrite /srv/vms/instances/lxdev01.devops.test? (Enter/Y/y to continue) 
    Overwrite /srv/vms/instances/lxdev01.devops.test/libvirt_instance.xml? (Enter/Y/y to continue) 
    /srv/vms/instances/lxdev01.devops.test/libvirt_instance.xml written.
    Overwrite /srv/vms/instances/lxdev01.devops.test/ssh_config? (Enter/Y/y to continue) 
    /srv/vms/instances/lxdev01.devops.test/ssh_config written.
    Domain lxdev01.devops.test defined from /srv/vms/instances/lxdev01.devops.test/libvirt_instance.xml
    Domain lxdev01.devops.test started
    Shadow create in /srv/vms/instances/lxdev01.devops.test

The libvirt and SSH configuration is created automatically:

    » cd /srv/vms/instances/lxdev01.devops.test
    » ls
    disk.img  keys/  libvirt_instance.xml  ssh_config
    » ssh-exec
    devops@lxdev01:~$
    […]
    » virsh-instance remove lxdev01.devops.test
    Domain lxdev01.devops.test is being shutdown
    Domain lxdev01.devops.test has been undefined

Use the command `remove` to drop the virtual machine instance. Note that this will stop and undefine the virtual machine instance, but not delete the corresponding file from *VM_INSTANCE_PATH*.

# Access

Once you have started a virtual machine instance, change to its directory and login with the [ssh-exec][ssh-exec] command. Unless when parameters are provided, the script will login with the **devops** account. You can use the `--sudo` option to login as devops and immediately switch user to become root:

    » cd /srv/vms/instances/lxfs01.devops.test
    » ssh-exec     
    devops@wheezy:~$
    » ssh-exec --sudo       
    root@wheezy:/home/devops#

In case you just want to execute a single command add parameters to `ssh-exec`:

    » ssh-exec -s ifconfig | grep HWaddr              
    eth0      Link encap:Ethernet  HWaddr 02:ff:0a:0a:06:1c

All parameters to the `ssh-exec` command will be executed as associated command lines using a login-shell inside the virtual machine. This means you can also execute interactive commands like:

    » ssh-exec -s passwd
    Enter new UNIX password: 
    Retype new UNIX password: 
    passwd: password updated successfully

# Sharing Data

The script ↴[ssh-sync][ssh-sync] wraps the Rsync command and allows differential synchronisation of files and directories:

    » ssh-sync /etc/hostname :/tmp
    […]
    » ssh-exec 'cat /tmp/hostname'
     depc307

Remote path need to be prefixed with colon, e.g. `:/absolute/remote/path`.

    » ssh-sync :/etc/network /tmp
    » ls /tmp/network               
    if-down.d/  if-post-down.d/  if-pre-up.d/  if-up.d/  interfaces  run/

Mount the root file-system of the virtual machine instance with ↴[ssh-fs][ssh-fs].

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
