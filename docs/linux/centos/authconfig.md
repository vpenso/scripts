
Configure what kind of data store to use for user credentials

```bash
yum install -y authconfig       # install package
authconfig --test ...           # display changes, don't apply
authconfig --update ...         # write configuration changes
```

Changing the authentication settings incorrectly can lock users out of the system.

```bash
# backup of all configuration files
authconfig --savebackup=/tmp/authconfig-backup.$(date +%Y%m%d)
# restore configuration
authconfig --restorebackup=...
```

```bash
# enable Kerberos
authconfig --enablekrb5 --update
# enable local authentication options from /etc/security/access.conf
authconfig --enablepamaccess --update
```

