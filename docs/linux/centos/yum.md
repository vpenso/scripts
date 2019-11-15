# Yum

## Queries

```bash
yum list                          # list all available packages
yum list $package                 # search package by name
yum list kernel                   # installed/available kernel packages
yum list installed                # all installed packages
yum --disablerepo='*' list available --enablerepo=$name
                                  # list package provided by a given repo
```
```
yum search $package               # search all the available packages to match a name
yum provides $glob                # find which package includes a file i.e. "*bin/bash"
yum deplist $package              # package dependencies
yum info $package                 # package details
repoquery -l $package             # files in a package
```

Show the **changelog** of a package:

```bash
yum install yum-plugin-changelog
yum changelog all <package>
```

## Install & Update

```bash
yum -y install <package>          # install package by name (assume yes)
yum -y install --nogpgcheck <package> 
                                  # install unsigned packages by name (assume yes)
yum remove <package>              # delete package
yum check-update                  # find how many of installed packages have updates available
yum check-update --security       # check for security-related updates
yum update --security             # update those packages which are affected by security advisories
yum -y update                     # update all outdated packages
yum update <package>              # update package to latest version
yum grouplist                     # list available group packages
yum group info <group>            # show packages in group
yum groupinstall <group>          # install a group package
yum groupupdate <group>           # update group package
yum groupremove <group>           # delete a group package
yum list installed                # list installed packages
yum list available [<regex>]      # list all packages in all enabled repositories available to install
yum provides <path>               # find which package a specific file belongs to
```

## Versions

```bash
yum --showduplicates list <package>     # show all versions of a package
repoquery --show-duplicates <package>
yum install <package>-<verison>
yum downgrade <package>-<version>       # rollback/downgrade a package to a specific version
```

Version **lock**:

```bash
yum install -y yum-plugin-versionlock   # install package lock Yum plugin
/etc/yum/pluginconf.d/versionlock.conf  # configuration file
/etc/yum/pluginconf.d/versionlock.list  # package list format EPOCH:NAME-VERSION-RELEASE.ARCH
yum versionlock list                    # show all locks
yum versionlock <package>*-<version>    # lock a package to a specific version
yum versionlcok delete <package>        # remove a lock
yum versionlock clear                   # remove all versionlocks
```

Exclude packages from updates in `/etc/yum.conf`:

```conf
[main]
....
exclude=<foo>* <bar>*
```

## Transaction History

```bash
/var/lib/yum/history/                     # history DB
yum history                               # list of twenty most recent transaction
yum history | grep '\*\*'                 # search for aborted transactions
yum history info <id>                     # examine a particular transaction
yum history undo <id>                     # revert slected transaction
yum history stats                         # overall statistics about the currently used history DB
yum history sync                  
yum history package-list <package>        # Trace history of a package
yum history redo force-reinstall <id>     # force reinstall of the failed yum transaction
```
```bash
yum-complete-transaction                  # completes unfinished yum transactions which occur due to error, failure
yum-complete-transaction --cleanup-only   # do not complete the transaction just clean up
```

Possible action executed in the transaction:

Value | Action	      | Description
------|---------------|--------------------
I     |	Install	      | Package(s) installed.
U     |	Update	      | Package(s) updated to a newer version.
E     |	Erase	      | Package(s) removed.
D     |	Downgrade     | Package(s) downgraded to an older version.
O     |	Obsoleting    | Package(s) marked as obsolete.
R     |	Reinstall     |Package(s) reinstalled.

The number of altered packages can be followed by a code:

Value |Description
------|-------------
`<`   | The rpmdb database was changed outside Yum before the transaction ending.
`>`   | The rpmdb database was changed outside Yum after the transaction ended.
`*`   | The transaction aborted before completion.
`#`   | Finished successfully, but yum returned a non-zero exit code.
`E`   | Finished successfully, but an error or a warning was displayed.
`P`   | Finished successfully, but problems already existed in the rpmdb database.
`s`   | Finished successfully, but the –skip-broken command-line option was used and certain packages were skipped.


