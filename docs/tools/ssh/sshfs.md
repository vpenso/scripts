

## SSHFS

The script ↴ [SSHFS][sshfs] **mounts remote directories** over a SSH connection (implementation used [FUSE][libfuse] (Filesystem in Userspace))

[sshfs]: https://github.com/libfuse/sshfs
[libfuse]: https://github.com/libfuse/libfuse

```bash
# install on CentOS (requries EPEL)
yum install -y fuse-sshfs
# install on Debian
apt install -y sshfs
# install on Arch
pacman -S sshfs
```

Mount a directory from a remote host:

```bash
# mount a remote directory
sshfs -C -o reconnect,auto_cache,follow_symlinks [user@]host[:port] /mnt/path 
# unmount the remote directory
fusermount -u /mnt/path
```

[ssh-fs][06] is a script to simplifies this process:

```bash
# mount remote directories
>>> ssh-fs mount example.org:docs ~/docs
>>> ssh-fs mount jdoe@example.org:/data /data
# list mounted directories
>>> ssh-fs list 
example.org:docs on /home/jdoe/docs
example.org:/data on /data
# unmount remote directories
>>> ssh-fs umount /data
>>> ssh-fs umount ~/docs
```

[06]: ../../bin/ssh-fs
