
[Singularity][01] provides private OS container images in user-space

```bash
apt -y install build-essential automake libtool debootstrap 
### download, extract source code archive, and change to working directory
version=2.2 ; wget https://github.com/singularityware/singularity/archive/$version.tar.gz -O /tmp/singularity_$version.orig.tar.gz
tar -xf /tmp/singularity_$version.orig.tar.gz -C /tmp/ && cd /tmp/singularity-$version
./autogen.sh                                       # prepare build
./configure --prefix=/usr/local --sysconfdir=/etc  # configure build
make                                               # build
sudo make install                                  # install binaries 
### create a debian package
>>> apt -y install debhelper dh-autoreconf git devscripts
>>> grep -A5 override_dh_fixperms debian/rules     # adjust permissions during package installation
override_dh_fixperms:
        dh_fixperms
        chown root.root debian/singularity-container/usr/lib/*/singularity/sexec
        chown root.root debian/singularity-container/usr/lib/*/singularity/sexec-suid
        chmod 755 debian/singularity-container/usr/lib/*/singularity/sexec
        chmod 4755 debian/singularity-container/usr/lib/*/singularity/sexec-suid
>>> dch -i                                         # adjust changelog if required
>>> dpkg-buildpackage -us -uc                      # build package
```

```bash
/etc/singularity/singularity.conf                  # global configuration
grep 'allow setuid = yes' /etc/singularity/singularity.conf
chmod 755 /usr/lib/x86_64-linux-gnu/singularity/sexec && chmod 4755 /usr/lib/x86_64-linux-gnu/singularity/sexec-suid
                                                   # >2.2 SUID bit required
```

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

→ [Bootstrap Definition][03]  
→ [Docker Official Repositories][04]

### Usage

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



[01]: http://singularity.lbl.gov/
[02]: https://github.com/singularityware/singularity
[03]: http://singularity.lbl.gov/bootstrap-image
[04]: https://hub.docker.com/explore/
[05]: https://github.com/FairRootGroup/FairSoft
[06]: https://github.com/FairRootGroup/FairRoot 
