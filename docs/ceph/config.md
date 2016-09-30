
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
