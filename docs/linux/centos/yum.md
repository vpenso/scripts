# RPM Packages

Packages use following name specification:

    name
    name.arch
    name-[epoch:]version
    name-[epoch:]version-release
    name-[epoch:]version-release.arch

# Yum

Yum is the Red Hat package manager 


Search & Information

```bash
yum search <package>              # search all the available packages to match a name
yum list                          # list all available packages
yum list <package>                # search for the specific package with name
yum --disablerepo='*' list available --enablerepo=<repo>
                                  # list package provided by a given repo
yum info <package>                # information of a package
repoquery -l <package>            # list files in a package
```

Install & Update:

```bash
yum -y install <package>          # install package by name (assume yes)
yum -y install --nogpgcheck <package> 
                                  # install unsigned packages by name (assume yes)
yum remove <package>              # delete package
yum check-update                  # find how many of installed packages have updates available
yum check-update --security       # check for security-related updates
yum update --security             # update those packages which are affected by security advisories
yum -y update                     # update all outdated packages
yum update <package>              # update package to latest version
yum grouplist                     # list available group packages
yum group info <group>            # show packages in group
yum groupinstall <group>          # install a group package
yum groupupdate <group>           # update group package
yum groupremove <group>           # delete a group package
yum list installed                # list installed packages
yum list available [<regex>]      # list all packages in all enabled repositories available to install
yum provides <path>               # find which package a specific file belongs to
```

Recover from errors:

```bash
rpm --rebuilddb                   # Error: rpmdb open failed
```

### Versions

```bash
yum --showduplicates list <package>     # show all versions of a package
repoquery --show-duplicates <package>
yum install <package>-<verison>
yum downgrade <package>-<version>       # rollback/downgrade a package to a specific version
```

Version **lock**:

```bash
yum install -y yum-plugin-versionlock   # install package lock Yum plugin
/etc/yum/pluginconf.d/versionlock.conf  # configuration file
/etc/yum/pluginconf.d/versionlock.list  # package list format EPOCH:NAME-VERSION-RELEASE.ARCH
yum versionlock list                    # show all locks
yum versionlock <package>*-<version>    # lock a package to a specific version
yum versionlcok delete <package>        # remove a lock
yum versionlock clear                   # remove all versionlocks
```

Exclude packages from updates in `/etc/yum.conf`:

```conf
[main]
....
exclude=<foo>* <bar>*
```

### History

Show the **changelog** of a package:

```bash
yum install yum-plugin-changelog
yum changelog all <package>
```

**Transaction history**:

```bash
/var/lib/yum/history/                     # history DB
yum history                               # list of twenty most recent transaction
yum history | grep '\*\*'                 # search for aborted transactions
yum history info <id>                     # examine a particular transaction
yum history undo <id>                     # revert slected transaction
yum history stats                         # overall statistics about the currently used history DB
yum history sync                  
yum history package-list <package>        # Trace history of a package
yum history redo force-reinstall <id>     # force reinstall of the failed yum transaction
```
```bash
yum-complete-transaction                  # completes unfinished yum transactions which occur due to error, failure
yum-complete-transaction --cleanup-only   # do not complete the transaction just clean up
```

Possible action executed in the transaction:

Value | Action	      | Description
------|---------------|--------------------
I     |	Install	      | Package(s) installed.
U     |	Update	      | Package(s) updated to a newer version.
E     |	Erase	      | Package(s) removed.
D     |	Downgrade     | Package(s) downgraded to an older version.
O     |	Obsoleting    | Package(s) marked as obsolete.
R     |	Reinstall     |Package(s) reinstalled.

The number of altered packages can be followed by a code:

Value |Description
------|-------------
`<`   | The rpmdb database was changed outside Yum before the transaction ending.
`>`   | The rpmdb database was changed outside Yum after the transaction ended.
`*`   | The transaction aborted before completion.
`#`   | Finished successfully, but yum returned a non-zero exit code.
`E`   | Finished successfully, but an error or a warning was displayed.
`P`   | Finished successfully, but problems already existed in the rpmdb database.
`s`   | Finished successfully, but the –skip-broken command-line option was used and certain packages were skipped.


## Configuration

Files & Directories:

```bash
/etc/yum.conf                       # local global configuration file
/etc/yum.repos.d/*.repo             # configure individual repositories
/var/log/yum.log                    # log file
/var/cache/yum/                     # local package cache
```

