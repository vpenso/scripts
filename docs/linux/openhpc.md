# OpenHPC

OpenHPC provides a collection of pre-built ingredients common in HPC environments

<http://www.openhpc.community>

Mail Lists:

<http://www.openhpc.community/support/mail-lists/>

CI Infrastructure:

<http://test.openhpc.community:8080/>

## Software Repository

There are two primary ways to access the available RPMs:

* Enable public OpenHPC repo(s) on head node that can route to internet
* Host a local mirror of the OpenHPC repo(s) within your datacenter

### Public Repository

Release package on Github:

<https://github.com/openhpc/ohpc>

```bash
>>> rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
>>> cat /etc/yum.repos.d/OpenHPC.repo
...
>>> yum update -y -q && yum repolist | grep -i hpc
OpenHPC                  OpenHPC-1.3 - Base                                  821
OpenHPC-updates          OpenHPC-1.3 - Updates                             1,080
```

**Meta packages** are prefixed with `ohpc-*`:

```bash
>>> yum search ohpc- | grep ^ohpc
ohpc-autotools.x86_64 : OpenHPC autotools
ohpc-base.x86_64 : OpenHPC base
ohpc-base-compute.x86_64 : OpenHPC compute node base
ohpc-buildroot.noarch : Common build scripts used in OpenHPC packaging
ohpc-filesystem.noarch : Common top-level OpenHPC directories
ohpc-ganglia.x86_64 : OpenHPC Ganglia monitoring
ohpc-gnu7-io-libs.x86_64 : OpenHPC IO libraries for GNU
ohpc-gnu7-mpich-io-libs.x86_64 : OpenHPC IO libraries for GNU and MPICH
ohpc-gnu7-mpich-parallel-libs.x86_64 : OpenHPC parallel libraries for GNU and
```

### Local Repository

Simple HTTP server:

```bash
>>> yum -y install httpd && systemctl enable httpd && systemctl start httpd
# Grant access to the HTTP port, or disable the firewall 
>>> firewall-cmd --permanent --add-service=http && firewall-cmd --reload
# Disable SELinux
>>> grep ^SELINUX= /etc/selinux/config
SELINUX=disabled
>>> setenforce 0 && sestatus
# install the tools
>>> yum -y install yum-utils createrepo
```

Distribution tarballs:

<http://build.openhpc.community/dist>

Setup the package repository

```bash
>>> wget http://build.openhpc.community/dist/1.3.4/OpenHPC-1.3.4.CentOS_7.x86_64.tar
>>> tar -vxf OpenHPC-1.3.4.CentOS_7.x86_64.tar
>>> mkdir -p /var/www/html/openhpc/1.3
>>> mv CentOS_7/{noarch,updates,x86_64} /var/www/html/openhpc/1.3/
>>> createrepo /var/www/html/openhpc/1.3/
```

## Environment Modules

Lmod implementation of environmental modules to provide standard 
user development and runtime environments:

<https://lmod.readthedocs.io>


