
→ [package search](https://packages.debian.org/index)

Local packages:

```bash
dpkg -i <path>.deb                            # install package
dpkg -s <package> | grep -i version           # version of installed package
dpkg -L <package>                             # list content of a package (if installed)
dpkg -S <path>                                # find package containing file (if installed)
dpkg-query -l                                 # list all installed packages
```

Packages from remote sources:

```bash
apt update                                    # (re-)synchronize the package index
apt-show-versions -u                          # list upgradeable packages
apt-get upgrade                               # install the newest versions of all 
                                              # packages currently installed
apt-get dist-upgrade                          # ^^, and remove obsolete packages
apt-get autoremove                            # remove obsolete packages
apt search <pattern>                          # search the package repos
apt install apt-file && apt-file update       # install file search
apt-file search <file>                        # search for a specific file in repos
apt-file list <package>                       # list files from a packge
echo "<package> hold" | dpkg --set-selections # hold package upgrades
apt-get changelog <package>                   # print package change log
apt-get --force-yes --yes install <package>=<version>
                                              # package downgrade
apt-get remove <package>                      # uninstall a package
apt-get purge <package>                       # uninstall package, and remove config/state
apt-get build-dep <package>                   # install build dependencies 
apt-get --download-only source <package>      # download package source code
apt-get -f install | dpkg --configure -a      # recover from broken installation
```

### Sources

```bash
grep -R '^deb ' /etc/apt/sources.* | tr -s '  ' | cut -d' ' -f2-
                                              # list all source locations
/etc/apt/sources.list.d/*.{list|sources}      # custom source location configuration
wget -qO - <url> | sudo apt-key add -         # download, install repository key
```

Source list configuration format

```bash
<type> [<opt>=<val>] <url> <suite> [<compontents>] [...] 

type                       # archive type deb (binary) or deb-src (source code)
opt                        # comma seperated list of options
url                        # package repository URL
suite                      # release code name/class, e.g jessie, stable
component                  # main, contrib, non-free
```

HTTP Proxy:

```bash
echo "Acquire::http::Proxy \"$URL\";" > /etc/apt/apt.conf.d/http_proxy.conf
                                              # configure a permanent proxy
http_proxy=$URL ; apt install <package>       # temporary proxy
```

### Pinning

```bash
apt-cache policy | grep -Ev Translation-..$   # list release information
apt-cache policy <package>                    # list available package versions
apt install -t <release> <package>            # install package from target release
apt install <package>=<version>               # install a specific version
```
Configure priorities in `/etc/apt/preferences.d/*.pref`:

```bash
Package: <name>                               # name of the package, may include *
Pin: <release>|<version|<origin>   
Pin-Priority: <priority>                      # numerical value for priority
```

Pin uses following configurations, cf. `apt-cache policy`:

```
release o=<origin>,a=<archive>,c=<component>,l=<label>,v=<version>
version <version>
origin <fqdn>
```

Numeric value for Priority `P`:

```
      P < 0          prevents install
  0 < P <=100        install if not installed
100 < P <=500        install unless an alternative exists, or installed package more recent
500 < P <=990        install unless target release available, or installed package more recent
990 < P <=1000       installed even if not from target release, unless installed package more recent
      P > 1000       installed even if this constitutes a downgrade
```

### Backports

→ [official backports](https://backports.debian.org/Instructions/)
→ [official firefox backports](http://mozilla.debian.net/)

```bash
echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
                                                    # configure the backports repository
apt update && apt install -t jessie-backports <package>
                                                    # installe a package from backports
dpkg -l  |awk '/^ii/ && $3 ~ /bpo[6-9]/ {print $2}' # list packages installed from backports
```

Create a backport package:

```bash
apt update && apt upgrade && apt -y install packaging-dev debian-keyring devscripts equivs
                                                     # install the build environment
dget -x <url>.dsc                                    # download slurm meta packages
cd <srcdir> && mk-build-deps --install --remove      # install package dependencies
dch --local ~bpo8+ --distribution jessie-backports "Rebuild for jessie-backports."
                                                     # indicate backport in changelog
fakeroot debian/rules binary                         # build the source
dpkg-buildpackage -us -uc                            # build the package
```

