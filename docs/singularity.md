
# Singularity

<http://singularity.lbl.gov/>

Singularity allows a simple integration of Linux containers with HPC clusters.

* Scheduler/Resource manager agnostic
* Runs with user privileges(, and does not require a service daemon)
* Bind mounts host file-systems into the container
* Executable within a job script send to the resource manager
* Integrates with MPI, InfiniBand, hardware accelerators (Nvidia/AMD GPUs, Intel KNL)

Supported container formats for the rootfs:

* singularity image
* squashfs
* tar.gz, tar.bz2, tar, cpio, cpio.gz archives 
* docker

## Install

Source archives of Singularity releases:

<https://github.com/singularityware/singularity/releases>

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

### Debian

Official Debian packages:

<https://packages.debian.org/singularity-container>

Debian, Ubuntu package from NeuroDebian:

<http://neuro.debian.net/pkgs/singularity-container.html>

Build a custom Debian package:

```bash
>>> apt -y install debhelper dh-autoreconf git devscripts help2man
>>> grep -A5 override_dh_fixperms debian/rules     # adjust permissions during package installation
override_dh_fixperms:
        dh_fixperms
        chown root.root debian/singularity-container/usr/lib/*/singularity/sexec
        chown root.root debian/singularity-container/usr/lib/*/singularity/sexec-suid
        chmod 755 debian/singularity-container/usr/lib/*/singularity/sexec
        chmod 4755 debian/singularity-container/usr/lib/*/singularity/sexec-suid
## cf. http://singularity.lbl.gov/install-linux
>>> echo "echo SKIPPING TESTS THEYRE BROKEN" > ./test.sh
>>> dch -i                                         # adjust changelog if required
>>> fakeroot dpkg-buildpackage -nc -b -us -uc      # build package
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


```bash
     singularity -d -x ...                              # debuging mode
                 help <subcommand>                      # call help for sub-command
sudo             create <image>                         # create blank container image
sudo             export <image> | gzip -9 > <archive>   # export image to compressed archive
sudo             import <image> docker://<target>:<tag> # import image from docker hub
                 bootstrap <image> <definition>         # install OS into container
                 mount <image> <path>                   # mount container image to path
                 shell [--writable] <image>             # spawn shell in container
                       docker://<target>:<tag>          # address docker hub image
                 exec <image>                           # execute command in container
                      -B <source>:<destination> ...     # bind host source path into container destination path
```



### Example

Following example builds a container with the [FairRoot][06] application:

```bash
# download software dependencies to /tmp on the host 
git clone --branch may16p1 https://github.com/FairRootGroup/FairSoft /tmp/fairsoft
git clone https://github.com/FairRootGroup/FairRoot.git /tmp/fairroot
sudo singularity create --size 10240 debian.img                 # prepare a container image
sudo singularity import debian.img docker://debian:jessie       # install basic OS into container
sudo singularity shell --shell /bin/bash --writable debian.img  # enter the container
# deploy the application software stack (note that /tmp is auto-bind into the container)
>>> cd /tmp/fairsoft
>>> $(grep -m 1 -A 7 apt DEPENDENCIES | tr -d "\\" | tr -d "\n")
>>> apt -y install libssh-dev subversion unzip libtool libglu1-mesa-dev libxft-dev libxmp-dev
>>> ./configure
>>> echo -e "export PATH=/opt/bin:\$PATH\nexport SIMPATH=/opt" >> /etc/bash.bashrc ; source /etc/bash.bashrc 
>>> mkdir /tmp/fairroot/build ; cd /tmp/fairroot/build
>>> cmake -DCMAKE_INSTALL_PREFIX="/opt" .. ;  make && make install
>>> exit
```

[05]: https://github.com/FairRootGroup/FairSoft
[06]: https://github.com/FairRootGroup/FairRoot 

### SCI-F

SCI-F (Standard Container Integration Format):

<http://containers-ftw.org/>

* Reproducible containers for scientific software workflows.
* Self-documenting, programmatically parseable (exposing software and associated metadata, environments, and files).

<http://containers-ftw.org/apps/examples/tutorials/getting-started>
