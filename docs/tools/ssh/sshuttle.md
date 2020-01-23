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

[15]: ../../bin/ssh-tunnel


