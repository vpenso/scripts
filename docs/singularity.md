
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
grep 'allow setuid = yes' /etc/singularity/singularity.conf
chmod 755 /usr/lib/x86_64-linux-gnu/singularity/sexec && chmod 4755 /usr/lib/x86_64-linux-gnu/singularity/sexec-suid
                                                   # >2.2 SUID bit required
```

→ [Bootstrap Definition][03]

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

→ [Docker Official Repositories][04]


[01]: http://singularity.lbl.gov/
[02]: https://github.com/singularityware/singularity
[03]: http://singularity.lbl.gov/bootstrap-image
[04]: https://hub.docker.com/explore/
