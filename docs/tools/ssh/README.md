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

## Remote Login

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

## Copy Files

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

## Public-Key Authentication

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

### Key Types

* **RSA** key length at least 2048 bits
  - Rely on the practical difficulty of factoring the product of two large prime numbers
  - Greatest portability (works with all OpenSSH versions)
* **ECDSA** (since OpenSSH 5.7) key length at least 256 bits
  - Rely on elliptic curve discrete logarithm problem
  - Smaller keys, less computation (for the same level of presumed security)
  - Sensitive to bad random number generators
  - Trustworthiness of NIST-produced curves being questioned [cvint]
* **Ed25519** (since OpenSSH 6.5)
  - Variant of the ECDSA algorithm
  - Solves the random number generator problem
* DSA is deprecated and disabled since OpenSSH 7.0


### Distribution

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

## Fingerprints

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

# References

[cvint] Libssh curve25519 Introduction  
<https://git.libssh.org/projects/libssh.git/tree/doc/curve25519-sha256@libssh.org.txt#n4>

