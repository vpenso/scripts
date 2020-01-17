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

### Dry Run

Use option `-n` to **show changes without modifying** the destination:

```bash
-n, --dry-run            # perform a trial run with no changes made
-i, --itemize-changes    # output a change-summary for all updates 
```

Output format for itemize changes:

```
YXcstpoguax  path/to/file
|||||||||||
`----------- the type of update being done::
 ||||||||||   <: file is being transferred to the remote host (sent).
 ||||||||||   >: file is being transferred to the local host (received).
 ||||||||||   c: local change/creation for the item, such as:
 ||||||||||      - the creation of a directory
 ||||||||||      - the changing of a symlink,
 ||||||||||      - etc.
 ||||||||||   h: the item is a hard link to another item (requires --hard-links).
 ||||||||||   .: the item is not being updated (though it might have attributes that are being modified).
 ||||||||||   *: means that the rest of the itemized-output area contains a message (e.g. "deleting").
 ||||||||||
 `---------- the file type:
  |||||||||   f for a file,
  |||||||||   d for a directory,
  |||||||||   L for a symlink,
  |||||||||   D for a device,
  |||||||||   S for a special file (e.g. named sockets and fifos).
  |||||||||
  `--------- c: different checksum (for regular files)
   ||||||||     changed value (for symlink, device, and special file)
   `-------- s: Size is different
    `------- t: Modification time is different
     `------ p: Permission are different
      `----- o: Owner is different
       `---- g: Group is different
        `--- u: The u slot is reserved for future use.
         `-- a: The ACL information changed
```

### Compare Files

>  "quick check" algorithm (by default) that looks for files that have changed
in size or in last−modified time.

Modifies rsync’s "quick check" algorithm:

```bash
--ignore-existing       # skip updating files that exist on receiver 
--size-only             # skip files that match in size, even if the timestamps differ
-I, --ignore-times      # checksum every file, even if the timestamps and file sizes match
```

Use **128−bit checksum** for each file that has a matching size...lot of disk I/O 
reading all the data..

```
-c, --checksum          # checksum instead of "quick check" 
--checksum-choice=auto  # overrides the checksum algoriths, "md4", "md5", and "none"
```

### Transfer

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

Option `-hP` **human readable progress**/speed indicator:

```bash
-h, --human-readable    # output numbers in a human-readable format
-P                      # same as --partial --progress
--progress              # show progress during transfer
--partial               # keep partially transferred files, enables to resume interrupted file transfer
```

**Remove extraneous files** from the destination with option `--del`.

```bash
--del             # an alias for --delete-during
--delete-during   # receiver deletes during the transfer
```

### Include & Exclude

```
/dir/   means exclude the root folder /dir
/dir/*  means get the root folder /dir but not the contents
dir/    means exclude any folder anywhere where the name contains dir/
  Examples excluded: /dir/, /usr/share/mydir/, /var/spool/dir/
/dir    means exclude any folder anywhere where the name contains /dir
  Examples excluded: /dir/, /usr/share/directory/, /var/spool/dir/
/var/spool/lpd//cf means skip files that start with cf within any folder within /var/spool/lpd

include, +
exclude, -

'*' matches any non-empty path component (it stops at slashes).
'**' to match anything, including slashes.
'?' matches any character except a slash (/).
'[' introduces a character class, such as [a-z] or [[:alpha:]].
in a wildcard pattern, a backslash can be  used  to  escape  a  wildcard character, but it is matched literally when no wildcards are present.
```

[rsync]: https://rsync.samba.org/
