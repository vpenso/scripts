# SSH

SSH (Secure SHell) network protocol:

* Client/server architecture:
  * `sshd` (SSH daemon) accepts/rejects incoming connections to its host computer
  * `ssh` (SSH client) connects to `sshd` on a remote server
* Transparently **encrypted communication** (optionally compressed)
* **Public key authentication** (optionally replacing password authentication)
* Authentication of the server (making man-in-the-middle attacks more difficult)
* File transfer, the SSH protocol family includes two file transfer protocols.
* **Port forwarding**, arbitrary TCP sessions can be forwarded over an SSH connection

```bash
ssh                       # login to a remote server
scp                       # copy files from/to a remote server
rsync                     # ^^ (delta sync.)
ssh-keygen                # generate an ssh public/private key pair
ssh-copy-id               # copy a public key to a server
ssh-agent                 # daemon temporarily storing the private key
ssh-add                   # add a private key to an SSH agent
ssh-keyscan               # manage host fingerprints
sshuttle                  # private network tunnel over SSH
sshfs                     # mount remote file-systems over SSH
~/.ssh/config             # client configuration
~/.ssh/authorized_keys    # authorized keys on a server
```

SSH is not a true shell (command interpreter):

* It creates a channel for running a shell on a remote computer (with end-to-end encryption)
* SSH is a protocol, not a product
  - Specification of how to conduct secure communication over a network
  - Covers authentication, encryption, and the integrity of data transmitted over a network
