# DNF

`dnf` command line interface is a successor and  mostly compatible to [`yum`](yum.md).
Both are front-ends to install [RPM](rpm.md) packages from [RPM repositories](rpm-repos.md).

## Configuration

```bash
/etc/dnf/dnf.conf                 # local main configuration
/var/cache/dnf                    # cache files
dnf repolist -v all               # list all repositories
```

## Usage 

```bash
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

Package groups:

```bash
dnf group                        # number of available/installed package groups
dnf group list --installed       # list installed groups
dnf group list --ids             # list available groups
dnf group info <group>           # show package in a group
dnf install @<group>             # install a group using the `@` prefix
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

## References

[dnfsc] Package manager for RPM based distributions  
<https://github.com/rpm-software-management/dnf>

[cofrf] Configuration Reference  
<http://dnf.readthedocs.org/en/latest/conf_ref.html>

[dnfg] Dandified YUM, GitHub  
<https://github.com/rpm-software-management/dnf>  
<https://dnf.readthedocs.io>
