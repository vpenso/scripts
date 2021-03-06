# DNF

Package manager for RPM based distributions → [DNF on GitHub](https://github.com/rpm-software-management/dnf)

→ [Configuration Reference](http://dnf.readthedocs.org/en/latest/conf_ref.html)

```bash
/etc/dnf/dnf.conf                 # local main configuration
/var/cache/dnf                    # cache files
dnf repolist -v all               # list all repositories
dnf search <package>              # search for a package by name
dnf list <package>
dnf list installed
dnf list recent
dnf info <package>
dnf install <package>
dnf install <rpm> 
dnf upgrade <package> 
dnf downgrade <package>
dnf erase <package>
dnf repoquery -l <package>        # list files within a package
```

Actions: (D)owngrade, (E)rase, (I)nstall, (O)bsoleting, (R)einstall, (U)pdate

```bash
dnf history list 
dnf history info <id>
dnf history info <sid>[..<eid>]
dnf history undo <id>                 # revert a transaction (uninstall,downgrade)
dnf history redo <id>
```


## Upgrades

```bash
dnf check-update
dnf upgrade
## ...clean up...
dnf list autoremove
dnf autoremove -y
dnf clean packages
dnf clean expire-cache
```

→ [DNF Automatic](http://dnf.readthedocs.org/en/latest/automatic.html)

```bash
>>> dnf install -yq dnf-automatic
>>> grep apply_updates /etc/dnf/automatic.conf
apply_updates = yes
>>> systemctl enable --now dnf-automatic-install.timer
>>> systemctl list-timers '*dnf-automatic*'
```
