# Domain Name System (DNS)


### Domain Name Space

Defines the overall naming structure of the Internet

- Tree structure of domain names (with the root domain at the top)
- Domain names **processed from right to left**, node labels **spearated by dots**
- Major domains (immediately below root) identifies the geography (i.e. `.de`) or purpose (i.e. `.org`)
- Domain names contain up to 255 chars and up to 127 node levels
- Absolute names are unique i.e. `en.wikipedia.org`

Name space tree divided into **zones**

- Contain domain names starting at a particular point in the tree
- Group of node servers linked by an **authoritative DNS server**
- A zone file contains pointers to **subdomains** delegating authority

**Resource Records** (RRs) store information about a domain:

- Start-of-Authority `SOA` - Indicates that this is the authoritative record for this domain
- Name Server `NS` - Indicates server to retrieve domain name space information
- Address `A` - IP address
- Mail eXchange `MX`- Mail server address for the domain name
- Canonical `CNAME` -  Name-to-name-to-IP address mapping for domain name aliasing

### Name Server

Maintains part of the domain name space 

- Stores the complete information about a zone, resolves lookups, maintains a cache



### Domain Name Resolution

Maps a domain name to an IP address (standardized language to query servers)
