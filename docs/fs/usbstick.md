Multi user support on an USB stick:

```bash
mkdir -p /usb/stick
partition=/dev/sdc1           # for example, change this to your needs!
mkfs.ext4 $partition          # create a file-system with ACL support
tune2fs -o acl $partition     # enable ACLs
mount $partition /usb/stick/
chown $user: /usb/stick/
chmod 777 /usb/stick/
setfacl -m d:u::rwx,d:g::rwx,d:o::rwx /usb/stick/
umount /usb/stick/
```
