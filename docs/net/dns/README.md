# Domain Name System (DNS)

### Domain Name Space

Defines the overall naming structure of the Internet

- **Tree structure** of domain names (with the root zone at the top)
- Domain names **processed from right to left**, node labels **spearated by dots**
- Top-level Domain Names (TLDs) maintained by IANA Root Zone Database [rzd]
  - Structure described in Domain Name System Structure and Delegation (rfc1591)
  - Country code TLDs (ccTLD) identify geography, by two letter country codes i.e. `.de`, `.uk`, etc.
  - Generic TLDs hint at a purpose i.e. `.org`, `.com`, etc.
- Domain names contain up to 255 chars and up to 127 node levels
- Absolute names are unique i.e. `en.wikipedia.org`

Name space tree divided into **zones**

- Contain domain names starting at a particular point in the tree
- Group of node servers linked by an **authoritative** DNS server
- A zone file contains pointers to **subdomains** delegating authority

**Resource Records** (RRs) store information about a domain:

- Start-of-Authority `SOA` - Indicates that this is the authoritative record for this domain
- Name Server `NS` - Indicates server to retrieve domain name space information
- Address `A` - IP address
- Mail eXchange `MX`- Mail server address for the domain name
- Canonical `CNAME` -  Name-to-name-to-IP address mapping for domain name aliasing

### Name Server

Maintains part of the domain name space (stores the complete information about a zone)

- Listens for DNS queries, and **responds with local zone data**
- Caches (recently retrieved) data about domains outside its name space
- Uses its resolver to **forward queries** to other authoritative name servers

**Primarey** name servers hold “authoritative” information about set of domains

- Signals the change to a secondary name server (increment serial number filed in SOA)
- **Secondary** name servers maintain a copy of zone information from a primary name server using a process called **zone transfer**
- Zone transfer performed according to the expire time parameter in SOA
  - Full Zone Transfer - Secondary downloads all RRs
  - Incremental Zone Transfer - Primary notifies (IXFR protocl) about changes for an partial download
  - Dynamic DNS (DDNS) allows DHCP server to send updates to primary DNS server

### Domain Name Resolution

Maps a domain name (human readable) to an IP address (machine readable)

- **Resolution** - Is the process of obtaining answers from the DNS database (in respons to queries)
- **Resolvers** - Maps a domain name to an IP address that identifies the domains hosted location
- Domains resolved segment by segment from the highest-level domain down (eventually queries server DNS servers)

**DNSSEC** (Domain Name System Security Extensions) enable resolvers to **authenticate DNS data**

- Provides data integrity, but not availability or confidentiality
- **DNS over TLS** (DoT) is a protocol to encrypting DNS resolution, cf. RFC7858 [dot]

## Reference

[dot] Specification for DNS over Transport Layer Security (TLS)  
<https://tools.ietf.org/html/rfc7858>

[rzd] IANA Root Zone Database  
<http://data.iana.org/TLD/tlds-alpha-by-domain.txt>
