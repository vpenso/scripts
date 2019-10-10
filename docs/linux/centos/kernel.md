


```bash
# list the available Grub menu entries
grubby --info=ALL
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# find out the file name, index number of the default kernel
grubby --default-index
grubby --default-kernel
# currently running kernel
ls -1 /boot/vmlinuz-$(uname -r)
# set running kernel as default
grubby --set-default $(ls -1 /boot/vmlinuz-$(uname -r))
```
