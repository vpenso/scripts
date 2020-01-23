SSH Certificate Authority:

* Alleviates the need to distribute SSH public keys
* Signs user keys with capabilities and expiration date
* Signs host keys for a domain

## Creating a Root Certificate

_Does not use the more common X.509 certificates used in SSL_

```bash
ssh-keygen -b 4096 -t rsa -f devops.ca -C "CA key for devops"
# writes certificate to $PWD
```

Keep the signing key safe (in the example above a file called `devops.ca`).

Separate user and host certificate authorities.

### Validity Interval

The validity interval is specified like `<start_time>:<end_time>`

* Start time `always` (no specified start time)
* End time `forever` (never expire)
* Date format is `YYYYMMDD`, time format `YYYYMMDDHHMM[SS]`
* Relative time starting with `+` or `-`, suffix `w` (week) `d` (day) `m`
  (minute)

```bash
+1w1d           # valid from node to 1 week and 1 day
-4w:+4w         # valid from four weeks ago to four weeks from now
-1d:20201231    # valid from yesterday to midnight December 31st 2020
-1m:forever     # valid from one minute ago and never expiring
```

### Signing

Sign the RSA public **host key** on `localhost`:

```bash
fqdn=$(hostname -f)
ssh-keygen -h -s devops.ca -V -1d:forever -n $fqdn -I $fqdn.key \
        /etc/ssh/ssh_host_rsa_key.pub
# -h   sign host key
# -s   signing key
# -n   host name
# -V   validity interval
# -I   identifier for the signed key
# creates /etc/ssh/ssh_host_rsa_key-cert.pub
```

Sign a **user key**:

```bash
ssh-keygen -n user -s devops.ca -V +2w -I devops-user-${USER} ~/.ssh/id_rsa.pub
# view enabled extensions, principals, and metadata of the signed key
ssh-keygen -Lf ~/.ssh/id_rsa-cert.pub
```

## Host Certificates

Add a host certificate to the `sshd` server configuration:

```bash
cat <<EOF | sudo tee -a /etc/ssh/sshd_config
HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub
EOF
```

The client use the certificate to verify the node integrity with the CA public
key. Therefore add the CA public key to `~/.ssh/known_hosts`:

```bash
cat <<EOF | tee -a ~/.ssh/known_hosts
@cert-authority *.devops.test $(cat devops.ca.pub)
EOF
```

## User Certificates

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
ssh-keygen -s user_ca -V +2w -n devops -I 'SSH key for user devops' id_rsa.pub
# creates id_rsa-cert.pub
```

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
    systemctl restart sshd
'
```

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

