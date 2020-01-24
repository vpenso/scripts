## SSH Certificates

_Does not use the more common X.509 certificates used in SSL_

OpenSSH certificates are an extension build using public keys.

The Certificate Authority (CA) is a special trusted party holding own
public-private key-pairs. 

* Alleviates the need to distribute SSH public keys
* Not used for authentication, only to sign SSH certificates
* Signs user keys with capabilities and expiration date
* Signs host keys for a domain

Certificates include:

* Nonce - unique ID to prevent signature collision attacks
* Public Key - associated with a private key
* Type - identifies user or host certificates
* Key ID - identifies the user or host in loge messages
* (Valid) Principles - list of user or host names
* Validity Interval - start time, and expiration date
* Critical Options - supported client requests
* Extensions - optional SSH extensions
* Signature Key - CA public key, used to sign certificate (with private key)
* Signature - CA issued signature of all preceding fields

## Configuration


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

