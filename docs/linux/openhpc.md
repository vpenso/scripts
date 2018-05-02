# OpenHPC

OpenHPC provides a collection of pre-built ingredients common in HPC environments

<http://www.openhpc.community>

Source code:

<https://github.com/openhpc/ohpc>

Mail Lists:

<http://www.openhpc.community/support/mail-lists/>

Build system:

<https://build.openhpc.community/>

Integration Testing:

<http://test.openhpc.community:8080/>

## Software Repository

There are two primary ways to access the available RPMs:

* Enable public OpenHPC repo(s) on head node that can route to internet
* Host a local mirror of the OpenHPC repo(s) within your datacenter

### Public Repository

```bash
>>> rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
>>> cat /etc/yum.repos.d/OpenHPC.repo
...
>>> yum update -y -q && yum repolist | grep -i hpc
OpenHPC                  OpenHPC-1.3 - Base                                  821
OpenHPC-updates          OpenHPC-1.3 - Updates                             1,080
```

Package naming conventions:

- **meta packages** are prefixed with `ohpc-`
- software packages sue `-ohpc` as suffix

```bash
# packages built against specific compiler variant
package-<compiler_family>-ohpc-<package_version>-<release>.<arch>.rpm
# packages built against compiler/MPI combination
package-<compiler_family>-<mpi family>-ohpc-<package_version>-<release>.<arch>.r
```

```bash
/opt/ohpc/                         # installation path
yum search ohpc- | grep ^ohpc      # list meta-packages
yum search ohpc | grep -- -ohpc.   # list software paackages
yum search ohpc openmpi            # search a specific component (i.e. openmpi)
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

```bash
# install some compilers
>>> yum install -y *compilers-ohpc lmod-ohpc
# re-login, or source Lmod
>>> source /etc/profile.d/lmod.sh
# list available software
>>> module avail
# load a compiler
>>> module load llvm5
>>> which llc
/opt/ohpc/pub/compiler/llvm/5.0.1/bin/llc
```
