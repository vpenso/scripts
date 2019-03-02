## Rsync

Advanced alternative for the `cp` and `scp` commands:

* Synchronizes data (files/directories) between a source and destination path
* Either the source or the destination can be on another machine but not both
* Special algorithm to minimize the network traffic

```bash
rsync -r $source $destination             # copy source directory into destination
rsync -r $source/ $destination            # copy content of source directory into destination
# remote locations can be specified with a host-colon syntax
rsync $source $host:$destination          # copy to a remote node
rsync $host:source $destination           # copy from a remote node
```

Use option `-n` to **show changes without modifying** the destination:

```bash
-n, --dry-run     # perform a trial run with no changes made
--del             # an alias for --delete-during
--delete-during   # receiver deletes during the transfer
```

**Remove extraneous files** from the destintation with option `--del`.

Option `-a` **archive mode** equals `-rlptgoD` (not ACLs, hard links or extended attributes such as capabilities):

```bash
-r, --recursive   # recurse into directories
-l, --links       # copy symlinks as symlinks
-p, --perms       # preserve permissions
-t, --times       # preserve modification times
-g, --group       # preserve group
-o, --owner       # preserve owner (super-user only)
-D                # same as --devices --specials
--devices         # preserve device files (super-user only)
--specials        # preserve special files
```

Option `-hP` human readable progress/speed indicator:

```bash
-h, --human-readable    # output numbers in a human-readable format
-P                      # same as --partial --progress
--progress              # show progress during transfer
--partial               # keep partially transferred files, enables to resume interrupted file transfer
```

[rsync]: https://rsync.samba.org/
