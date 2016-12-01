**Guide to use virtual machines for development and testing on the local workstation**, based on tools available in all modern Linux distributions: [KVM](http://www.linux-kvm.org), [Libvirt](http://libvirt.org/), [SSH](http://www.openssh.com/), [Rsync](http://rsync.samba.org/i), [SSHfs](http://fuse.sourceforge.net/sshfs.html), and [Chef](https://wiki.opscode.com).

# Libvirt 

Deployment and configuration of [libvirt](http://libvirt.org/docs.html) on a workstation

```bash
sudo apt-get -y install libvirt-bin virt-manager virt-viewer virt-top virtinst qemu-utils qemu-kvm libguestfs-tools
                                                 # related packages in Debian
sudo dnf -y group install with-optional virtualization
                                                 # related packages in Fedora
sudo usermod -a -G libvirt,kvm `id -un`          # enable your user account to manage virtual machines
                                                 # re-login to activate these group rights
sudo grep '^user =' /etc/libvirt/qemu.conf       # should contain $USER
sudo systemctl restart libvirtd && sudo systemctl enable libvirtd
                                                 # libvirtd service
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

## Templates

↴ [virsh-instance][virsh-instance] manages virtual machine template images and instance: 

```bash
$VM_IMAGE_PATH                                   # path to the VM template images (default /srv/vms/images)
$VM_INSTANCE_PATH                                # path to the VM instances (default /srv/vms/instances)
name=debian8                                     # select a name for the VM template, e.g. "debian8"
virsh-instance install $name  $VM_IMAGE_PATH/$name/disk.img
                                                 # install debian stable the offical FTP server into qcow2 image
virsh-instance install --location http://ftp.de.debian.org/debian/dists/stable/main/installer-i386 […]
                                                 # select a custom mirror
virsh-instance install --cdrom <path_to_iso> […] # install from a ISO image
virt-viewer $name                                # connect to VNC of the installing template image
virsh undefine $name                             # remove template virtial machine after the installation is finished
```

Set the following configuration options during installation:

* Keymap: English
* Host name is the distribution nick-name (e.g squeeze or lucid)
* Domain name `devops.test`
* Single disk partition, no SWAP!
* Username is `devops`
* Only standard system, no desktop environment (unless really needed), no services, no development environment, no editor, nothing except a bootable Linux.


```bash
virsh-config -v -n $name -m 02:FF:0A:0A:06:1A $VM_IMAGE_PATH/$name/libvirt_instance.xml
                                                  # create a configuration for the virtual machine
virsh create $VM_IMAGE_PATH/$name/libvirt_instance.xml
                                                  # start the virtual machine to customize the installation
```

Template image customization:

```bash
apt update && apt install openssh-server sudo rsync chef haveged   # basic services
echo "devops ALL = NOPASSWD: ALL" > /etc/sudoers.d/devops          # password-less sudo for the devops user
## -- Configure systemd, NTP, PAM, etc if required -- # 
```

Other tools providing similar functionality:

```bash 
virt-install --ram 2048 --name install --graphics vnc \
             --os-type linux --virt-type kvm \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --location http://ftp.de.debian.org/debian/dists/stable/main/installer-amd64/
virt-install -c qemu+ssh://root@lxhvs01.devops.test/system --noautoconsole […]
                                                 #  no VNC for remote servers
virt-install --bridge br124 --mac 02:FF:0A:0A:18:6F --boot network […]
                                                 # network boot
virt-builder -l                                  # list os templates
virt-builder --print-cache | grep cached         # list cached os templates
ls -1 ~/.cache/virt-builder/                     # list cache directory
virt-builder --root-password password:root -o $VM_INSTANCE_PATH/lxdev01.devops.test/disk.img debian-8
                                                 # build a new VM insatnce from os template
```

## Instances

Virtual machine instance [lifecycle](http://wiki.libvirt.org/page/VM_lifecycle):

* **Transient** "undefined" virtual machines exist until they are shutdown
* **Persistent** virtual machines have a permanent "defined" configuration

```bash
virsh list --all                            # list vm insatnces in all states
virsh shutdown <name|id>                    # graceful halt
virsh destroy <name|id>                     # force immediate stop
virsh dumpxml <name|id>                     # show instance XML configuration
virsh undefine <name|id>                    # remove persistent configuration
vm (c)reate|(l)ist|(s)tart                  # alias to manage virtual machine life cycle
   (d)efine|(u)ndefine
   (r)emove|s(h)utdown|(k)ill
```

### Login

↴ [ssh-instance][ssh-instance] creates SSH configuration for password-less

* Uses `instance` as target hostname, and `devops` as login
* Requires an pre-generated SSH key-pair without password lock

```bash
cd $VM_IMAGE_PATH/$name                    
ssh-keygen -q -t rsa -b 2048 -N '' -f keys/id_rsa
                                            # password-less SSH key-pair
ssh-instance -i keys/id_rsa 10.1.1.26       # custom SSH configuration written to ssh_config
ssh -F ssh_config instance -C […]
                                            # use custom SSH configuration to connect 
## -- Enable password-less login to the VM insatnce -- ## 
ssh-exec "su -lc 'apt install rsync sudo'"
ssh-exec "su -lc 'echo \"devops ALL = NOPASSWD: ALL\" > /etc/sudoers.d/devops'"
ssh-exec 'mkdir -p -m 0700 /home/devops/.ssh ; sudo mkdir -p -m 0700 /root/.ssh'
ssh-sync keys/id_rsa.pub :.ssh/authorized_keys
ssh-exec -s 'cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys'
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

Mount the root file-system of the virtual machine instance with ↴ [ssh-fs][ssh-fs]

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
