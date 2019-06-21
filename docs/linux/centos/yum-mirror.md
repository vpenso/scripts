# Package Server

Simple **HTTP server** setup:

```bash
yum -y install httpd
rm /etc/httpd/conf.d/welcome.conf
systemctl enable --now httpd
```

Grant access to the HTTP port, or disable the firewall 

```bash
firewall-cmd --permanent --add-service=http && firewall-cmd --reload
systemctl stop firewalld && systemctl disable firewalld
```

Disable SELinux

```bash
>>> grep ^SELINUX= /etc/selinux/config
SELINUX=disabled
>>> setenforce 0 && sestatus
```

## Synchronise with a CentOS Repository

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

## Periodic Updates


Using Systemd units:

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
### Custom Repository

Create a local repository to host RPM packages:

```bash
>>> yum -y install yum-utils createrepo                       # install the tools
>>> path=/var/www/html/repo                                   # directory holding the repository
>>> mkdir -p $path && createrepo $path                        # intialize the package repository
## move RPM packages into $path
>>> createrepo --update $path                                 # update once packages have been added
```
