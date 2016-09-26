Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

```bash
NODES=lxmon0[1-3],lxfs0[1-4],lxb00[1-2]
# make sure python is pre-installed in the virtual machine image
nodeset-loop "virsh-instance -O shadow debian8-xfs {}"
nodeset-loop 'virsh-instance exec {} " echo {} >/etc/hostname ; hostname {} ; hostname -f"'
# allow password-less ssh to all nodes...
virsh-instance sync lxmon01 keys/id_rsa :/home/devops/.ssh/
virsh-instance exec lxmon01 chown devops:devops /home/devops/.ssh/id_rsa
# Clean up...
nodeset-loop virsh-instance rm {}
rm -rf $VM_INSTANCE_PATH/lx(fs|mon)0[1-2]*
```

Install the deployment tools on `lxmon01`

```bash
cd $VM_INSTANCE_PATH/lxmon01 ; ssh-exec -r
apt install -y lsb-release apt-transport-https clustershell
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-jewel/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
apt update && apt install -y ceph-deploy
su - devops                                          # switch to the deployment user
echo -e 'Host lx*\n StrictHostKeyChecking no' > ~/.ssh/config
                                                     # ignore SSH fingerprints
echo "alias rush='clush -b -l root -w lxmon0[1-3],lxfs0[1-4],lxb00[1-2] '" > ~/.bashrc && source ~/.bashrc
                                                     # exec commands on all nodes
clush -l root -w lxfs0[1,2] -b "dmesg | grep '[v,s]d[a-z]' | tr -s ' ' | cut -d' ' -f3-"
                                                     # check file-systems on OSDs
```

### Monitor Server

Install the first monitor:

```bash
ceph-deploy new lxmon01                              # configure the monitoring node
ceph-deploy install --no-adjust-repos lxmon01        # install ceph on all nodes
```

Add another monitor:

```bash
ceph-deploy install lxmon02
ceph-deploy mon add lxmon02
```

### Object Storage Server

Install two storage servers:

```bash
ceph-deploy install lxfs01 lxfs02 lxfs03
ceph-deploy mon create-initial                       # create monitor and gather keys 
ceph-deploy osd prepare lxfs01:/srv lxfs02:/srv lxfs03:/srv
                                                     # prepare the storage
clush -l root -w lxfs0[1-3] 'chown ceph /srv'        # grant ceph access to the storage
ceph-deploy osd activate lxfs01:/srv lxfs02:/srv lxfs03:/srv 
ceph-deploy admin lxmon01 lxfs01 lxfs02 lxfs03       # deploy configuration on all nodes
rush 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
                                                     # correct permissions for the admin key
```

Expand the cluster with another OSD:

```bash
ceph-deploy install lxfs04
ceph-deploy osd prepare lxfs04:/srv
ssh root@lxfs04 -C 'chown ceph /srv'
ceph-deploy osd activate lxfs04:/srv
ceph -w                                              # show rebalancing the cluster by migrating placement groups
```

### File-System

```bash
ceph-deploy mds create lxmon01                       # create an MDS
ceph osd pool create cephfs_data 50                  # create a pool for the data
ceph osd pool create cephfs_metadata                 # create a pool for the metadata
ceph fs new cephfs cephfs_metadata cephfs_data       # enable the filesystem
ceph fs ls
ceph mds stat                                        # state of the MDS
grep key ~/ceph.client.admin.keyring | tr -d '  ' | cut -d= -f2- > admin.secret
                                                     # extract client key
ceph-deploy install lxb001 && scp admin.secret lxb001: 
ssh root@lxb001
apt install ceph-fs-common
sudo mount -t ceph 10.1.1.22:6789:/ /mnt -o name=admin,secretfile=admin.secret
```


