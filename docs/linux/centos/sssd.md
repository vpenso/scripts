
Query information from an LDAP server 

```bash
# print the LDAP servers and searchbases from the configuration
grep -e ldap_uri -e search_base /etc/sssd/sssd.conf
# install LDAP client tools
yum install -y openldap-clients
# query the LDAP server
ldapsearch -x -ZZ -H ldap://$server -b $searchbase
```

The **LDAP schema** defines:

* Default attribute names retrieved on the server
* The meaning of some of the attributes, notably membership attributes
* Most widely used schemas:
  - **rfc2307** (default) - Group members listed by name in the `memberUid` attribute
  - **rfc2307bis** - Group members are listed by in a multi-valued attribute member (or sometimes uniqueMember) 

SSSD (System Security Services Daemon):

* Uses a parent-child process monitoring model
* Starts a separate daemon handler for each service

```bash
/etc/sssd/sssd.conf                 # configuration file
/var/log/sssd/                      # log files
/var/lib/sss/db/                    # cache files
sss_cache -E                        # clear the cache
automount -m                        # test automounter
sssd -c /etc/sssd/sssd.conf -d 9 -i # debug sssd in foreground
```

