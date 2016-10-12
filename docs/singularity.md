
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
apt -y install debhelper dh-autoreconf git devscripts
dch -i                                             # adjust changelog if required
dpkg-buildpackage -us -uc                          # build package
```

```bash
/etc/singularity/singularity.conf                  # global configuration
```

→ [Bootstrap Definition][03]

```bash
singularity help <subcommand>                      # call help for sub-command
singularity create <image>                         # create blank container image
singularity bootstrap <image> <definition>         # install OS into container
singularity mount <image> <path>                   # mount container image to path
singularity shell [--writable] <image>             # spawn shell in container
singularity exec <image>                           # execute command in container
```



[01]: http://singularity.lbl.gov/
[02]: https://github.com/singularityware/singularity
[03]: http://singularity.lbl.gov/bootstrap-image
