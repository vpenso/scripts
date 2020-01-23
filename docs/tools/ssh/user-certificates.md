## SSH CA - User Certificates

Generate a CA signing key

```bash
ssh-keygen -f user_ca
# writes user_ca & user_ca.pub
```

Sign a user key:

```
# create a user key (no password for testing)
ssh-keygen -q -t rsa -b 2048 -N '' -f id_rsa
# create id_rsa & id_rsa.pub
# sign the user public key
ssh-keygen -U -s user_ca -V +2w -n devops -I 'SSH key for user devops' id_rsa.pub
# creates id_rsa-cert.pub
```

Available options:

* `-U` enables `ssh-agent` host support
* `-s $sign_key` CA user signing key 
* `-V $interval` validation interval (aka certificate life-time)
* `-I $key_id` "key identifier" that is logged by the server when the
  certificate is used for authentication

**Principles** are defined with option `-n`:

* By default, generated certificates are valid for all users or hosts.
* Generate a certificate for a specified set of principals

```bash
# allows user and root login
ssk-keygen ... -n root,devops ...
```

Additional limitations on the validity and use of user certificates may be
specified through **certificate options** with `-O`:

* Disable features of the SSH session
* Limit user to a particular source addresses
* Force the use of a specific command

## Server Configuration

Configure `sshd` to accept user keys signed by a SSH certificate authority:

* Copy the public certificate to the servers `/etc/ssh` directory
* Configure `TrustedUserCAKeys` in `/etc/ssh/sshd_config`

```bash
# copy the public certificate to the servers
scp user_ca.pub root@lxdev01:/etc/ssh
# make sshd trust the public CA certificate, and restart in debugging mode
ssh root@lxdev01 -C '
    echo TrustedUserCAKeys /etc/ssh/user_ca.pub >> /etc/ssh/sshd_config
    grep ^TrustedUserCAKeys /etc/ssh/sshd_config
    systemctl stop sshd
    $(which sshd) -d
'
```

## Usage

Connect with an private key identity, ssh will also try to load certificate
information from the filename obtained by appending `-cert.pub` to identity
filenames:

```bash
# for debugging
cat > ssh_config <<EOF
PasswordAuthentication=no
StrictHostKeyChecking=no
UserKnownHostsFile=/dev/null
EOF
# will implicitly load id_rsa-cert.pub if present
ssh -F ssh_config -v -i id_rsa devops@lxdev01
```

Debugging will show if the certificate is loaded:

```
Will attempt key: id_rsa RSA SHA256... explicit                    
Will attempt key: id_rsa RSA-CERT SHA256... explicit
```

And if the server accepted the key:

```
Offering public key: id_rsa RSA-CERT SHA256.... explicit
Server accepts key: id_rsa RSA-CERT SHA256... explicit
Authentication succeeded (publickey).
```

In case of a configuration problem following error message is emitted by `sshd`:

```
key_cert_check_authority: invalid
Certificate invalid: name is not a listed principal
```

Otherwise a successful login emits:

```
Accepted certificate ID "..." (serial 0) signed by RSA CA SHA256... via /etc/ssh/user_ca.pub
do_pam_account: called Accepted publickey for ... ssh2: RSA-CERT ID SSH key for user ... CA RSA SHA256...
```

