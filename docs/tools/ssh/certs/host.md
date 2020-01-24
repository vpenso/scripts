# OpenSSH Host Certificates

Hosts send a signed SSH certificate to clients to **verify the host's identity**. 
This is an alternative to the use of public key authentication for hosts.

* The host certificate is signed by a trusted Certificate Authority (CA)
* The host certificate Includes host name and expiration date
* Client checks if a trusted CA (listed in `known_hosts`) has signed the
  host certificate (using the CA public key)
* Client does not store public key for every host connection, only trusted
  certificate authorities
* Either a signature check failed or if the CA is not trusted emits a warning 

Creating a Root Certificate

```bash
ssh-keygen -b 4096 -t rsa -f devops.ca -C "CA key for devops"
# writes certificate to $PWD
```

Keep the signing key safe (in the example above a file called `devops.ca`).

Separate user and host certificate authorities.

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

