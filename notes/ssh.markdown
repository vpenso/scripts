

## Network Tunnel from a Public Place or at Home

**[Sshuttle][10] enables access to a remote network over SSH.**
Technically it is part transparent proxy, part Virtual Private
Network (VPN), and part SSH forwarding. Since it is based on 
SSH, traffic is encrypted, and it is installed on the client 
side only. Basically if SSH access to a remote network is 
available, _sshuttle_ can hook the client into the remote network.

On Debian (>= 7) and Ubuntu (>= 11.10) install _shuttle_ with:

    » sudo apt-get install sshuttle

The basic command to connect with the remote network is (first
the Sudo password is prompted, next the SSH login password):

    » sshuttle --dns --remote [user@]host[:port] --daemon --pidfile=/tmp/sshuttle.pid 0/0  

This will route all your traffic (including DNS requests) 
transparently through SSH. Shutdown _sshuttle_ with:

    » kill $(cat /tmp/sshuttle.pid)

If the client is connected via _sshuttle_ it appears to be 
inside the remote network. It can connect to all resources 
available in the remote network. (Using this method to connect to 
a cooperate network implies that all outgoing traffic from the 
login node _sshuttle_ is connected to can be monitored.)

It is possible to define aliases for convenient use of 
_sshuttle_, or alternatively us the wrapper script [`ssh-tunnel`][11].

    » ssh-tunnel help
    [...SNIP...]
    » ssh-tunnel connect jdoe@example.org
    [local sudo] Password: 
    jdoe@example.org's password: 
    Connected.
    [...SNIP...]
    » ssh-tunnel status
    Sshuttle running with PID 15083.
    » ssh-tunnel disconnect
    » ssh-tunnel status
    Sshuttle not connected.

Depending on the circumstances it is possible to limit 
tunneling to a range of IP addresses, or to exclude 
(option `-x range` certain IP ranges.

    » ssh-tunnel co example.org 203.0.113.0/24
    » ssh-tunnel co example.org -x 192.0.2.0/24 -x 198.51.100.0/24 0/0

Read the _sshuttle_ manual for more details.

## Mount Remote File-Systems

[SshFS][12] is a client side file-system capable to mount
a remote path over SSH. With it clients get read and write
access to data on a remote host via a path in the local
file-system.

The basic command to mount a remote path is:

    » sshfs [user@]host[:port] /mnt/path -C -o reconnect,auto_cache,follow_symlinks

Unmount the file-system with:

    » fusermount -u /mnt/path

Mount several remote paths with the wrapper script [`ssh-fs`][14]:

    » ssh-fs mount example.org:docs ~/docs
    » ssh-fs mount jdoe@example.org:/data /data
    » ssh-fs list 
    example.org:docs on /home/jdoe/docs
    example.org:/data on /data
    » ssh-fs umount /data
    » ssh-fs umount ~/docs

[10]: https://github.com/apenwarr/sshuttle
[11]: ../bin/ssh-tunnel
[12]: http://fuse.sourceforge.net/sshfs.html
[14]: ../bin/ssh-fs

