
Client are distributed in the `ceph-common` package

```bash
/etc/ceph/ceph.conf                                  # default location for configuration
/etc/ceph/ceph.client.admin.keyring                  # default location for admin key 
```

## RADOS

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

## RBD

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
```

### Libvirt

```bash
qemu-img create -f raw rbd:<pool>/<image> <size>     # create a new image block device
qemu-img info rbd:<pool>/<image>                     # block device states
qemu-img resize rbd:<pool>/<image> <size>            # adjust image size
# create new RBD image from source qcow2 image
qemu-img convert -f qcow2 <path> -O rbd rbd:<pool>/<image>
```

RBD image as `<disk>` entry for a virtual machine; replace: 

- `source/name=` with `<pool>/<image>`
- `host/name=` with the IP address of a monitor server (multiples supported)
- `secret/uuid=` with the corresponding libvirt secret UUID

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

```bash
ceph osd map <pool> <image>                                # map image to PGs
virsh qemu-monitor-command --hmp <instance> 'info block'   # configuration of the VM instance 
virsh dumpxml <instance> | xmlstarlet el -v | grep rbd     # get attached RBD image
```










