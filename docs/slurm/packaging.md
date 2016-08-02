

```bash
>>> wget https://github.com/dun/munge/releases/download/munge-0.5.12/munge-0.5.12.tar.xz
                                                      # download the source code
>>> mkdir munge && cd munge && git init               # create a new package directory
>>> git-import-orig -u 0.5.12 ../munge-0.5.12.tar.xz  # import the upstream source
>>> git tags
upstream/0.5.12 Upstream version 0.5.12
>>> DEBFULLNAME='Victor Penso' dh_make -p munge_0.5.12 --multi -e vpenso@devops.test
                                                      # init debian package meta data
>>> cp /etc/git-buildpackage/gbp.conf debian          # copy skeleton build package config
>>> git add debian/ && git commit -m 'Basic package configuration files'
                                                      # add package meta dat to repo
```
```bash
>>> grep Depends debian/control                       # adjust the package dependencies
Build-Depends: debhelper (>= 9), autotools-dev, build-essential, libgcrypt11-dev, libbz2-dev, zlib1g-dev
Depends: ca-certificates, bzip2
>>> git commit -am 'List of package dependencies'    # commit these changes
>>> git-pbuilder create                              # create the base COW image
>>> DIST=sid ARCH=amd64 git-pbuilder create          # create the target platform
# create a new branch for building on debian/sid
>>> git branch debian/sid && git checkout debian/sid # dedicated branch for testing
>>> grep -e '^dist' -e '^arch' -e '^builder' debian/gbp.conf
builder = /usr/bin/git-pbuilder
dist = sid
arch = amd64
>>> git commit -am 'Configure the build platform'    # configure and commit build environment
>>> gbp buildpackage --git-debian-branch=debian/sid | tee /tmp/build.log
                                                     # build the package
>>> ls -1 ../munge_*                                 # list the build product
```
