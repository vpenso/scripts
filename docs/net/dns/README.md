# Domain Name System (DNS)


## Domain Name Space

Defines the overall naming structure of the Internet:

- **Tree structure** of domain names (with the root zone at the top)
- Domain names **processed from right to left**, node labels **spearated by dots**
- Top-level Domain Names (TLDs) maintained by IANA Root Zone Database [rzd]
  - Structure described in Domain Name System Structure and Delegation (rfc1591)
  - Tow lettes (country code) ccTLDs identify geography i.e. `.de`, `.uk`
  - (Generic) gTLDs hint at a purpose i.e. `.org`, `.com`
- Domain names contain up to 255 chars and up to 127 node levels
- Absolute names are unique i.e. `en.wikipedia.org`

### Domain Name Registry

Different entities providing DNS services:

* **Domain Registrar** - Service to select (purchase) a domain name
  - Managed by the IANA (part of ICANN), nonprofit organizations, runs the root zone management
  - Registers an IP address of a DNS server that authoritatively respond for a domain
  - The `whois` command queries the domain name registry
* **DNS Hosting Provider** - Service operating authoritative response for a domain

### Zones

Name space tree divided into **zones**:

- Contain domain names starting at a particular point in the tree
- Group of node servers linked by an authoritative DNS server
- A zone file contains pointers to **subdomains** delegating authority

### Resource Records 

Resource Records (RRs) store domain specifc DNS data:

- Start-of-Authority `SOA` - Indicates that this is the authoritative record for this domain
- Name Server `NS` - Indicates server to retrieve domain name space information
- Address `A` - IP address
- Mail eXchange `MX`- Mail server address for the domain name
- Canonical `CNAME` -  Name-to-name-to-IP address mapping for domain name aliasing

## Domain Name Servers

Domain name servers resolve DNS information:

- Listens for DNS queries, **responds** with local (zone) or cached DNS data
- Caches (recently retrieved) data about non-local domains (from other zones)
- Uses its resolver to **forward queries** to other (authoritative) domain name servers

**Primarey** name servers hold **authoritative** information about set of domains:

- **Secondary** servers maintain a copy of zone information, using a process called **zone transfer**
  - Zone transfer performed according to the expire time parameter in SOA
  - Full Zone Transfer - Secondary downloads all RRs
  - Incremental Zone Transfer - Primary notifies about changes for an partial download
- Dynamic DNS (DDNS) allows DHCP server to send updates to primary DNS server

**Split(-horizon) DNS** send a distinguished responds to DNS queries depending on the client source address

- Mechanism for security/privacy management by logical/physical separation of DNS information
- Used to separate public (external) DNS resolution from internal local networks (not visible from the Internet)

## Domain Name Resolution

Maps a domain name (human readable) to an IP address (machine readable)

- **Resolvers** maps a domain name to an IP address that identifies the domains hosted location
- **Resolution** is the process of obtaining answers from the DNS database (in responds to a DNS query)
- Domains resolved segment by segment from the highest-level domain down (eventually querying many (authoritative) DNS servers)

**DNSSEC** (Domain Name System Security Extensions) enables DNS resolvers to **authenticate DNS infromation**

* Provides data integrity, but not availability or confidentiality
* Mechanism for including cryptographic signatures within the DNS resolution 
* Adds DNS Resource Records (RRs): 
  - `RRSIG` signature
  - `DNSKEY` primary key record for zone
  - `DS` key record fingerprint
  - `NSEC3`  sign negative responses
* Resolvers verify DNS resolution with with the root zone public key, IANA Trust Anchors and Keys [tak]

```bash
dig +trace <url> | grep -e RRSIG -e DS            # check for DNSSEC capability
dig org. SOA +dnssec @8.8.8.8 | grep ';; flags'   # ^ should return the "ad" flag
```

**DNS over TLS** (DoT) is a protocol to encrypting DNS resolution, cf. RFC7858 [dot]

## Reference

[dot] Specification for DNS over Transport Layer Security (TLS)  
<https://tools.ietf.org/html/rfc7858>

[rzd] IANA Root Zone Database  
<http://data.iana.org/TLD/tlds-alpha-by-domain.txt>

[tak] IANA Trust Anchors and Keys  
<https://www.iana.org/dnssec/files>
