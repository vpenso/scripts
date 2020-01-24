# SSH Host Fingerprints

Fingerprint are based on the host public key.

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

The script ↴ [ssh-known-hosts][sshkh] adds, removes or updates a host
fingerprint in `~/.ssh/known_hosts`

First client connection includes **server host key discovery**:

* Fingerprint presented to the user for verification
* Accepting a fingerprint adds it to the `~/.ssh/known_hosts` **known host file**
* Fingerprint are associated to a specific hostname or IP address
* Breaking this association results in a security warning

Fingerprint **verification methods**:

* Fingerprints are checked by users, e.g. comparison to public web-site
* SSHFP (RFC4255) publishes fingerprints as DNS records
* Common anti pattern is "trust on first use"
  - Assumes that a host is trusted at the time of the first connection
  - Conditions users to always ignore the corresponding warning message

* The client automatically checks the fingerprint each login, and warns
  eventually
* Differing fingerprints (changed host key) indicate a potential
  man-in-the-middle attack
* Visual fingerprint, **identicons** (generated icons, to recognize or
  distinguish textual information)






[sshkh]: ../../bin/ssh-known-hosts
