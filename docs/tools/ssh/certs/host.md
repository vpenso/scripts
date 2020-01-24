# OpenSSH Host Certificates

Host certificates can be used as alternative to host public key authentication.

Hosts send signed SSH certificate to clients in order to enable the
**verification of the host's identity**. 

* The host certificate is signed by a trusted Certificate Authority (CA)
* The host certificate includes host name (principle) and expiration date
* Clients check if a trusted CA (listed in `known_hosts`) has signed the
  host certificate (using the CA public key)
* Clients don't store public keys for every host connection. Only the public
  keys of trusted certificate authorities.
* Either a signature check failed or if the CA is not trusted emits a warning 

Generate a CA **public key to sign host keys** with `ssh-keygen`:

* Option `-f` defines the name of the (output) private key file (the public key
  gets `.pub` appended) 
* Option `-C` provides a comment to identify the CA key-pair

```bash
ssh-keygen -f devops-host_ca-$(mktemp -u XXXXXX) -C "Host signing key for DevOps"
```

Best practice is to have multiple sets of CA keys with different expiration
dates. This allows to revoke a key if required, while maintaining access to the
infrastructure. Generally it is useful to follow a naming convention like:

```bash
<organisation>-<key_type>-<unique_id>
# the example above, would create a public and private key like
devops-host_ca-Gb3t8s
devops-host_ca-Gb3t8s.pub

```

## Host Key Signing

Use the CA key-pair to sign the host public key using the `ssh-keygen` command:

* Option `-h` creates a host certificate instead of a user certificate
* Option `-s` specifies a path to a **CA private key file**
* Option `-V` specifies a **validity interval** when signing a certificate
* Option `-n` specifies one or more **principals** (host names)
* Option `-I` specifies an identification string used in log output

```bash
# SSH client connection configuration
cat > ssh_config <<EOF
StrictHostKeyChecking=no
UserKnownHostsFile=/dev/null
EOF
# download the public host key from a node
scp -F ssh_config root@lxdev01:/etc/ssh/ssh_host_rsa_key.pub .
# sign the host key with the CA signing key
ssh-keygen -h -s devops-host_ca-Gb3t8s \
           -V -1d:+52w \
           -n lxdev01.devops.test \
           -I 'lxdev01.devops.test host certificate' \
    ssh_host_rsa_key.pub
# upload the host certificate to the node
scp -F ssh_config ssh_host_rsa_key-cert.pub root@lxdev01:/etc/ssh
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

