
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
```

`yum-config-manager` is part of the `yum-utils` package:

```bash
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

## Hosting

Simple **HTTP server** setup:

```bash
yum -y install httpd
rm /etc/httpd/conf.d/welcome.conf
systemctl enable --now httpd
# grant access to the HTTP port, or disable the firewall 
firewall-cmd --permanent --add-service=http && firewall-cmd --reload
systemctl stop firewalld && systemctl disable firewalld
# disable SELinux
>>> grep ^SELINUX= /etc/selinux/config
SELINUX=disabled
>>> setenforce 0 && sestatus
```

### Mirror

Utilities to install:

* `reposync` - used to synchronize remote yum repositories to a 
  local directory, using yum to retrieve the packages
* `createrepo` - Create repomd (xml-rpm-metadata) repository

```bash
yum -y install yum-utils createrepo
```

Synchronize CentOS YUM repositories to the local directories

```bash
mkdir -p /var/www/html/centos/{base,updates}
reposync --downloadcomps \
         --plugins \
         --gpgcheck \
         --download-metadata \
         --repoid=base \
         --repoid=updates \
         --download_path=/var/www/html/centos
# create a new repodata for the local repositories
for repo in base updates
do
        createrepo --verbose\
                   --update \
                   --groupfile comps.xml \
                   /var/www/html/centos/$repo 
done
```

Create a systemd service unit [2] to execute `reposync` and `createrep`:

```bash
cat > /etc/systemd/system/reposync-centos.service <<EOF
[Unit]
Description=Mirror package repository

[Service]
ExecStart=/usr/bin/reposync -gml --download-metadata -r base -r updates -p /var/www/html/centos
ExecStartPost=/usr/bin/createrepo -v --update /var/www/html/centos/base -g comps.xml
ExecStartPost=/usr/bin/createrepo -v --update /var/www/html/centos/updates
Type=oneshot
EOF
```

Use a systemd timer unit [3] to periodically execute the service above:

```bash
cat > /etc/systemd/system/reposync-centos.timer <<EOF
[Unit]
Description=Periodically execute package mirror sync

[Timer]
OnStartupSec=300s
OnUnitInactiveSec=2h

[Install]
WantedBy=multi-user.target
EOF
``` 

### Full Mirror Sync

Full mirror (of a file-system) including ISO images and network install:

```bash
mkdir /var/www/html/centos
rsync --verbose \
      --archive \
      --compress \
      --delete \
      rsync://linuxsoft.cern.ch/centos \
      /var/www/html/centos
```

Note: You can use any CentOS mirror [1] with an `rsync://` endpoint.

Create a systemd service unit [2] to execute `rsync`:

```bash
# write a unit file to execute rsync
cat > /etc/systemd/system/rsync-centos-mirror.service <<EOF
[Unit]
Description=Rsync CentOS Mirror

[Service]
ExecStartPre=-/usr/bin/mkdir -p /var/www/html/centos
ExecStart=/usr/bin/rsync -avz --delete rsync://linuxsoft.cern.ch/centos /var/www/html/centos
Type=oneshot
EOF
# load the configuration
systemctl daemon-reload
# start rsync
systemctl start rsync-centos-mirror
# follow the rsync log...
journalctl -f -u rsync-centos-mirror
```

Use a systemd timer unit to periodically execute the service above:

```bash
cat > /etc/systemd/system/rsync-centos-mirror.timer <<EOF
[Unit]
Description=Periodically Rsync CentOS Mirror

[Timer]
OnStartupSec=300s
OnUnitInactiveSec=2h

[Install]
WantedBy=multi-user.target
EOF
# enable and start the timer unit
systemctl daemon-reload
systemctl enable --now rsync-centos-mirror.timer
# check the date for next activation
systemctl list-timers rsync*
```

# Partial Mirror

```bash
# create a list of packages to include
packages=$(
        rpm -qa --qf '\t%{NAME}.%{ARCH}\n' \
                | head -n10 \
                | tr -d '\t' \
                | tr '\n' ' ' \
                | sort \
)
# write a configuration file
cat > reposync.conf <<EOF
[main]
gpgcheck=1
reposdir=/dev/null

[base]
name = base
baseurl = http://mirror.centos.org/centos-7/7/os/x86_64/
enabled = 1
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
includepkgs=$packages
EOF
mkdir packages
reposync --config=reposync.conf \
         --downloadcomps \
         --newest-only \
         --gpgcheck \
         --arch=x86_64 \
         --repoid=base \
         --download_path=packages/
```


# Custom Repository

Create a local repository to host RPM packages:

```bash
>>> yum -y install yum-utils createrepo                       # install the tools
>>> path=/var/www/html/repo                                   # directory holding the repository
>>> mkdir -p $path && createrepo $path                        # intialize the package repository
## move RPM packages into $path
>>> createrepo --update $path                                 # update once packages have been added
```

# Reference

[1] List of CentOS Mirrors  
<https://www.centos.org/download/mirrors/>

[2] Systemd Service Unit  
<https://www.freedesktop.org/software/systemd/man/systemd.service.html>

[3] Systemd Timer Unit  
<https://www.freedesktop.org/software/systemd/man/systemd.timer.html>
