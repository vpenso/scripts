# OpenSSH Host Certificates

_Host certificates can be used as alternative to host public key
authentication._

Hosts send signed SSH certificates to clients in order to enable the
**verification of the host's identity**:

* The host certificate is signed by a trusted Certificate Authority (CA)
* The host certificate includes host name (principle) and expiration date
* Clients check if a trusted CA signed the host certificate
* Trusted CA public keys are listed in `known_hosts`
* Warning on signature check failure or if a CA is not trusted 
* Clients don't store public keys for every host connection

**Generate a CA public key-pair** to sign host keys with `ssh-keygen`:

* Option `-f` defines the name of the (output) private key file 
* Option `-C` provides a comment to identify the CA key-pair

```bash
ssh-keygen -f devops-host_ca-$(mktemp -u XXXXXX) -C "Host signing key for DevOps"
# the public key gets .pub appended
```

Best practice is to have multiple sets of CA keys with different expiration
dates. This allows to revoke a key if required, while maintaining access to the
infrastructure. Generally it is useful to follow a naming convention like:

    <organisation>-<key_identifier>-<unique_id>

```bash
# the example above, would create a public and private key-pair like
devops-host_ca-Gb3t8s
devops-host_ca-Gb3t8s.pub
```

## Signing

```bash
# SSH client connection configuration
cat > ssh_config <<EOF
StrictHostKeyChecking=no
UserKnownHostsFile=/dev/null
EOF
# download the public host key from a node
scp -F ssh_config root@lxdev01:/etc/ssh/ssh_host_rsa_key.pub .
```

Use the CA key-pair to **sign the host public key** using the `ssh-keygen`
command:

* Option `-h` creates a host certificate instead of a user certificate
* Option `-s` specifies a path to a **CA private key file**
* Option `-V` specifies a **validity interval** when signing a certificate
* Option `-n` specifies one or more **principals** (host names)
* Option `-I` specifies an identification string used in log output

```bash
# sign the host key with the CA signing key
host_ca_private_key=$(ls | egrep -o 'devops-host_ca-[A-Za-z0-9-]{6}' | uniq)
ssh-keygen -h -s $host_ca_private_key \
           -V -1d:+52w \
           -n lxdev01,lxdev01.devops.test \
           -I 'lxdev01.devops.test host certificate' \
    ssh_host_rsa_key.pub
# upload the host certificate to the node
scp -F ssh_config ssh_host_rsa_key-cert.pub root@lxdev01:/etc/ssh
```

_The example above is just for illustration purpose, and not the recommended way
of distributing host certificates_

Inspect the host certificate:

```bash
» ssh-keygen -L -f ssh_host_rsa_key-cert.pub
ssh_host_rsa_key-cert.pub:
        Type: ssh-rsa-cert-v01@openssh.com host certificate
        Public key: RSA-CERT SHA256:iVBchuhVcTKvUA4XZb5ldnP2FMgiDKcqaIsWCq9ChIQ
        Signing CA: RSA SHA256:zTEUXG8CJ0j9l7s8wt1couYyHD+u8gFjpawbsNmxoFk
        Key ID: "lxdev01.devops.test host certificate"
        Serial: 0
        Valid: from 2020-01-23T11:26:51 to 2021-01-22T11:26:51
        Principals:
                lxdev01.devops.test
        Critical Options: (none)
        Extensions: (none)
```

## Host Configuration

**Enable a host certificate** in the `sshd` server configuration:

```bash
ssh -F ssh_config root@lxdev01 <<EOF
    echo HostCertificate=/etc/ssh/ssh_host_rsa_key-cert.pub >> /etc/ssh/sshd_config 
    echo LogLevel=DEBUG3 >> /etc/ssh/sshd_config
    sudo systemctl restart sshd
EOF
# follow the log information
ssh -F ssh_config root@lxdev01 -C journalctl -fu sshd
```

Cf. `sshd` manual page:

> `HostCertificate` specifies a file containing a public host certificate. 
The certificate's public key must match a private host key already specified 
by `HostKey`.

## Client Known Hosts

Clients use a host certificate to verify the node integrity with the CA public
key. Therefore **add the CA public key to `known_hosts` file**:

```bash
echo "@cert-authority * $(cat $host_ca_private_key.pub)" > ssh_known_hosts
```

The resulting file uses a wildcard to **match all hostnames** with the CA:

```
@cert-authority * ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnGv...
```

Cf. `sshd` manual page:

> Each line in these files contains the following fields: markers (optional),
hostnames, bits, exponent, modulus, comment... The fields are separated by
spaces... The **marker** is optional, but if it is present then it must be one
of “`@cert-authority`”, to indicate that the line contains a certification
authority (CA) key...

> Hostnames is a comma-separated list of patterns (`*` and `?` act as
wildcards); each pattern in turn is matched against the canonical host name

In order to test the configurations enable host key checking, and use the SSH
known host file create above:

```bash
cat > ssh_config <<EOF
StrictHostKeyChecking=yes
UserKnownHostsFile=ssh_known_hosts
EOF
# connect using the known hosts file
ssh -vvv -F ssh_config root@lxdev01
```

A successful host key verification will print following log information: 

```bash
debug1: Server host certificate: ... "lxdev01.devops.test host certificate" CA...
debug2: Server host certificate hostname: lxdev01
debug2: Server host certificate hostname: lxdev01.devops.test
debug3: hostkeys_foreach: reading file "ssh_known_hosts"
debug3: record_hostkey: found ca key type RSA in file ssh_known_hosts:1
debug3: load_hostkeys: loaded 1 keys from lxdev01
debug1: Host 'lxdev01' is known and matches the RSA-CERT host certificate.
debug1: Found CA key in ssh_known_hosts:1
```
