# RPM Packages

Packages use following name specification:

    name
    name.arch
    name-[epoch:]version
    name-[epoch:]version-release
    name-[epoch:]version-release.arch

## Mirrors

Mirror CentOS packages on a (private) local mirror:

```bash
yum -y install yum-utils createrepo                       # install the tools
path=/var/www/html/centos/7/os/x86_64/                    # path ot the package repository
## repeat for all repo IDs to mirror
yum repolist                                              # list repo IDs
mkdir -p $path && createrepo $path                        # intialize CentOS base repo
reposync -gml --download-metadata -r base -p $path        # sync repo
createrepo -v --update $path/base -g comps.xml            # update repo after each sync
# deploy a web-server to host the repos
yum -y install httpd && systemctl enable httpd && systemctl start httpd
# Grant access to the HTTP port, or disable the firewall 
firewall-cmd --permanent --add-service=http && firewall-cmd --reload
systemctl stop firewalld && systemctl disable firewalld   
```

# Yum

```
yum repolist all                  # list package repositories
yum list                          # list all available packages
yum list <package>                # search for the specific package with name
yum search <package>              # search all the available packages to match a name
yum info <package>                # information of a package
repoquery -l <package>            # list files in a package
yum -y install <package>          # install package by name (assume yes)
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
yum provides <path>               # find which package a specific file belongs to
yum clean all                     # clean up all the cache
yum history                       # transaction history
```

## Configuration

```bash
/etc/yum.conf                     # local main configuration file
/etc/yum.repos.d/*.repo           # configure individual repositories
/var/log/yum.log                  # log file
/var/cache/yum/                   # local package cache
```

Configure package repositories:

```bash
yum-config-manager --add-repo <url>     # add a repository
yum-config-manager --enable <repo>      # enable a repository
yum-config-manager --disable <repo>     # disable a repository
```

## Unattended Update

Keep repository metadata up to date, and check for, download, and apply updates

```bash
>>> yum install -y yum-cron      # install the package
# start/enable the service
>>> systemctl start yum-cron.service && systemctl enable yum-cron.service
# basic configuration
>>> egrep -v '^#|^$' /etc/yum/yum-cron-hourly.conf | grep update
update_cmd = security
update_messages = yes
download_updates = yes
apply_updates = yes
```

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