* **Most used implementations is [OpenSSH](https://www.openssh.com/)**

### Remote Login

Establish a **remote terminal session** to a server `<user>@<server>`:

* `<user>` is a **login account** name on the remote server, i.e. "jdow"
* `<server>` is an **IP address** or **hostname** of the server to connect to, i.e. "pool.devops.test"

```
>>> ssh jdow@pool.devops.test↵
The authenticity of host 'pool.devops.test' (10.10.10.10)' can't be established.
RSA key fingerprint is 96:15:0e:e7:70:09:60:9a:c4:f6:89:05:be:ed:be:c6.
Are you sure you want to continue connecting (yes/no)? yes↵
Warning: Permanently added 'pool.devops.test' (RSA) to the list of known hosts.
jdow@pool.devops.test's password:↵
jdow@node1: exit↵
```

* The system will ask you to accept the remote computer into the list of known hosts (only at first login)
* Make sure fingerprint is trustworthy before accepting
* Type in your password before you can login
* Use `exit` to logout from the remote computer and end the SSH session

The SSH **known hosts** prevents attacks based on subverting the naming services:

* Client and server provide an identity to each other upon connection
* The SSH server has a secret unique ID, called a **host key**, to identify itself to clients
* At first connection a public counterpart of the host key gets stored on the client in the `~/.ssh/known_hosts` file
* Each subsequent connection is authenticated using the server public key

Close hanging SSH connections using an **escape sequence `~.`**.

### Copy Files

`scp` (secure copy) moves files across SSH connections:

* Source and/or destination can be located on a remote computer
* Option **`-r` copies recursively** all file in the directory tree

```bash
# copy files to a remote server
scp -r /local/path/ jdow@pool.devops.test:remote/path/
# copy files from a remote server
scp -r jdow@pool.devops.test:remote/file/ /local/path
```

Transfer a signification amount of data by increasing the speed with an alternative encryption method:

```bash
scp -c blowfish -r jdow@pool.devops.test:/path/to/data/ /local/path/to/data
```

### Public-Key Authentication

**SSH key** (asymmetric cryptography):

* Provides cryptographic strength that even extremely long passwords can not offer
* Grants access to servers; allows automated, password-less login
* Users can **self-provision a key pair** (authentication credential)
* Each SSH key pair includes two keys:
  - **Public key** that is copied to the SSH server(s)
  - **Private key** that remains (only) with the user (aka. identity key)

```bash
# generate a key pare in ~/.ssh
ssh-keygen -q -f ~/.ssh/id_rsa -t rsa
# change the passphrase of a private key
ssh-keygen -f ~/.ssh/id_rsa -p
```

**It is extremely important that the privacy of the private key is guarded carefully!**

* **Encrypting the private key** with a passphrase
* Users require the passphrase to use/decrypt the private key
* Handling of passphrases can be automated with an `ssh-agent` 

SSH servers grant access based on **authorized keys**

* An SSH server receives a public key from a user and considers the key trustworthy
* Server marks the key as authorized in its `authorized_keys` file

```bash
# copy a public key to a remote server
ssh-copy-id jdow@pool.devops.test:
```

Alternatively:

```bash
# copy the public key to a remove server
scp ~/.ssh/id_rsa.pub jdow@pool.devops.test:/tmp
# append the public key to the authorized_keys file
cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
# make sure the file permissions are correct
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
```

### Fingerprints

Used for **identification/verification of the host**:

```bash
/etc/ssh/ssh_host_*                     # host key pairs
~/.ssh/known_hosts                      # accepted host fingerprints on the client
ssh-keygen -H -F <host>                 # search for a host in known_hosts
ssh-keygen -l -f <pubkey>               # get the fingerprint of a public key
ssh-keygen -lv -f <pubkey>              # ^^ include identicon
ssh -o VisualHostKey=yes ...            # show identicon at login
# add fingerprint of a server host key to known hosts
ssh-keyscan -H <hostname> >> ~/.ssh/known_hosts
# genreate fingerprint DNS records on a host
ssh-keygen -r `hostname`
```

* Fingerprint are based on the host public key
* First client connection includes **server key discovery**
  - Fingerprint presented to the user for verification
  - Accepting a fingerprint adds it to the `~/.ssh/known_hosts` **known host file**
* Fingerprint **verification methods**:
  - Published by host administrators (e.g. on an HTTPS server)
  - SSHFP (RFC4255) publishes fingerprints as DNS records
* The client automatically checks the fingerprint each login, and warns eventually
* Differing fingerprints (changed host key) indicate a potential man-in-the-middle attack
* Visual fingerprint, **identicons** (generated icons, to recognize or distinguish textual information)

The script ↴ [ssh-known-hosts][04] adds, removes or updates a host fingerprint in `~/.ssh/known_hosts`

## SSH Agent

The `ssh-agent` is used for SSH public key authentication:

* **Keeps track of user's identity keys and their passphrases**
* Many Linux distributions automatically start an ssh-agent on login
* Keys are added to an running ssh-agent with `ssh-add`

Start an SSH agent the following way:

```bash
>>> eval $(ssh-agent)
Agent pid 2157
# load an private key into the agent
>>> ssh-add ~/.ssh/id_rsa 
Enter passphrase for /home/jdow/.ssh/id_rsa:
Identity added: /home/jdow/.ssh/id_rsa (/home/jdoe/.ssh/id_rsa)
# list loaded private keys
>>> ssh-add -l 
2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:cd project/id_rsa (RSA)
```


The script ↴ [ssh-agent-session][05] helps to use a **single SSH agent session in multiple shells**.

It will start a new agent and store the connection information to `~/.ssh/agent-session`. 

```bash
>>> source ssh-agent-session
ssh-agent started, session in /home/jdow/.ssh/agent-session
>>> ssh-add ~/.ssh/id_rsa 
[…]
```

Another shell can bind to the same agent:

```bash
>>> source ssh-agent-session
ssh-agent running with process ID 19264
>>> ssh-add -l 
[…]
```

It is convenient to source this script within the shell profile, in order to bind all shells to a single _ssh-agent_ instance.

```bash
echo "source /path/to/ssh-agent-session" >> ~/.zshrc
```

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

## Sshuttle

[sshuttle][sshuttle] is part **transparent proxy**, part **VPN** (Virtual Private Network), and part SSH:

[sshuttle]: https://github.com/sshuttle/sshuttle

* Requires remote login over SSH to a node with Python installed (no need for a complicated pre-existing infrastructure)
+ Needs root access on localhost to modify your system firewall to tunnel all traffic through a remote SSH connection
* Supports **DNS tunneling** to use the DNS servers from the remote node

Connect to a remote network (first the Sudo password is prompted, next the SSH login password):

```bash
sshuttle --dns --remote [user@]host[:port] --daemon --pidfile=/tmp/sshuttle.pid 0/0
```

This will route all your traffic (including DNS requests) transparently through SSH. Disconnect with:

```bash
kill $(cat /tmp/sshuttle.pid)
```

The script ↴ [ssh-tunnel][15] simplifies this process:

```bash
>>> ssh-tunnel help
[…]
>>> ssh-tunnel connect jdoe@example.org
local sudo] Password: 
jdoe@example.org password: 
Connected.
[…]
>>> ssh-tunnel status
Sshuttle running with PID 15083.
>>> ssh-tunnel disconnect
>>> ssh-tunnel status
Sshuttle not connected.
```

Limit tunneling to a range of IP addresses, or to exclude (option `-x range`) certain IP ranges.

```bash
ssh-tunnel co example.org 203.0.113.0/24
ssh-tunnel co example.org -x 192.0.2.0/24 -x 198.51.100.0/24 0/0
```


[04]: ../../bin/ssh-known-hosts
[05]: ../../bin/ssh-agent-session
[06]: ../../bin/ssh-fs
[15]: ../../bin/ssh-tunnel
