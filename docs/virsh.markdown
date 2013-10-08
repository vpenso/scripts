
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

The [virsh-config][12] scripts creates simple libvirt XML configuration file for virtual machines. Use a MAC- and IP-address pair from the `virsh-nat-bridge`, write a configuration file, and start a new virtual machine instance:

    » virsh-nat-bridge lookup lxdev02
    lxdev02.devops.test 10.1.1.25 02:FF:0A:0A:06:19
    » virsh-config -n debian64-7.1.0-basic -m 02:FF:0A:0A:06:19 -d disk.0 libvirt_instance.xml
    » virsh create libvirt_instance.xml
    […]


[10]: http://wiki.libvirt.org/page/Networking
[11]: https://raw.github.com/vpenso/scripts/master/bin/virsh-nat-bridge
[12]: ../bin/virsh-config
[13]: http://libvirt.org/formatdomain.html
