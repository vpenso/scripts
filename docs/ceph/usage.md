
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

**Block interface** on top of RADOS:

- Images (single block devices) striped over multiple RADOS objects/OSDs
- The default pool is called `rbd`

```bash
mod(probe|info) rbd                                  # kernel module
/sys/bus/rbd/                                        # live module data
rbd ls [-l] [<pool>]                                 # list block devices
rbd info [<pool>/]<name>                             # introspec image
rbd du [<name>]                                      # list size of images
rbd create --size <MB> [<pool>/]<name>               # create image
rbd map <name>                                       # map image to device
rbd showmapped                                       # list device mappring
rbd unmap <name>                                     # 
rbd rm [<pool>/]<name>                               # remove image
```

**Snapshots**

- Read-only copy of the state of an image at a particular point in time
- Layering allows for cloning snapshots
- Stop I/O before taking a snapshot (internal file-systems must be in a consistent state)
- Rolling back overwrites the current version of the image
- It is faster to clone from a snapshot than to rollback to return to an pre-existing state

```bash
rbd snap create <pool>/<image>@<name>                # snapshot image
rbd snap ls <pool>/<image>                           # list snapshots of image
rbd snap rollback <pool>/<image>@<name>              # rollback to snapshot
rbd snap rm <pool>/<image>@<name>                    # delete snapshot
rbd snap purge <pool>/<image>                        # delete all snapshots
rbd snap protect <pool>/<image>@<name>               # protect snapshot before cloneing
rbd snap unprotect <pool>/<image>@<name>             # revert protection
rbd clone <pool>/<image>@<name> <pool>/<image>       # clone snapshot to new image
rbd children <pool>/<image>@<name>                   # list snapshot decendents
rbd flatten <pool>/<image>                           # decouple from parent snapshot
```

### Libvirt

```bash
qemu-img create -f raw rbd:<pool>/<image> <size>     # create a new image block device
qemu-img info rbd:<pool>/<image>                     # block device states
qemu-img resize rbd:<pool>/<image> <size>            # adjust image size
# create new RBD image from source qcow2 image, and vice versa
qemu-img convert -f qcow2 <path> -O rbd rbd:<pool>/<image>
qemu-img convert -f rbd rbd:<pool>/<image> -O qcow2 <path>
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










