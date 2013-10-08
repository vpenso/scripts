
## virsh-nat-bridge

Read about [network configuration][10] of libvirt before you continue. 

The [virsh-nat-bridge][11] scripts create a libvirt network configuration called *nat_bridge*. It deploys a bridge `nbr0` operating as a NAT to connect local virtual machine instances to the external network:    

    » virsh-nat-bridge status 
    Network [nat_bridge] not configured.
    » virsh-nat-bridge config 
    <network> 
      <name>nat_bridge</name>
      <bridge name="nbr0" />
      <forward mode="nat"/>
      <domain name="devops.test"/>
      <dns>
    […]
    » virsh-nat-bridge start
    » virsh-nat-bridge status
    Name            nat_bridge
    UUID            64d3fb4a-aae2-6e53-6ecb-64f03f30f03c
    Active:         yes
    Persistent:     yes
    Autostart:      yes
    Bridge:         nbr0

The configuration contains a pre-defined set of DNS host names with associated IP and MAC-addresses. Print a listing of all defined host names with the `list` command.

    » virsh-nat-bridge list
    lxdns01.devops.test 10.1.1.5
    lxdns02.devops.test 10.1.1.6
    lxcm01.devops.test 10.1.1.7
    lxcm02.devops.test 10.1.1.8
    lxcc01.devops.test 10.1.1.9
    lxcc02.devops.test 10.1.1.10

## virsh-config

The [virsh-config][12] scripts creates simple libvirt [XML configuration][13] files for virtual machines. Use a MAC- and IP-address pair from the `virsh-nat-bridge`, write a configuration file, and start a new virtual machine instance:

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
    » virsh-config -n debian64-7.1.0-basic -m 02:FF:0A:0A:06:19 -d disk.0 libvirt_instance.xml
    » virsh create libvirt_instance.xml
    […]

## virsh-instance

Create and recycle virtual machine images with [virsh-instance][14]. This command locates virtual machine images using the environment variable **VM_IMAGE_PATH**. Create a new image with the command **install**:

    » export VM_IMAGE_PATH=/srv/vms/images
    » virsh-instance install debian64-7.1.0-basic $VM_IMAGE_PATH/debian64-7.1.0-basic/disk.img
    […]

The command above uses _virt-install_ and the official Debian FTP server by default. Use the option `--location URL` for an alternative installation source, or the option `--cdrom PATH` to install from an ISO.

    » virsh-instance install --cdrom /srv/isos/debian-7.1.0-amd64-netinst.iso […]
    » virt-viewer debian64-7.1.0-basic

Connect to the console with _virt-viewer_ for example. The command **list** will print all available sub-directories with disk images inside (files prefixed with `.img`):

    » virsh-instance list
    Images in /srv/vms/images:
      debian64-7.1.0-basic
      debian64-7.0.0-chef-client-0.10.12
      debian64-7.1.0-chef-client-0.10.12
      ubuntu64-12.04-desktop
      debian64-7.rc1-basic
      debian64-7.0.0-storage
      debian64-7.rc1-chef-client-0.10.12
      debian64-6.0.5-chef-client-0.10.10

The commands **clone** and **shadow** use an existing virtual machine image to deploy a new virtual machine instance:

    » export VM_INSTANCE_PATH=/srv/vms/instances
    » virsh-instance shadow debian64-7.1.0-chef-client-0.10.12 lxdev01.devops.test
    /srv/vms/instances/lxdev01.devops.test/libvirt_instance.xml written.
    /srv/vms/instances/lxdev01.devops.test/ssh_config written.
    Domain lxdev01.devops.test defined from /srv/vms/instances/lxdev01.devops.test/libvirt_instance.xml
    Domain lxdev01.devops.test started
    Shadow create in /srv/vms/instances/lxdev01.devops.test
    » cd /srv/vms/instances/lxdev01.devops.test
    » ls
    disk.img  keys/  libvirt_instance.xml  ssh_config
    » ssh-exec /bin/bash
    devops@lxdev01:~$
    […]
    » virsh-instance remove lxdev01.devops.test
    Domain lxdev01.devops.test is being shutdown
    Domain lxdev01.devops.test has been undefined

Virtual machine instances will be located in a path defined by the environment variable **VM_INSTANCE_PATH**. Both commands deploy the virtual machine persistently and create a XML configuration file using [virsh-nat-bridge][11] and [virsh-config][12]. Furthermore a default SSH configuration is created using [ssh-instance][15] (more details in the documentation for the [SSH tools][16] ). 



[10]: http://wiki.libvirt.org/page/Networking
[11]: ../bin/virsh-nat-bridge
[12]: ../bin/virsh-config
[13]: http://libvirt.org/formatdomain.html
[14]: ../bin/virsh-instance
[15]: ../ssh-instance
[16]: ssh.markdown
