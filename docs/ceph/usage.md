

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

### RADOS Block Device (RBD)

```bash
rbd ls [-l] [<pool>]                                 # list block devices
rbd info [<pool>/]<name>                             # introspec block device image
rbd du [<name>]                                      # list size of images
rbd create --size <MB> [<pool>/]<name>               # create a block device image
rbd rm [<pool>/]<name>                               # remove block device image
```
