# SSH

SSH (Secure SHell) network protocol:

* **Encrypted communication** (optionally compressed) between client and server
* **Public key authentication** (optionally replacing password authentication)
* Authentication of the server (making man-in-the-middle attack more difficult)
* File transfer, the SSH protocol family includes two file transfer protocols.
* **Port forwarding**, arbitrary TCP sessions can be forwarded over an SSH connection

Command used with SSH

```bash
ssh                 # login to a remote server
scp                 # copy files from/to a remote server
rsync               # ^^ (delta sync.)
ssh-keygen          # generate an ssh public/private key pair
ssh-copy-id         # copy a public key to a server
ssh-agent           # daemon temporarily storing the private key
ssh-keyscan         # manage host fingerprints
sshuttle            # private network tunnel over SSH
sshfs               # mount remote file-systems over SSH
```

## Public-Key Authentication

**SSH key** (asymmetric cryptography):

* Provides cryptographic strength that even extremely long passwords can not offer
* Grant access to servers; allows automated, password-less login
* Users can **self-provision a key pair** (authentication credential)
* Each SSH key pair includes two keys:
  - **Public key** that is copied to the SSH server(s)
  - **Private key** that remains (only) with the user

**Extremely important that the privacy of the private key is guarded carefully!**

* **Encrypting the private key** with a passphrase
* Users require the passphrase to use/decrypt the private key
* Handling of passphrases can be automated with an `ssh-agent` 

SSH servers grant access based on **authorized keys**

* An SSH server receives a public key from a user and considers the key trustworthy
* Server marks the key as authorized in its `authorized_keys` file

## ssh-agent-session

Usually users start an SSH agent the following way:

    » eval $(ssh-agent)
    Agent pid 2157
    » ssh-add ~/.ssh/id_rsa 
    Enter passphrase for /home/jdoe/.ssh/id_rsa:
    Identity added: /home/jdoe/.ssh/id_rsa (/home/jdoe/.ssh/id_rsa)
    » ssh-add -l 
    2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
    4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:cd project/id_rsa (RSA)

Keys are added with `ssh-add`. The script [ssh-agent-session][05] helps to use a single _ssh-agent_ session in multiple shells. 
It will start a new agent and store the connection information to `~/.ssh/agent-session`. 

    » source ssh-agent-session
    ssh-agent started, session in /home/jdoe/.ssh/agent-session
    » ssh-add ~/.ssh/id_rsa 
    […]

Another shell can bind to the same agent:

    » source ssh-agent-session
    ssh-agent running with process ID 19264
    » ssh-add -l 
    […]

It is convenient to source this script within the shell profile, in order to bind all shells to a single _ssh-agent_ instance.

    » echo "source /path/to/ssh-agent-session" >> ~/.zshrc

## ssh-fs

Install _sshfs_ on Debian (>= 7):

    » sudo apt-get install sshfs
    » sudo adduser $USER fuse
    » sudo tail -4 /etc/fuse.conf
    # Allow non-root users to specify the 'allow_other' or 'allow_root'
    # mount options.
    #
    user_allow_other
    » sudo /etc/init.d/udev restart

1. Install the `sshfs` package with APT.
2. Add your user account to the group _fuse_.
3. Uncomment `user_allow_other` in the file `/etc/fuse.conf`.
4. Restart the udev mapper.

Mount a directory from a remote host:

    » sshfs [user@]host[:port] /mnt/path -C -o reconnect,auto_cache,follow_symlinks
    » fusermount -u /mnt/pat

The script [ssh-fs][06] simplifies this process:

    » ssh-fs mount example.org:docs ~/docs
    » ssh-fs mount jdoe@example.org:/data /data
    » ssh-fs list 
    example.org:docs on /home/jdoe/docs
    example.org:/data on /data
    » ssh-fs umount /data
    » ssh-fs umount ~/docs

## ssh-instance

The script [ssh-instance][10] generates an `ssh_config` file used to address a specific host.


    » ssh-keygen -q -t rsa -b 2048 -N '' -f keys/id_rsa
    » ssh-instance -u root -i keys/id_rsa 10.1.1.26 
    […]
    » ssh -F ssh_config instance -C […]

 Other tools like [ssh-exec][11] or [ssh-sync][12] determine the target host by reading *ssh_config* by default.

    » ssh-exec 'mkdir -p -m 0700 ~/.ssh'
    » ssh-sync keys/id_rsa.pub :.ssh/authorized_keys
    […]


## ssh-tunnel

On Debian (>= 7) and Ubuntu (>= 11.10) install _shuttle_ with:

    » sudo apt-get install sshuttle

Connect to a remote network is (first the Sudo password is prompted, next the SSH login password):

    » sshuttle --dns --remote [user@]host[:port] --daemon --pidfile=/tmp/sshuttle.pid 0/0

This will route all your traffic (including DNS requests) transparently through SSH. Disconnect with:

    » kill $(cat /tmp/sshuttle.pid)

The script [ssh-tunnel][15] simplifies this process:

    » ssh-tunnel help
    […]
    » ssh-tunnel connect jdoe@example.org
    [local sudo] Password: 
    jdoe@example.org's password: 
    Connected.
    […]
    » ssh-tunnel status
    Sshuttle running with PID 15083.
    » ssh-tunnel disconnect
    » ssh-tunnel status
    Sshuttle not connected.

Limit tunneling to a range of IP addresses, or to exclude (option `-x range`) certain IP ranges.

    » ssh-tunnel co example.org 203.0.113.0/24
    » ssh-tunnel co example.org -x 192.0.2.0/24 -x 198.51.100.0/24 0/0

[05]: ../../bin/ssh-agent-session
[06]: ../../bin/ssh-fs
[10]: ../../bin/ssh-instance
[11]: ../../bin/ssh-exec
[12]: ../../bin/ssh-sync
[15]: ../../bin/ssh-tunnel
