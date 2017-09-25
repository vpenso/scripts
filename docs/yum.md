# RPM Packages

Packages use following name specification:

    name
    name.arch
    name-[epoch:]version
    name-[epoch:]version-release
    name-[epoch:]version-release.arch

Package repositories:

* [CentOS](https://www.centos.org/download/mirrors/)
* [Fedora](https://admin.fedoraproject.org/mirrormanager/)
* Fedora [EPEL](https://fedoraproject.org/wiki/EPEL)
* [ELRepo](http://elrepo.org)
* [CERN CentOS](http://linuxsoft.cern.ch/) (CC)



## Mirrors

Mirror CentOS packages on a (private) local mirror:

```bash
>>> yum -y install yum-utils createrepo                       # install the tools
>>> path=/var/www/html/centos/7/os/x86_64/                    # path ot the package repository
## repeat for all repo IDs to mirror
>>> yum repolist                                              # list repo IDs
>>> mkdir -p $path && createrepo $path                        # intialize CentOS base repo
>>> reposync -gml --download-metadata -r base -p $path        # sync repo
>>> createrepo -v --update $path/base -g comps.xml            # update repo after each sync
# deploy a web-server to host the repos
>>> yum -y install httpd && systemctl enable httpd && systemctl start httpd
# Grant access to the HTTP port, or disable the firewall 
>>> firewall-cmd --permanent --add-service=http && firewall-cmd --reload
>>> systemctl stop firewalld && systemctl disable firewalld
# Disable SELinux
>>> grep ^SELINUX= /etc/selinux/config
SELINUX=disabled
>>> setenforce 0 && sestatus
```

Periodic package mirror sync with Systemd units:

```bash
>>> cat /etc/systemd/system/reposync.service
[Unit]
Description=Mirror package repository

[Service]
ExecStart=/usr/bin/reposync -gml --download-metadata -r base -p /var/www/html/centos/7/os/x86_64/
ExecStartPost=/usr/bin/createrepo -v --update /var/www/html/centos/7/os/x86_64/base -g comps.xml
Type=oneshot
>>> cat /etc/systemd/system/reposync.timer 
[Unit]
Description=Periodically execute package mirror sync

[Timer]
OnStartupSec=300s
OnUnitInactiveSec=2h

[Install]
WantedBy=multi-user.target
>>> systemctl start reposync.timer
``` 
## Custom Repository

Create a local repository to host RPM packages:

```bash
>>> yum -y install yum-utils createrepo                       # install the tools
>>> path=/var/www/html/repo                                   # directory holding the repository
>>> mkdir -p $path && createrepo $path                        # intialize the package repository
## move RPM packages into $path
>>> createrepo --update                                       # update once packages have been added
```

Install and configure a web-server similar to the package mirror above.


# Yum

Yum is the Red Hat package manager 

```bash
yum repolist all                  # list package repositories
yum repolist enabled              # list enabled repos only
yum list                          # list all available packages
yum list <package>                # search for the specific package with name
yum --disablerepo='*' list available --enablerepo=<repo>
                                  # list package provided by a given repo
yum search <package>              # search all the available packages to match a name
yum info <package>                # information of a package
repoquery -l <package>            # list files in a package
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
yum groupinstall <package>        # install a group package
yum groupupdate <package>         # update group package
yum groupremove <package>         # delete a group package
yum list installed                # list installed packages
yum list available [<regex>]      # list all packages in all enabled repositories available to install
yum provides <path>               # find which package a specific file belongs to
yum makecache                     # update metadata for the currently enabled repositories
yum clean all                     # clean up all the repository metadata caches
```

Package rollback and package version lock:

```bash
yum --showduplicates list <package>     # show all versions of a package
repoquery --show-duplicates <package>
yum downgrade <package>-<version>       # rollback/downgrade a package to a specific version
yum install yum-plugin-versionlock      # install package lock Yum plugin
yum versionlock list                    # show all locks
yum versionlock <package>-<version>     # lock a package to a specific version
yum versionlcok delete <package>        # remove a lock
```

Exclude packages from updates in `/etc/yum.conf`:

```conf
[main]
....
exclude=<foo>* <bar>*
```


Transaction history

```bash
/var/lib/yum/history/                # history DB
yum history                          # list of twenty most recent transaction
yum history info <id>                # examine a particular transaction
yum history undo <id>                # revert slected transaction
yum history stats                    # overall statistics about the currently used history DB
yum history sync                  
yum history package-list <package>   # Trace history of a package
```

## Configuration

```bash
/etc/yum.conf                       # local global configuration file
/etc/yum.repos.d/*.repo             # configure individual repositories
/var/log/yum.log                    # log file
/var/cache/yum/                     # local package cache
```

Configure package repositories with:

```bash
yum-config-manager                      # display the current values of global yum options
yum-config-manager | grep '\[.*\]'      # list only the sections
yum-config-manager --add-repo <url>     # add a repository to /etc/yum.repos.d/
yum-config-manager --enable <repo>      # enable a repository
yum-config-manager --disable <repo>     # disable a repository
yum-config-manager | grep -e '\[.*\]' -e ^baseurl -e '^mirrorlist '
                                        # show URLs to the repositories 
yum clean metadata                      # delete all package repository metadata
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

[EPEL](https://fedoraproject.org/wiki/EPEL), install `epel-release` included in the CentOS Extras repository:

```bash
>>> yum -y install epel-release
>>> ls -1 /etc/yum.repos.d/epel*
/etc/yum.repos.d/epel.repo
/etc/yum.repos.d/epel-testing.repo
```

## Unattended Update

Keep repository metadata up to date, and check for, download, and apply updates

```bash
>>> yum install -y yum-cron      # install the package
# start/enable the service
>>> systemctl start yum-cron.service && systemctl enable yum-cron.service
# basic configuration
>>> egrep -v '^#|^$' /etc/yum/yum-cron-hourly.conf | grep update
update_cmd = default
update_messages = yes
download_updates = yes
apply_updates = yes
```

CentOS does not support `yum --security update` therefore the `update_cmd = default` is required.

# DNF

Package manager for RPM based distributions → [DNF on GitHub](https://github.com/rpm-software-management/dnf)

→ [Configuration Reference](http://dnf.readthedocs.org/en/latest/conf_ref.html)

```bash
/etc/dnf/dnf.conf                 # local main configuration
/var/cache/dnf                    # cache files
dnf repolist -v all               # list all repositories
dnf search <package>              # search for a package by name
dnf list <package
dnf list installed
dnf list recent
dnf info <package>
dnf install <package>
dnf install <rpm> 
dnf upgrade <package> 
dnf downgrade <package>
dnf erase <package>
```

## Transaction History

    » dnf history list 
    » dnf history info <id>
    » dnf history info <sid>[..<eid>]

Actions: (D)owngrade, (E)rase, (I)nstall, (O)bsoleting, (R)einstall, (U)pdate

Revert a transaction (uninstall, downgrade), redo a transaction as root

    » dnf history undo <id>
    » dnf history redo <id>

## Upgrades

Check for updates and install available packages

    » dnf check-update
    » dnf upgrade

→ [DNF Automatic](http://dnf.readthedocs.org/en/latest/automatic.html)

    » dnf install -yq dnf-automatic
    » grep apply_updates /etc/dnf/automatic.conf
    apply_updates = yes
    » systemctl enable dnf-automatic.timer && systemctl start dnf-automatic.timer
    » systemctl list-timers '*dnf-automatic*'

Clean up:

    » dnf list autoremove
    » dnf autoremove -y
    » dnf clean packages
    » dnf clean expire-cache


# Security Updates

## Red Hat

Red Hat **Security Advisories** (RHSA) inform customers about security flaws for all Red Hat products:

<https://access.redhat.com/security/security-updates/#/security-advisories>

RHSA are continuously published to a **announcement mailing list**:

<https://www.redhat.com/archives/rhsa-announce/>

Security issues receiving special attention by Red Hat are documented by **Vulnerability Responses**:

<https://access.redhat.com/security/vulnerabilities>

Data related to security is programmatically available with the Red Hat [Security Data API][rhsda]. Red Hat customers may have access to [Extended Update Support][rheus] (EUS) which provides update channels to stay with a minor version of the base OS. The support time frames are explained at Red Hat [Enterprise Linux Life Cycle][rhellc].

## CentOS

CentOS Security Advisories (CESA) are continuously published to the **announcement mailing list**:

<https://lists.centos.org/pipermail/centos-announce/>

CESA follows RHSA on its respective mailing-lists closely keeping the same naming convention.

**_Packages distributed by the CentOS repositories do not provide security information!_**

### CEFS

[CentOS Errata for Spacewalk][cefs] (CEFS) imports security errata information from the CentOS announce mailing list and provides it to a [Spacewalk](http://spacewalk.redhat.com/) server. Following scripts are bases on the security [errata XML file][cefsxml] published by CEFS.

1. The script [generate_updateinfo][cefsgu] creates an `updateinfo.xml` file to be published on a CentOS package repository mirror.
2. The [Centos-Package-Cron][cefscpc] reports advisories by mail related to packages installed on a specific node.







[rhsda]: https://access.redhat.com/documentation/en-us/red_hat_security_data_api/0.1/html-single/red_hat_security_data_api/
[rheus]: https://lists.centos.org/pipermail/centos-announce/
[rhellc]: https://access.redhat.com/support/policy/updates/errata/
[cefs]: http://cefs.steve-meier.de/ 
[cefsxml]: http://cefs.steve-meier.de/errata.latest.xml
[cefsgu]: https://github.com/vmfarms/generate_updateinfo
[cefscpc]: https://github.com/wied03/centos-package-cron


