

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
