
Client are distributed in the `ceph-common` package

```bash
/etc/ceph/ceph.conf                                  # default location for configuration
/etc/ceph/ceph.client.admin.keyring                  # default location for admin key 
```

### RADOS

* Objects store data and have: a name, the payload (data), and attributes
* Object namespace is flat

```bash
rados lspools                                        # list pools
rados df                                             # show pool statistics
rados mkpool <pool>                                  # create a new pool     
rados rmpool <pool>                                  # delete a pool
rados ls -p <pool>                                   # list contents of pool
rados -p <pool> put <objname> <file>                 # store object
rados -p <pool> rm <objname>                         # delete object
```

### RBD

- Block interface on top of RADOS
- Images (single block devices) striped over multiple RADOS objects/OSDs
- Default pool `rbd`

```bash
mod(probe|info) rbd                                  # kernel module
/sys/bus/rbd/                                        # live module data
rbd ls [-l] [<pool>]                                 # list block devices
rbd info [<pool>/]<name>                             # introspec block device image
rbd du [<name>]                                      # list size of images
rbd create --size <MB> [<pool>/]<name>               # create a block device image
rbd map <name>                                       # map block device image
rbd showmapped                                       # list device mappring
rbd unmap <name>                                     # 
rbd rm [<pool>/]<name>                               # remove block device image
# virtualization support with Qemu
qemu-img create -f raw rbd:<pool>/<image> <size>     
qemu-img info rbd:<pool>/<image>
qemu-img resize rbd:<pool>/<image> <size>
```

Libvirt `secret.xml` associated with a Ceph RBD

```xml
<secret ephemeral='no' private='no'>
  <usage type='ceph'>
    <name>client.libvirt secret</name>
  </usage>
</secret>
```
```bash
ceph osd pool create libvirt 128 128                 # create a pool for libvirt
ceph auth get-or-create client.libvirt mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=libvirt'
                                                     # create a user for libvirt
virsh secret-define --file secret.xml                # define the secret
uuid=$(virsh secret-list | grep client.libvirt | cut -d' ' -f 2)
                                                     # uuid of the secret
key=$(ceph auth get-key client.libvirt)              # ceph lcient key
virsh secret-set-value --secret "$uuid" --base64 "$key" 
                                                     # set the UUID of the secret
```

XML skeleton virtual machine disk device using block storage with authentication:

```xml
<disk type="network" device="disk">
  <source protocol='rbd' name='libvirt/lxdev01.devops.test'>
    <host name='10.1.1.22' port='6789'/>
  </source>
  <auth username='libvirt'>
    <secret type='ceph' uuid='ec8a08ff-59b2-49fd-8162-532c9b0a2ed6'/>
  </auth>
  <target dev="vda" bus="virtio"/>
</disk>
```





