


# Singularity

<http://singularity.lbl.gov/>

Container images include run-time, libraries, tools, and application code:

* Containers encapsulate a software environment (software stack).
* Relieve a cluster from the need to provide a common software environment.
* Users define/control containers specific to an applications.
* User-space independent from hardware run-time environment (host OS).
* Users become completely invisible to each other ("dependency hell").

Singularity allows a simple integration of Linux containers with high-performance computing:

* Scheduler/Resource manager agnostic
* Runs with user privileges(, and does not require a service daemon)
* Bind mounts host file-systems into the container
* Executable within a job script send to the resource manager
* Integrates with MPI, InfiniBand, hardware accelerators (Nvidia/AMD GPUs, Intel KNL)




## Install

Source archives of Singularity releases:

<https://github.com/singularityware/singularity/releases>

### Debian

Official Debian packages:

<https://packages.debian.org/singularity-container>

Debian, Ubuntu package from NeuroDebian:

<http://neuro.debian.net/pkgs/singularity-container.html>

Build from source code:

```bash
>>> apt -y install build-essential automake libtool python debootstrap
### download, extract source code archive, and change to working directory
>>> version=2.4 ; wget https://github.com/singularityware/singularity/archive/$version.tar.gz -O /tmp/singularity_$version.orig.tar.gz
>>> tar -xf /tmp/singularity_$version.orig.tar.gz -C /tmp/ && cd /tmp/singularity-$version
>>> ./autogen.sh                                       # prepare build
>>> ./configure --prefix=/usr/local --sysconfdir=/etc  # configure build
>>> make -j $(nprocs)                                  # build
>>> sudo make install                                  # install binaries
```

Build a custom Debian package:

```bash
>>> apt -y install debhelper dh-autoreconf git devscripts help2man fakeroot
## cf. http://singularity.lbl.gov/install-linux
>>> echo "echo SKIPPING TESTS THEYRE BROKEN" > ./test.sh
>>> dch -i                                         # adjust changelog if required
>>> fakeroot dpkg-buildpackage -nc -b -us -uc      # build package
## upload the new package to a repository
```

Install required packages on a node:

```bash
>>> apt install singularity-container squashfs-tools
```

### CentOS

```bash
>>> yum groupinstall -y "Development Tools"
## download and extract the source code
>>> wget https://github.com/singularityware/singularity/releases/download/2.3.1/singularity-2.3.1.tar.gz
>>> tar -xvf singularity-2.3.1.tar.gz && cd singularity-2.3.1
## configure & build
>>> ./configure
>>> make
## create an RPM package
>>> rpmbuild -ta singularity-2.3.1.tar.gz
>>> ls -1 ~/rpmbuild/RPMS/x86_64/singularity-*
/root/rpmbuild/RPMS/x86_64/singularity-2.3.1-0.1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/singularity-debuginfo-2.3.1-0.1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/singularity-devel-2.3.1-0.1.el7.centos.x86_64.rpm
```

## Configuration

Singularity administration guide:

<http://singularity.lbl.gov/admin-guide>

```bash
/etc/singularity/singularity.conf                  # global configuration
## show configuration
grep -v ^# /etc/singularity/singularity.conf | grep -v -e '^$' | sort
```

The Singularity configuration must be owned by root if running in SUID mode.

## Usage

Singularity user guide:

<http://singularity.lbl.gov/user-guide>


### Build

Container image sources:

<https://hub.docker.com/explore/>  
<https://www.singularity-hub.org/collections>


```bash
# container in read-only squashfs image
singularity build centos.simg docker://centos:latest 
singularity build debian.simg docker://debian:latest
# container in awritable ext3 image
sudo singularity build -w debian.img docker://debian:latest
# container within a writable directory
sudo singularity build -s debian docker://debian:latest
sudo singularity build debian.simg debian/               # convert a directory to a squashfs image
## make changes to the image
sudo singularity shell --writable debian.img
```

Following example builds and starts a container for the [ROOT Data Analysis Framework](https://root.cern.ch/guides/users-guide)

```
>>> cat root6.sing
BootStrap: docker
From: cern/cc7-base

%post
  yum install wget git cmake gcc-c++ gcc binutils libX11-devel libXpm-devel libXft-devel libXext-devel
  cd /opt
  wget https://root.cern.ch/download/root_v6.10.08.Linux-centos7-x86_64-gcc4.8.tar.gz
  tar -xzf root_v6.10.08.Linux-centos7-x86_64-gcc4.8.tar.gz

%environment
  ROOTSYS=/opt/root
  PATH=$PATH:$ROOTSYS/bin
  LD_LIBRARY_PATH=$ROOTSYS/lib:.:$LD_LIBRARY_PATH
  export ROOTSYS PATH LD_LIBRARY_PATH 

%runscript
  exec /opt/root/bin/root -b "$@"
```
```bash
## build the container
>>> sudo singularity build root6.simg root6.sing
## run the container
>>> singularity run root6.simg 
   ------------------------------------------------------------
  | Welcome to ROOT 6.10/08                http://root.cern.ch |
  |                               (c) 1995-2017, The ROOT Team |
  | Built for linuxx8664gcc                                    |
  | From tag v6-10-08, 16 October 2017                         |
  | Try '.help', '.demo', '.license', '.credits', '.quit'/'.q' |
   ------------------------------------------------------------

root [0]
```

### SCI-F

SCI-F (Standard Container Integration Format):

<http://containers-ftw.org/>

* Reproducible containers for scientific software workflows.
* Self-documenting, programmatically parseable (exposing software and associated metadata, environments, and files).

<http://containers-ftw.org/apps/examples/tutorials/getting-started>
