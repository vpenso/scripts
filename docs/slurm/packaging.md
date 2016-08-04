
Backport the [slurm-wlm](https://packages.debian.org/sid/slurm-wlm) Debian package:

```bash
apt update && apt upgrade && apt -y install packaging-dev debian-keyring devscripts equivs
                                                     # install the build environment
dget -x http://http.debian.net/debian/pool/main/s/slurm-llnl/slurm-llnl_16.05.2-1.dsc
                                                     # download slurm meta packages
cd slurm-llnl-16.05.2/ && mk-build-deps --install --remove
                                                     # install package dependencies
dch --local ~bpo8+ --distribution jessie-backports "Rebuild for jessie-backports."
                                                     # indicate backport in changelog
fakeroot debian/rules binary                         # build the source
dpkg-buildpackage -us -uc                            # build the package
```
```bash
dget http://http.debian.net/debian/pool/main/m/munge/munge_0.5.12-1.dsc
                                                     # download munge meta packages
cd munge-0.5.12/ && mk-build-deps --install --remove
dch --local ~bpo8+ --distribution jessie-backports "Rebuild for jessie-backports."
fakeroot debian/rules binary                        
dpkg-buildpackage -us -uc                           
```


