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
Pin: <release>                                # identify the package source, cf. apt-cache policy
Pin-Priority: <priority>                      # numerical value for priority
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