Metadata & Cache:

```bash
yum makecache                     # update metadata for the currently enabled repositories
yum clean metadata                # delete all package repository metadata
yum clean all                     # clean up all the repository metadata & caches
```

Inspection:

```bash
yum repolist all                        # list package repositories
yum repolist enabled                    # list enabled repos only
yum repo-pkgs <repo> list               # list all packages in a repository
yum-config-manager                      # display the current values of global yum options
yum-config-manager | grep '\[.*\]'      # list only the sections
yum-config-manager --add-repo <url>     # add a repository to /etc/yum.repos.d/
yum-config-manager --enable <repo>      # enable a repository
yum-config-manager --disable <repo>     # disable a repository
yum-config-manager | grep -e '\[.*\]' -e ^baseurl -e '^mirrorlist '
                                        # show URLs to the repositories 
```

Site local repository configuration file:

```bash
>>> cat /etc/yum.repos.d/site-local.repo
[site-local]
name=site-local
baseurl=http://lxrepo01.devops.test/repo
enabled=1
gpgcheck=0
```

## Yum-Cron

Keep repository metadata up to date, and check for, download, and apply updates

Enable the service:

```bash
>>> yum install -y yum-cron      # install the package
# start/enable the service
>>> systemctl start yum-cron.service && systemctl enable yum-cron.service
# configuration files
>>> find /etc/yum/* -name '*cron*'
/etc/yum/yum-cron.conf
/etc/yum/yum-cron-hourly.conf
# cronjobs executing yum-cron
>>> find /etc/cron* -name '*yum*'
/etc/cron.daily/0yum-daily.cron
/etc/cron.hourly/0yum-hourly.cron
```

Configure `download_updates` and `apply_updates` to **enable the package updates**:

* CentOS does not support `yum --security update` therefore the `update_cmd = default` is required
* Install new **GPG keys** by packages automatically with `assumeyes = True`

```bash
>>> grep -e ^update_cmd -e ^download -e ^apply /etc/yum/*cron*.conf
/etc/yum/yum-cron.conf:update_cmd = default
/etc/yum/yum-cron.conf:download_updates = yes
/etc/yum/yum-cron.conf:apply_updates = no
/etc/yum/yum-cron-hourly.conf:update_cmd = default
/etc/yum/yum-cron-hourly.conf:download_updates = yes
/etc/yum/yum-cron-hourly.conf:apply_updates = yes
>>> grep ^assume /etc/yum/*cron*
/etc/yum/yum-cron-hourly.conf:assumeyes = True
```


Trouble shooting:

```bash
# check if the cronjobs are executed...
>>> grep yum /var/log/cron
# execute yum-cron with a configuration file...
>>> /usr/sbin/yum-cron /etc/yum/yum-cron-hourly.conf
```
# DNF

Package manager for RPM based distributions → [DNF on GitHub](https://github.com/rpm-software-management/dnf)

→ [Configuration Reference](http://dnf.readthedocs.org/en/latest/conf_ref.html)

```bash
/etc/dnf/dnf.conf                 # local main configuration
/var/cache/dnf                    # cache files
dnf repolist -v all               # list all repositories
dnf search <package>              # search for a package by name
dnf list <package>
dnf list installed
dnf list recent
dnf info <package>
dnf install <package>
dnf install <rpm> 
dnf upgrade <package> 
dnf downgrade <package>
dnf erase <package>
dnf repoquery -l <package>        # list files within a package
```

Actions: (D)owngrade, (E)rase, (I)nstall, (O)bsoleting, (R)einstall, (U)pdate

```bash
dnf history list 
dnf history info <id>
dnf history info <sid>[..<eid>]
dnf history undo <id>                 # revert a transaction (uninstall,downgrade)
dnf history redo <id>
```


## Upgrades

```bash
dnf check-update
dnf upgrade
## ...clean up...
dnf list autoremove
dnf autoremove -y
dnf clean packages
dnf clean expire-cache
```

→ [DNF Automatic](http://dnf.readthedocs.org/en/latest/automatic.html)

```bash
>>> dnf install -yq dnf-automatic
>>> grep apply_updates /etc/dnf/automatic.conf
apply_updates = yes
>>> systemctl enable --now dnf-automatic-install.timer
>>> systemctl list-timers '*dnf-automatic*'
```

# References

RPM Packaging Guide  
https://rpm-packaging-guide.github.io/

