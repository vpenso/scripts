# SSH Public-Key Authentication

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

## Key Types

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


## Distribution

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

