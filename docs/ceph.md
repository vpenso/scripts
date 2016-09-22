
Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

```bash
NODES=lxmon01,lxfs[01-02]
nodeset-loop "virsh-instance -O shadow debian64-8 {}"
nodeset-loop 'virsh-instance exec {} " echo {} >/etc/hostname ; hostname {} ; hostname -f"'
# allow password-less ssh to all nodes...
virsh-instance sync lxmon01 keys/id_rsa :/home/devops/.ssh/
virsh-instance exec lxmon01 chown devops:devops /home/devops/.ssh/id_rsa
# Clean up...
nodeset-loop virsh-instance rm {}
rm -rf $VM_INSTANCE_PATH/lx(fs|mon)0[1-2]*
```

## Deployment

Install the deployment tools on `lxmon01`

```bash
apt install -y lsb-release apt-transport-https clustershell
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-jewel/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
apt update && apt install -y ceph-deploy
```
```bash
su - devops                                          # switch to the deployment user
alias rush='clush -b -l root -w lxmon01,lxfs0[1,2] ' # exec commands on all nodes
ceph-deploy new lxmon01                              # configure the monitoring node
ceph-deploy install --no-adjust-repos lxmon01        # install ceph on all nodes
ceph-deploy install lxfs01 lxfs02
ceph-deploy mon create-initial                       # create monitor and gather keys 
ceph-deploy osd prepare lxfs01:/srv lxfs02:/srv      # prepare the storage
clush -w lxfs0[1,2] 'chown ceph /srv'                # grant ceph access to the storage
ceph-deploy osd activate lxfs01:/srv lxfs02:/srv 
ceph-deploy admin lxmon01 lxfs01 lxfs02              # deploy configuration on all nodes
sudo chmod +r /etc/ceph/ceph.client.admin.keyring    # correct permissions for the admin key
rush 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
rush 'systemctl status ceph'                         # state of the service daemons
clush -l root -w lxfs0[1,2] 'tail /var/log/ceph/ceph-osd.*.log'
ceph status
ceph osd tree                                        # tree reflecting the crush map
ceph health detail
ceph osd dump
```
