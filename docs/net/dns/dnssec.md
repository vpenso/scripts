* Mechanism for including cryptographic signatures within the DNS resolution 
* Adds DNS Resource Records (RRs): 
  - `RRSIG` signature
  - `DNSKEY` primary key record for zone
  - `DS` key record fingerprint
  - `NSEC3`  sign negative responses
* Resolvers verify DNS resolution with with the root zone public key, IANA [Trust Anchors and Keys](https://www.iana.org/dnssec/files)

```bash
dig +trace <url> | grep -e RRSIG -e DS            # check for DNSSEC capability
dig org. SOA +dnssec @8.8.8.8 | grep ';; flags'   # ^ should return the "ad" flag
```

