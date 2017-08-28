

### Placement Groups

Recommended Number of PGs `pg_num` in relation to the number of OSDs

```
OSDs       PGs
<5         128
5~10       512
10~50      4096
>50        50-100 per OSD
```



### Libvirt

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

