## SSH Host Fingerprints

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
