
Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

```bash
NODES=lxmon01,lxfs[01-02]
nodeset-loop "virsh-instance -O shadow debian8-xfs {}"
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

Ceph configuration & deployment:

```bash
su - devops                                          # switch to the deployment user
echo -e 'Host lx*\n StrictHostKeyChecking no' > ~/.ssh/config
                                                     # ignore SSH fingerprints
echo "alias rush='clush -b -l root -w lxmon01,lxfs0[1,2] '" > ~/.bashrc && source ~/.bashrc
                                                     # exec commands on all nodes
clush -l root -w lxfs0[1,2] -b "dmesg | grep '[v,s]d[a-z]' | tr -s ' ' | cut -d' ' -f3-"
                                                     # check file-systems on OSDs
ceph-deploy new lxmon01                              # configure the monitoring node
echo 'osd pool default size = 2' >> ~/ceph.conf
                                                     # configure two copies of each object
ceph-deploy install --no-adjust-repos lxmon01        # install ceph on all nodes
clush -l root -w lxfs0[1,2] -b 'apt install -y python'
ceph-deploy install lxfs01 lxfs02
ceph-deploy mon create-initial                       # create monitor and gather keys 
ceph-deploy osd prepare lxfs01:/srv lxfs02:/srv      # prepare the storage
clush -l root -w lxfs0[1,2] 'chown ceph /srv'        # grant ceph access to the storage
ceph-deploy osd activate lxfs01:/srv lxfs02:/srv 
ceph-deploy admin lxmon01 lxfs01 lxfs02              # deploy configuration on all nodes
rush 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
                                                     # correct permissions for the admin key
```

Operation:

```
clush -l root -w lxfs0[1,2] 'tail /var/log/ceph/ceph-osd.*.log'
ceph status                                          # summery of state
ceph osd tree                                        # tree reflecting the crush map
ceph health detail
ceph osd dump
ceph-deploy --overwrite-conf config push lxmon01 lxfs01 lxfs02
                                                     # update the configuration after changes
rush 'systemctl restart ceph.target'                 # restart everything
rush 'ps -p $(pgrep ceph) -fH'                       # show the processes
```

### Placement Groups (PGs)

* CRUSH assigns objects to placement groups
* CRUSH assigns a placement group to a primary OSD
* The Primary OSDs use CRUSH to replicate the PGs to the secondary OSDs
* Re-balance/recover works on all objects in a placement group

```bash
ceph pg dump_stuck inactive|unclean|stale            # statisitcs for stuck PGs
ceph pg map <pgid>                                   # map a placement group
ceph pg <pgid> query                                 # statistics for a particular placement group
ceph pg scrub <pgid>                                 # check primary and replicas
```
