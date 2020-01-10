
## Containers

Cf. [bootstrap](bootstrap.md) to create root file-systems for containers

```bash
apt -y install systemd-container                 # install container support 
man systemd.nspaw                                # container settings documentation
{/etc,/run}/systemd/nspawn/*.nspawn              # nspawn container settings files
findmnt /var/lib/machines                        # container images & container settings
systemd-nspawn -D <rootfs>                       # chroot to container path
               -i <image>                        # chroot to a container image
               -b -D <rootfs>                    # boot container in path 
machinectl pull-raw --verify=no <url>            # download container archive 
           import-tar $archive                   # import rootfs from an archive
           list-images                           # list container images
           image-status <image>                  # status information about container image
           show-image <image>                    # properties of container image
           clone <src_image> <dst_image>         # clone a container image
           remove <image>                        # delete a continer image
           start <image>                         # start container
           list                                  # list running containers
           status <image>                        # process tree in container
           shell <user>@<image> /bin/bash        # start a shell in the container
           poweroff <image>                      # shutdown container
journalctl -M <image>                            # show log of container
```

Unit skeleton for a container in `/etc/systemd/system/${name}.service`

```
[Unit]
Description= # name of the container

[Service]
ExecStart=/usr/bin/systemd-nspawn -bD <rootfs>  # command to start the container           
```

Use a virtual ethernet interfaces:

```bash
echo -e "[Link]\nName=host0" > /etc/systemd/network/10-host0.link
echo -e "[Match]\nName=host0\n[Network]\nDHCP=yes" > /etc/systemd/network/11-host0.network
systemctl enable systemd-networkd                          # prepare the network configuration
## -- use a virtual network with a container -- ##
systemd-nspawn --network-veth --network-bridge=nbr0 ... 
```
