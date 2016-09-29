Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

```bash
NODES lxmon0[1-3],lxfs0[1-4],lxb00[1-2]
# image needs an xfs file-system, make sure python is installed
nodeset-loop "virsh-instance -O shadow debian8 {}"
nodeset-loop 'virsh-instance exec {} "echo {} >/etc/hostname ; hostname {} ; hostname -f"'
# allow password-less ssh to all nodes from lxmon01
virsh-instance sync lxmon01 keys/id_rsa :/home/devops/.ssh/
virsh-instance exec lxmon01 chown devops:devops /home/devops/.ssh/id_rsa
# Clean up...
nodeset-loop virsh-instance rm {}
rm -rf $VM_INSTANCE_PATH/lx(fs|mon)0[1-2]*
```

Install the deployment tools on `lxmon01`

```bash
virsh-instance login lxmon01
```

Configure the Ceph repository manually:

```bash
sudo apt install -y lsb-release apt-transport-https clustershell
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-jewel/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
sudo apt update 
```

Setup the Ceph repository in the virtual machine image with the Chef role [ceph_common][01] beforehand:

  - Enables to use of `ceph-deploy install --no-adjust-repos <node>`
  - Directly install the packages: `ceph-mon`, `ceph-osd`, `ceph-mds` to omit `ceph-deploy 

```bash
sudo apt install -y ceph-deploy
echo -e 'Host lx*\n StrictHostKeyChecking no' > ~/.ssh/config
                                                     # ignore SSH fingerprints
alias rush-mon='clush -b -l root -w lxmon0[1-3] '
alias rush-osd='clush -b -l root -w lxfs0[1-5] '
clush -l root -w lxfs0[1,2] -b "dmesg | grep '[v,s]d[a-z]' | tr -s ' ' | cut -d' ' -f3-"
                                                     # check file-systems on OSDs
```

### Monitor Server

Minimum quorum with three monitor servers:

```bash
ceph-deploy new lxmon01
ceph-deploy install lxmon01 lxmon02 lxmon03          # deploy packages if missing
ceph-deploy mon create-initial                       # create monitor and gather keys 
ceph-deploy admin lxmon01                            # deploy admin configuration
sudo chmod +r /etc/ceph/ceph.client.admin.keyring    # correct permissions for the admin key
ceph-deploy mon add lxmon02                          # add monitor to configuration
ceph-deploy mon add lxmon03
```

### Object Storage Server

Install two storage servers:

```bash
ceph-deploy install lxfs01 lxfs02 lxfs03
ceph-deploy osd prepare lxfs01:/srv lxfs02:/srv lxfs03:/srv
                                                     # prepare the storage
clush -l root -w lxfs0[1-3] 'chown ceph /srv'        # grant ceph access to the storage
ceph-deploy osd activate lxfs01:/srv lxfs02:/srv lxfs03:/srv 
```

### Meta Data Server

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

### Block Devices

```bash
ceph-deploy install lxhvs01
ceph-deploy admin lxhvs01
ssh root@lxhvs01
rbd create lxdev01 --size 20480                      # create a block device image
modprobe rbd                                         # load the kernel module
rbd feature disable lxdev01 deep-flatten fast-diff object-map exclusive-lock
rbd map lxdev01                                      # map the block device image
mkfs.ext4 -m0 /dev/rbd/rbd/lxdev01                   # create a file-system
mount /dev/rbd/rbd/lxdev01 /mnt                      # mount the file-system
```

[01]: ../../var/chef/roles/debian/ceph/common.rb

