
→ [package search](https://packages.debian.org/index)

```bash
dpkg -i <path>.deb                            # install local package
dpkg -s <package> | grep -i version           # version of installed package
dpkg -L <package>                             # list content of a package (if installed)
dpkg -S <path>                                # find package containing file (if installed)
dpkg-query -l                                 # list all installed packages
apt search <pattern>                          # search the package repos
apt install apt-file && apt-file update       # install file search
apt-file search <file>                        # search for a specific file in repos
apt-file list <package>                       # list files from a packge
apt-show-versions -u                          # list upgradeable packages
echo "<package> hold" | dpkg --set-selections # hold package upgrades
apt-get changelog <package>                   # print package change log
apt-get --force-yes --yes install <package>=<version>
                                              # package downgrade
apt-get remove <package>                      # uninstall a package
apt-get purge <package>                       # uninstall package, and remove config/state
apt-get autoremove                            # remove orphan dependency packages
apt-get build-dep <package>                   # install build dependencies 
apt-get --download-only source <package>      # download package source code
wget -qO - <url> | sudo apt-key add -         # download, install repository key
apt-get -f install | dpkg --configure -a      # recover from broken installation
```

### HTTP Proxy

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


