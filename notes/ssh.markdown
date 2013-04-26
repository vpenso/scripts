# Remote Login with Key

Using an authentication key for login (usually) offers additional 
security, and simplifies multiple connections to servers. A key
comes in a public-private pair, where the private part is kept
secret while the public part is distributed for remote login.

Generate an authentication key pair with the `ssh-keygen` utility. 

    » ssh-keygen -t rsa -f ~/.ssh/id_rsa 
    [...SNIP...]

The option `-f file` specifies the location where to store the
private key. **Make sure to use a non-trivial password to secure 
your private key.** Change the password of a private key with
the option `-p`.

    » ssh-keygen -p -f ~/.ssh/id_rsa

SSH supports different types of encryption, in the example above
an RSA key was created using the option `-t algorithm`. Besides 
the choice between different encryption algorithms, it is possible
to define the key (bit) length with option `-b size`. 

Common key types and key length:

* The default is `-t rsa -b 2048` for an RSA 2048bit key.
* Depending on the application use RSA with `-b 4096`.
* Recent versions of SSH support the ECDSA algorithm
  `-t ecdsa -b 512`.

## Public Key Deployment on Remote Servers

The utility `ssh-copy-id` transfers and installs a public key
on a remote node:

    » ssh-copy-id -i ~/.ssh/id_rsa.pub jdoe@lx-pool.gsi.de

The public keys usually uses the file name suffix `.pub` and
are created in the same path as the private key.

## Using an Authentication Agent

Since the authentication keys are protected by a pass phrase, 
each remote login will require typing it in. An SSH agent will 
cache the private key and will provide it for remote login. 
Thus typing of the pass phrase will be required only once.

Start an SSH agent and add an authentication key:

    » eval $(ssh-agent)
    Agent pid 2157
    » ssh-add ~/.ssh/id_rsa 
    Enter passphrase for /home/jdoe/.ssh/id_rsa:
    Identity added: /home/jdoe/.ssh/id_rsa (/home/jdoe/.ssh/id_rsa)

Multiple keys can be added with `ssh-add`. Using the option `-l`
will list cached private keys.

    » ssh-add -l 
    2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
    4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce project/id_rsa (RSA)

## Sharing an Authentication Agent

It is possible to use a single SSH agent across multiple shells. 
The script `ssh-agent-session` starts an instance of `ssh-agent`
and writes its connection information to `~/.ssh/agent-session`.
Any shell can use this information to bind with the already
running SSH agent.

Download the [ssh-agent-session][sas] script and save it to a location
of your choice. Use `source` to load the SSH agent environment. A new
agent is create:

    » source ssh-agent-session
    Agent started, session in /home/jdoe/.ssh/agent-session
    Using existing SSH agent!
    » ssh-add ~/.ssh/id_rsa 
    [...sNIP...]

Inside a second shell bind to the running SSH agent:

    » source ssh-agent-session
    Running with process ID 19264
    Using existing SSH agent!
    » ssh-add -l 
    [...SNIP...]

In order to automatically use a single SSH agent across all new
shells you can add it to your shell profile. For example in 
Bash:

    » echo "source /path/to/ssh-agent-session" >> ~/.bashrc

Similar in ZSH add the same line to `~/.zshrc`. If you want to
make sure to remove all cached keys from SSH agent use `ssh-agent-stop`.

    » ssh-agent-stop
    All identities removed.

[sas]: https://raw.github.com/vpenso/scripts/master/bin/ssh-agent-session

# Network Tunnel with Proxy

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
_sshuttle_, or alternatively us the wrapper script [ssh-tunnel][11].

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

# Mount Remote File-Systems

[SshFS][12] is a client side file-system capable to mount
a remote path over SSH. With it clients get read and write
access to data on a remote host via a path in the local
file-system.

Install _sshfs_ on Debian (>= 7) doing the following steps:

    » sudo apt-get install sshfs
    » sudo adduser $USER fuse
    » sudo tail -4 /etc/fuse.conf
    # Allow non-root users to specify the 'allow_other' or 'allow_root'
    # mount options.
    #
    user_allow_other
    » sudo /etc/init.d/udev restart

- Install the `sshfs` package with APT
- Add your user account to the group fuse.
- Uncomment `user_allow_other` in the file `/etc/fuse.conf`.
- Restart the udev mapper.

In Ubuntu it is enough to install the `sshfs` package.

The basic command to mount a remote path is:

    » sshfs [user@]host[:port] /mnt/path -C -o reconnect,auto_cache,follow_symlinks

Unmount the file-system with:

    » fusermount -u /mnt/path

Mount several remote paths with the wrapper script [ssh-fs][14]:

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
