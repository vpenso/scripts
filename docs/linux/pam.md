# PAM

Types of PAM services:

* Authentication service modules.
* Account management modules.
* Session management modules.
* Password management modules.

Services register with PAM in `/etc/pam.d/`.

Service file are divided into three columns per line:

* **Management group**
  - `auth` validates users (who the user is and if that user has a valid account)
  - `account` (authorization) controls the access to the service (if the user is allowed access)
  - `session` is responsible for the service environment
  - `password` for password updating
* **Control flags**
  - `requisite` return failure if module not found or failed to load
  - `required` like requisite, but continues loading other modules
  - `sufficient` if the module return success, stop processing other modules
  - `optional` ignore in case of failure
* **Module** (`.so` file) used

Service files list all PAM modules that should be used 
to implement the access policy, called a **stack**

* Module are invoked in the order listed
* Each module can return _success_ or _failure_
* Results of all the modules are combined into a single result
* Combination is controlled by the “control-flag”
* Authorization is determined with `auth` and `account`
* Generally, if any one module “fails” access is denied

```bash
/etc/pam.d/                            # PAM configuration
/etc/security                          # PAM module configuration
```

### CentOS

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
# enable Kerberos
authconfig --enablekrb5 --update
# enable local authentication options
authconfig --enablepamaccess --update
```

### Access Control

`/etc/security/access.conf` specifies login access control:

- On login file is scanned for the first entry that matches
- Three fields separated by a `:` (colon) character... `<permission> : <users/groups> : <origins>`
  - first... `+` access granted or `-` access denied
  - second... list of one or more login names, group names, or `ALL`
  - third... list of host names, domain names (begin with `.`), IP addresses, etc.


# References

[pamad] PAM System Administrators' Guide  
http://linux-pam.org/Linux-PAM-html/Linux-PAM_SAG.html
