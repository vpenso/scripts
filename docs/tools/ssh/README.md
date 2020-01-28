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
```

SSH is not a true shell (command interpreter):

* It creates a channel for running a shell on a remote computer (with end-to-end encryption)
* SSH is a protocol, not a product
  - Specification of how to conduct secure communication over a network
  - Covers authentication, encryption, and the integrity of data transmitted over a network
* **Most used implementations is [OpenSSH](https://www.openssh.com/)**

## Client Authentication

Different SSH authentication methods:

* Legacy password authentication
* Keyboard-interactive authentication
  - Modern implementation of password authentication
  - Supports challenge-response, and one-time passwords
  - Supports LDAP, and local credential databases (e.g., password files)
* Host-Based Authentication
  - Clients use host key to verify the server’s identity
  - The client side host warrants for the users identity
* Kerberos Authentication (GSSAPI)
  - Single sign-on within a Windows domain or Kerberos realm
  - User accounts/credentials stored in a centralized directory
  - Single point for managing user accounts (including disabling)
* Public Key Authentication
* Certificate Authentication


