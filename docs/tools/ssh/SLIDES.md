
# SSH (Secure Shell)
### Working with Remote Computers

---

# Remote Login


| Arguments | Description |
|-----------|-------------|
| `[user@]hostname[.domain]` | `hostname` - of the remote computer<br> `domain` - e.g. "devops.test" (optional)<br/> `user` - account name (if differs from localhost) |


Establish a **remote terminal session** to a server:

* Make sure **fingerprint is trustworthy** before accepting
* Accept the remote node fingerprint (at first login)
* Use `exit` to **logout** from the remote node and end the SSH session

```bash
» ssh jdow@pool.devops.test↵
The authenticity of host 'pool.devops.test' (10.10.10.10)' can't be established
RSA key fingerprint is 96:15:0e:e7:70:09:60:9a:c4:f6:89:05:be:ed:be:c6.
Are you sure you want to continue connecting (yes/no)? yes↵
Warning: Permanently added 'pool.devops.test' (RSA) to the list of known hosts
jdow@pool.devops.test's password:↵
jdow@node1: exit↵
```




---

# Connection Defaults


 Keyword       | Description 
---------------|-------------
 `Host`        | Hostname pattern matching remote computer name
 `User`        | Account name on the remote computer
 `CheckHostIP` | Login pools share a common name with multiple IPs
 `ForwardX11`  | Enable support for graphic applications

User connection defaults in `~/.ssh/config`:

```bash
### Default user for devops.test
Host *.devops.test
  User vpenso
  CheckHostIP no
  ForwardX11 yes
```

cf. man-page [`ssh_config`](http://manpages.debian.org/ssh_config) for reference 

---

# Copy Files

**Copy files** from/to a remote node with the [`scp`](http://manpages.debian.org/scp) command

 Option | Description
--------|-------------
 `-r`   | Recursively copy entire directories

```bash
scp [[user@]host1:]file1 … [[user@]host2:]file2
```

Example with an absolute path:

```bash
scp /path/to/file vpenso@pool.devops.test:/path/to
```

**Relative paths** start from the home-directory `~`

```bash
scp -r vpenso@pool.devops.test:path/to/file ~/path/to
```

---

# Key Based Authentication

 File                     | Description
--------------------------|-------------
 `~/.ssh/id_rsa`          | Private key, protected by **non-trivial password**
 `~/.ssh/id_rsa.pub`      | Public key, distributed to remote computers
 `~/.ssh/authorized_keys` | Lists public keys allowed to login

[`ssh-keygen`](http://manpages.debian.org/ssh-keygen) generates **public/private key pairs** 

```bash
ssh-keygen -q -f ~/.ssh/id_rsa -t rsa
```


Change password of private-key

```bash
ssh-keygen -f ~/.ssh/id_rsa -p
```

[`ssh-copy-id`](http://manpages.debian.org/ssh-copy-id) **deploys** public-keys to `~/.ssh/authorized_keys`

```bash
ssh-copy-id vpenso@pool.devops.test
```



---

# Key Agent

[`ssh-agent`](http://manpages.debian.org/ssh-agent) stores private-keys for **password-less login** 

```bash
» eval $(ssh-agent)
Agent pid 2157
» ssh-add ~/.ssh/id_rsa 
Enter passphrase for /home/vpenso/.ssh/id_rsa:
Identity added: /home/vpenso/.ssh/id_rsa (/home/vpenso/.ssh/id_rsa)
» ssh-add -l 
2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:cd project/id_rsa (RSA)
```

[`ssh-add`](http://manpages.debian.org/ssh-add) loads a private-key into the agent

| Option | Description |
|--------|-------------|
| `-A`   | Enable forwarding of private-keys to remote computer | 

Forwarding exposes the private-key to the **trustworthy** remote computer!

```bash
»  ssh -A -t vpenso@pool.devops.test ssh lxdev01
```


---

# Key Agent Session

Use a single `ssh-agent` session in multiple shells:

| File | Description |
|------|-------------|
| `~/.ssh/agent-session` | Stores agent connection information |  

Start an agent and store the connection information ↴ [`ssh-agent-session`](https://raw.githubusercontent.com/vpenso/scripts/master/bin/ssh-agent-session)

```bash
» source ssh-agent-session
ssh-agent started, session in /home/vpenso/.ssh/agent-session
```


Use an already running agent:

```bash
» source ssh-agent-session
ssh-agent running with process ID 19264
```

Source this script within the your profile, e.g.:

```bash
» echo "source ~/bin/ssh-agent-session"  >> ~/.zshrc
```

---

# Network Tunnel

[`sshuttle`](https://github.com/apenwarr/sshuttle) creates a **transparent proxy** to a remote network ([VPN](https://en.wikipedia.org/wiki/Virtual_private_network) style) 

Route network traffic over an SSH connection into GSI:

```bash
» sshuttle --dns --remote vpenso@pool.devops.test --daemon \
           --pidfile=/tmp/sshuttle.pid 0/0
[…]
» kill $(cat /tmp/sshuttle.pid)
```

The script ↴ [`ssh-tunnel`](https://raw.githubusercontent.com/vpenso/scripts/master/bin/ssh-tunnel) wraps these commands 

```bash
» ssh-tunnel connect vpenso@pool.devops.test
[local sudo] Password: 
vpenso@gsi.de's password: 
Connected.
[…]
» ssh-tunnel status
Sshuttle running with PID 15083.
» ssh-tunnel disconnect
» ssh-tunnel status
Sshuttle not connected.
```

---

# Mounts


Mounts a **remote directory** onto your local computer with [`sshfs`](http://manpages.debian.org/sshfs) 

```bash
» sshfs -C -o reconnect,auto_cache,follow_symlinks \
        vpenso@pool.devops.test:/WWW/vpenso ~/www 
[…]
» fusermount -u /mnt/path
```

Release the mount with [`fusermount`](http://manpages.debian.org/sshfs)

The script ↴ [`ssh-fs`](https://raw.githubusercontent.com/vpenso/scripts/master/bin/ssh-fs) wraps these commands

```bash
# mount remote directories
» ssh-fs mount example.org:docs ~/docs
» ssh-fs mount jdoe@example.org:/data /data
# list mounted directories
» ssh-fs list 
example.org:docs on /home/jdoe/docs
example.org:/data on /data
# unmount remote directories
» ssh-fs umount /data
» ssh-fs umount ~/docs
```
