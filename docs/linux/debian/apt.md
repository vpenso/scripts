# APT

Debian the package database at: 

<https://packages.debian.org>

Package **version format**:

```
{upstream_version}-{debian_revision}[~{suffix}{release}[+{revision}]]
```

* `upstream_version` - Version as specified by the upstream author(s)
* `debian_revision` - Debian specific version (reset to 1 each time the upstream_version is increased). The absence of a debian_revision is equivalent to a debian_revision of 0.
* `~{suffix}{release}[+{revision}]` (optional) - tilde sorts before anything (hence `1.1~bpo9` will be upgraded by `1.1`)
  * `suffix` - Used for backport `bpo` packages and site-specific packages.
  * `release` - Indicates the Debian release the package is meant for e.g. `bpo8` for Debian Jessie
  * `revision` (optional) - Anther counter to version the package 

Cf. <https://www.debian.org/doc/debian-policy/#s-f-version>

## Package Management

```bash
dpkg -i <path>.deb                            # install package
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
```bash
dpkg-query -l                                 # list all installed packages
dpkg -s <package> | grep ^Version             # show installed version of package
apt-cache policy <package> | grep -i installed
apt-cache madison <package>                   # list all available package versions in the repositories (binary + sources)
dpkg -L <package>                             # list content of a package (if installed)
dpkg -S <path>                                # find package containing file (if installed)
debsums -ce                                   # find configuration files changed from default 
```

### Unattended Upgrade

```bash
apt install -y unattended-upgrades apt-listchanges && dpkg-reconfigure -plow unattended-upgrades
/etc/apt/apt.conf.d/50unattended-upgrades     # update configurations
/etc/apt/apt.conf.d/20auto-upgrades           # automatic execution of unattended-upgrades
unattended-upgrades -v --dry-run              # execute the upgrade
/var/log/unattended-upgrades/unattended-upgrades.log
apt-config dump | sort | grep -i unatt        # dump configuration
```

Configuration in `/etc/apt/apt.conf.d/50unattended-upgrades`:

```c++
Unattended-Upgrade::Origins-Pattern { "o=*"; };             // Update all sources
Unattended-Upgrade::Remove-Unused-Dependencies "true";      // equivalent to apt-get autoremove
Unattended-Upgrade::AutoFixInterruptedDpkg "true";          // equivalent to dpkg --force-confold --configure -a
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
## package repositories in priority order
apt-cache policy | grep '^ [0-9]... *' | sed 's%/[^/]*$%/%' | uniq | sort -r
apt-cache policy <package>                    # list available package versions
apt install -t <release> <package>            # install package from target release
apt install <package>=<version>               # install a specific version
```

Keep the current version of a package:

```bash
apt-mark showhold                       # list package on hold
apt-mark hold <package> [<package>,...] # hold one or more packages
echo <package> hold | dpkg --set-selections   
dpkg --get-selections <package>         # check the hold status
apt-mark unhold <package>               # unset package hold
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

## Additional Repositories

Life-cycle of Debian Releases [1]:

* **Experimental** - new software package, proposed for inclusion
  - May contain serious bugs with critical repercussions
  - Packages never migrate to another version (except by direct manual intervention)
* **Unstable** - very new (latest) software version (sometimes broken)
  - Usually based on the latest upstream version from the developer 
  - Packages build by it maintainer for **inspection** and **validation**
  - Updates occur rapidly (following bug reports, and subsequent package rebuild)
  - Autobuilders compile versions for all (supported) architectures
* **Testing** (Sid) - relatively recent software with basic quality assurance (stable enough)
  - Package will have matured; compiled on all the architectures, no recent modifications
  - Automatic migration to testing according to elements guaranteeing a certain level of quality (>10 days in unstable, no critical bugs, etc.)
  - Note: critical bugs are regularly found in packages included in testing
  - Compromise between stability and novelty
  - Testing packages promoted by a release manager to stable
  - **freeze period**: testing blocked (no more automatic updates, only authorized changes)
* **Stable** - changes rarely, continuous security updates
  - Stable updates systematically include all security patches

Regional redirection for Debian mirrors:

<http://http.debian.net/>


### Backports

→ [official backports](https://backports.debian.org/Instructions/)
→ [official firefox backports](http://mozilla.debian.net/)

```bash
echo 'deb http://ftp.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list
                                                    # configure the backports repository
apt update && apt install -t stretch-backports <package>
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

### Testing, Unstable & Experimental

Add the following repos to `/etc/apt/source.list.d/*.list`:

```
deb http://deb.debian.org/debian          testing              main contrib non-free
deb http://deb.debian.org/debian-security testing/updates      main contrib non-free
deb http://deb.debian.org/debian          unstable             main contrib non-free
deb http://deb.debian.org/debian-security unstable/updates     main contrib non-free
deb http://deb.debian.org/debian          experimental         main contrib non-free
deb http://deb.debian.org/debian-security experimental/updates main contrib non-free
```

Configure the package preferences in `/etc/apt/preferences/*.pref` to **prioritize packages in testing**

```
Package: *
Pin: release a=stable
Pin-Priority: 800

Package: *
Pin: release a=testing
Pin-Priority: 950

Package: *
Pin: release a=unstable
Pin-Priority: 700

Package: *
Pin: release a=experimental
Pin-Priority: 500
```

# References

[1] _The Debian Administrator's Handbook_, chapter 1.6 Lifecycle of a Release  
<https://debian-handbook.info/browse/stable/sect.release-lifecycle.html>

