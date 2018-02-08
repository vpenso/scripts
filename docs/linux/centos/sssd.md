
Query information from an LDAP server 

```bash
# print the LDAP servers and searchbases from the configuration
grep -e ldap_uri -e search_base /etc/sssd/sssd.conf
# install LDAP client tools
yum install -y openldap-clients
# query the LDAP server
ldapsearch -x -ZZ -H ldap://$server -b $searchbase
```

## SSSD 

SSSD (System Security Services Daemon):

* Manages communication with identity and authentication providers
* Local clients connect to SSSD which connects to external information providers 
* Requires transport layer encryption against LDAP: LDAPS, TLS, or GSSAPI
* Enforces one-to-one relationships between identities and authentication service
* Support **automount**, **sudo**, and **ssh** (including host-keys)

Credential caching, offline authentication:

* Cache user, group, etc. information, and authentication credentials
* Reduces load on the authentication/identification servers
* Caching increases resilience against outages of LDAP, Kerberos servers

```bash
/etc/sssd/sssd.conf                 # configuration file
/var/log/sssd/                      # log files
/var/lib/sss/db/                    # cache files
sss_cache -E                        # clear the cache
automount -m                        # test automounter
sssd -c /etc/sssd/sssd.conf -d 9 -i # debug sssd in foreground
```

The **LDAP schema** defines:

* Default attribute names retrieved on the server
* The meaning of some of the attributes, notably membership attributes
* Most widely used schemas:
  - **rfc2307** (default) - Group members listed by name in the `memberUid` attribute
  - **rfc2307bis** - Group members are listed by in a multi-valued attribute member (or sometimes uniqueMember) 

```bash
>>> grep ldap_schema /etc/sssd/sssd.conf
ldap_schema = rfc2307
```



