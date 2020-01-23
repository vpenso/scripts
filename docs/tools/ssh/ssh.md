```
~/.ssh/config             # client configuration
~/.ssh/authorized_keys    # authorized keys on a server
```

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

