## File-System Mount

```bash
/etc/fstab                                      # translated by systemd-fstab-generator into units
/etc/systemd/system/*.mount                     # mount units
systemctl --all -t mount                        # show mounts
systemd.special                                 # units treated specially by systemd
```

Mount units must be named after the mount point directories they control, cf `systemd-escape`.

Unit skeleton for a local file-system:

```
[Unit]
Description= # comment

[Mount]
What= # partition name, path or UUID to mount
Where= # path to a mount point
Type= # file system type (e.g. ext4)
Options=defaults

[Install]
WantedBy=local-fs.target
```

Unit skeleton for an NFS mount:

```
[Unit]
Description= # comment
Wants=network-online.target
After=network-online.target

[Mount]
What= # path uuid, e.g. nfs.devops.test:/srv/nfs/devops
Where= # path to a mount point
Type=nfs4
Options=defaults
TimeoutSec=10s

[Install]
WantedBy=network-online.target
```

### Tmpfs

Use tmpfs to mount /tmp:

```bash
>>> cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount
>>> systemctl enable tmp.mount && systemctl start tmp.mount
```
