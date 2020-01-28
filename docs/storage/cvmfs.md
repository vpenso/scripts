# CernVM-FS

> The [CernVM-File System][cf] (CernVM-FS) provides a scalable, reliable and
> low-maintenance software distribution service.

* Read-only file system to deliver scientific software to client nodes
* Uses standard HTTP protocol, enabling a variety of web caches
* Files and directories are hosted on **standard web servers**
* Ensures data authenticity/integrity over untrusted connections
* Optimized for small files that are frequently opened/read as a whole

Clients mount a virtual file system to `/cvmfs`

* POSIX read-only file system in user space (FUSE module)
* Loads data on demand as soon as directories/files accessed

Create/update a CernVM-FS repository on a **Release Manager Machine**:

* Mounts a CernVM-FS repository in read/write mode
* Software updates installed to a writable scratch area
* Changed in scratch merged into the CernVM-FS repository
* Merge/publish are atomic operations controlled by the user

## Installation

Client/server [binary packages][bp] available for following Platforms:

* Ubuntu {12,16,16,18}.04
* Debian 8,9,10 
* RHEL 6,7,8
* Fedora 29,30
* SLES 11,12 

Package repositories with [YUM][yr] and [APT][ap]

[cf]: https://cvmfs.readthedocs.io/en/2.4/index.html
[bp]: https://cernvm.cern.ch/portal/filesystem/downloads
[yr]: https://cvmrepo.web.cern.ch/cvmrepo/yum/
[ap]: https://cvmrepo.web.cern.ch/cvmrepo/apt/

Make the CVMFS packages available on **CentOS**:

```bash
## add the EPEL package source
>>> wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -i epel-release-latest-7.noarch.rpm
## add the CVMFS package source
>>> cd /etc/yum.repos.d/ && wget https://cvmrepo.web.cern.ch/cvmrepo/yum/cernvm.repo
>>> cd /etc/pki/rpm-gpg/ && wget https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM
>>> yum makecache 
## install CVMFS
>>> yum search cvmfs | grep ^cvmfs
cvmfs.x86_64 : CernVM File System
cvmfs-auto-setup.noarch : CernVM File System Auto System Setup
cvmfs-config-default.noarch : CernVM File System Default Configuration and
cvmfs-devel.x86_64 : CernVM-FS static client library
cvmfs-keys.noarch : CernVM File System Public Keys and Configs
cvmfs-server.x86_64 : CernVM-FS server tools
```

## Clients

Install a CVMFS client

```bash
>>> yum install -y cvmfs cvmfs-config-default
>>> cvmfs_config setup
>>> grep ^user_allow /etc/fuse.conf
user_allow_other # added by CernVM-FS
>>> grep ^/cvmfs /etc/auto.master
/cvmfs /etc/auto.cvmfs
```

Reference:

* [CernVM-FS Client Configuration](https://cvmfs.readthedocs.io/en/2.4/cpt-configure.html)
* [CernVM-FS Client Parameters](https://cvmfs.readthedocs.io/en/2.4/apx-parameters.html#apxsct-clientparameters)
* [CernVM-FS Configuration Examples](http://cernvm.cern.ch/portal/cvmfs/examples)

Simple :

```bash
## select desired repositories
>>> cat /etc/cvmfs/default.local
CVMFS_REPOSITORIES=alice.cern.ch,alice-ocdb.cern.ch
CVMFS_HTTP_PROXY="DIRECT"
## check configuration
>>> cvmfs_config probe
Probing /cvmfs/alice.cern.ch... OK
Probing /cvmfs/alice-ocdb.cern.ch... OK
## mount a CVMFS file-system
>>> systemctl restart autofs
>>> ls /cvmfs/alice.cern.ch
bin          data        el6-x86_64  etc                ubuntu1604-x86_64     x86_64-2.6-gnu-4.7.2  x86_64-2.6-gnu-4.8.4
calibration  el5-x86_64  el7-x86_64  ubuntu1404-x86_64  x86_64-2.6-gnu-4.1.2  x86_64-2.6-gnu-4.8.3
```

## Deployment

Install a repository server:

```bash
>>> yum install -y cvmfs cvmfs-server
## install Apache
>>> yum -y install httpd && systemctl enable httpd && systemctl start httpd
>>> firewall-cmd --permanent --add-service=http && firewall-cmd --reload
## create repository
>>> cvmfs_server mkfs devops.test
>>> df | grep cvmfs
/dev/fuse             4096000      34   4095967   1% /var/spool/cvmfs/devops.test/rdonly
overlay_devops.test  41153760 2555508  36484716   7% /cvmfs/devops.test
```

