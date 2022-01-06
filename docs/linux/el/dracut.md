## Dracut

Event-driven software to build initramfs images:

<https://dracut.wiki.kernel.org>

```bash
apt install -y dracut dracut-network           # requiered packages on Debian
dracut --help | grep Version                   # show program version
## configuration files
man dracut.conf                                # manual
/etc/dracut.conf                               # global
{/etc,/usr/lib}/dracut.conf.d/*.conf           # custom (/etc overwrites /usr/lib)
## command
dracut --kver $(uname -r)                      # generate the image at the default location for a specific kernel version 
dracut -fv <path>                              # create a new initramfs at specified path
lsinitrd | less                                # contents of the default image
lsinitrd -f <path>                             # content of a file within the default image
lsinitrd <path>                                # contents of a specified initramfs image
## boot parameters
dracut --print-cmdline                         # kernel command line from the running system
man dracut.cmdline                             # list of all kernel arguments
```

Troubleshooting:

```bash
## enable logging within the initramfs image
>>> cat /etc/dracut.conf.d/log.conf
logfile=/var/log/dracut.log
fileloglvl=6
## rebuild the image
```
```bash
## add following to the kernel command line
rd.shell rd.debug log_buf_len=1M
## log file generated during boot
/run/initramfs/rdsosreport.txt 
```

### Boot Stages

The bootloader loads the kernel and its initramfs. When the kernel boots it unpacks the initramfs and executes `/init` (installed from `99base/init.sh` module). Init runs following phases:

| Phase  | Hooks                       | Comment                                                                        |
|--------|-----------------------------|--------------------------------------------------------------------------------|
| Setup  | cmdline                     | Source `dracut-lib.sh`, start logging if requested, parse the kernel arguments |
| Udev   | pre-udev, pre-trigger       | Start `udevd`, run `udevadm trigger`, load kernel modules                      |
| Main   | initqueue                   | Wait for devices until `initqueue/finished`                                    |
| Mount  | pre-mount, mount, pre-pivot | Mount root device, check for target /init                                      |
| Switch | cleanup                     | Clean up, stop udev, stop logging. Start target /init                          |

Find more comprehensive information in the `man dracut.bootup`.

### Modules

Dracut builds the initramfs out of modules:

* Each prefixed with a number which determines the order during the build.
* Lower number modules have higher priority (can't be overwritten by subsequent modules)
* Builtin modules are numbered from 90-99

```bash
man dracut.modules                             # documentation
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
dracut --list-modules | sort | less            # list all available modules
dracut --add <module> ...                      # add module to initramfs image
## within the build initramfs
/usr/lib/dracut/hooks/                         # all hooks
```

All module installation information is in the file *`module-setup.sh`* with following functions:

| Function        | Description                                             |
|-----------------|---------------------------------------------------------|
| check()         | Check if module should be included                      |
| depends()       | List other required modules                             |
| cmdline()       | Required kernel arguments                               |
| install()       | Install non-kernel stuff (scripts, binaries, etc)       |
| installkernel() | Install kernel related files (e.g drivers)              |


### Network 

Create a network aware initramfs with the `dracut-network` package:

* The root file-system is located on a network drive, i.e. NFS
* Boot over the network with PXE

Network related command-line arguments:

```bash
rd.driver.post=mlx4_ib,ib_ipoib,ib_umad,rdma_ucm # load additional kernel modules
ip=10.20.2.137::10.20.0.1:255.255.0.0:lxb001.devops.test:ib0:off
nameserver=10.20.1.11 rd.route=10.20.0.0/16:10.20.0.1:ib0
rd.neednet=1                # bring up networking interface without netroot=
rd.retry=80                 # wait until the interfaces becomes ready
```
