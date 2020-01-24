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

* Option `-f` defines the name of the private key file (the public key gets
  `.pub` appended) 
* Option `-C` provides a comment to identify the CA key

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




Keep the signing key safe (in the example above a file called `devops.ca`).

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

