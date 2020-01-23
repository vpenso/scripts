SSH Certificate Authority:

* Alleviates the need to distribute SSH public keys
* Signs user keys with capabilities and expiration date
* Signs host keys for a domain

### Creating a Root Certificate

_Does not use the more common X.509 certificates used in SSL_

```bash
ssh-keygen -b 4096 -t rsa -f devops.ca -C "CA key for devops"
# writes certificate to $PWD
```

Keep the signing key safe (in the example above a file called `devops.ca`).

## Signed Host Keys

Sign the RSA public host key on `localhost`:

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

The **validity interval** is specified like `<start_time>:<end_time>`

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

Add the generated certificate to the `sshd` server configuration:

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



