
## Permissions

The `ls -l` command lists files & directories with ownership and permissions

```bash
>>> ls -ld /tmp              # ownership and permissions of /tmp
drwxrwxrwt 16 root root 4.0K Nov 15 07:44 /tmp/
 ├───────┘    ├──┘ ├──┘
 │            │    └─ group
 │            └────── owner
 └─────────────────── permissions
```

Alternatively use the `stat -c <format>` command:

```bash
>>> stat -c '%A %a %U %u %G %g' /tmp
drwxrwxrwt 1777 root 0 root 0
 ├───────┘ ├──┘ ├──┘ │ ├──┘ └─ gid
 │         │    │    │ └────── group
 │         │    │    └──────── uid
 │         │    └───────────── user
 │         └────────────────── permissions octal
 └──────────────────────────── permissions human readable
```

The human readable permission consists of three **permission triads**, 
for the owner, the group, and all others. Each triad (i.e. `rwx`) can 
be configured with a selection of three characters from `[r-][w-][x-st]`:

```
r             read
w             write
x             execute
-             no read/write/execute
s             siduid/setgid
t             sticky bit
```

* The **setuid/gid** bits allow users to run an executable 
  with the permissions of the executable's owner or group
* The **Sticky** bit only owner and root can rename/delete files/dirs


### chmod/chgrp/chown

```bash
id [<user>]                     # show user/group ID
chgrp <group> <path>            # change group ownership
chown <user>[:<group>] <path>   # change user(/group)
chmod <mode> <path>             # change permissions
umask <mode>                    # set default permissions
umask -S                        # displays mask in simbolic notation
```

Change permissions with the `chmod` command.
The format of `<mode>` is a combination of 3 fields:

* Effected triad `u` user, `g` group, `a` all or `o` others 
* `+` add permissions, `-` remove permissions
* Permissions, a combination of `[rwxsStT]`

Examples:

```bash
chmod +r ...              # read for everyone
chmod ug+rx ...           # add read/execute for user/group
chmod a-r ...             # remove read access for everyone
chmod ugo-rwx             # remove all permissions
chmod u=rw,g=r,o= ...     # user read/write, group read, no access for others
chmod -R u+w,go-w ...     # set permissions recursive
```

Octal notation, think of rwx an binary variables `r*2^2 + w*2^1 + x*2^0`

```
7  rwx  111
6  rw-  110
5  r-x  101
4  r--  100
3  -wx  011
2  -w-  010
1  --x  001
0  ---  000 
```

Examples

```bash
chmod 1755 ...            # sticky bit
chmod 4755                # setuid
chmod 2755                # setgid
```

### ACL

```
getfacl           # show ACL permissions
setfacl           # modify ACL permissions
```

---
