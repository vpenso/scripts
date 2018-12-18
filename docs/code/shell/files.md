
# Files & Directories

Typically data stored in a file-systems is organized within a **tree structure**.

* This tree structure consists of parent and child directories in a hierarchical order.
* A **directory** (folder) contains files and further "child" directories.
* A **file** contains data stored in the file-system. 
* The **root directory** is the top-most directory in the tree.
* The current **working directory** is the location of the user while navigating in the directory tree.
* A **sub directory** (aka child directory) is hierarchically below the working director.
* Each user has a **home directory** (login directory) for personal data. 

Following shows the hierarchical listing of the home directory of a use "jdow":

```bash
/home/jdow
├── /home/jdow/bin
├── /home/jdow/docs
│   ├── /home/jdow/docs/manual.pdf
│   └── /home/jdow/docs/readme.md
├── /home/jdow/music
│   ├── /home/jdow/music/song.mp3
│   └── /home/jdow/music/sound.mp3
└── /home/jdow/var
```

A **path** specifies a unique location in the directory tree: 

* A path is separated by **slashes `/`** like `/home/jdoe/docs`.
* An **absolute path** starts with a slash, hence specifies a "full" path to a location in the tree.
* A **relative path** specifies a path in relation to the current working directory.

Paths are constructed with the following notation:

```bash
~                        # abbr. for the home directory (like $HOME)
~+                       # current directory (like $PWD)
~-                       # previous working directory
/                        # root directory
### absolute path
/<dir>[/<dir>[/<file>]]  # starts with / for the root directory
### realtive path
.                        # current directory
..                       # parent directory
../..[/..]               # parent of the parent directory
<dir>/[<dir>[/<file>]]   # sub/child directory/file
../<dir>[/<dir>/]        # relative to parent directory
~/<dir>[/<dir>/]         # relative to the (login user) home directory
~<user>/<dir>[/<dir>/]   # relative to a specific user home directory 
./.<path>                # hide a path by prefixing it with a dot 
```


## ls/tree

**`ls`** (list) show the contents of a directory-tree:

```bash
alias ls='ls -Fh --color=always'   # default to classify, human readable sizes and colors
alias lS='ls -lS'                  # displays file size in order
alias l='ls -1'                    # only names, one per line
alias ll='ls -l'                   # long format
alias l.='ls -lA -d .*'            # only hidden files
```

**dotfile** treated as hidden, i.e. `~/.profile`:

* File/directory name preceded by a dot `.`
* Not displayed by default in a directory listing

The **classify** option `-F` appends symbols to filenames:

```
*       executable
/       directory
@       link
=       socket
>       door (IPC)   
|       named pipe
```

The `LS_COLORS` variable is used to define colors for the ls command.
Use the **`dircolors`** program for a more complex configuration:

```bash
# a simple file with a color configuration
cat > ~/.dircolors <<EOF
TERM screen-256color
RESET                 0
FILE                  00;38;5;241
DIR                   00;38;5;244
LINK                  00;38;5;239
EOF
# load the configuration on shell init
echo 'eval "$(dircolors -b ~/.dircolors)"' >> ~/.profile
```

Comprehensive example in the [bin/dir-colors](../../../bin/dir-colors) program


**`tree`** lists directories in a tree like format:

```bash
alias td='tree -d'                 # list only dirs 
alias t2='tree -L 2'               # max recursive depth of 2 levels
alias tu='tree -pfughF --du'       # permissions, user, group, sizes 
```

[exa](https://the.exa.website/) modern replacement for ls

```bash
alias el='exa -l --git'
alias eG='exa -lG --git'
alias eT='exa -lT --git --group-directories-first -@ -L 2'
```

### Naming Conventions

* File names typically use **alphanumeric characters** (mostly lower case), underscores, hyphens and periods
* **`-` or `_` separates logical words**, e.g. `this_is_a_file.txt` (note that `CamelCase` is normally not used)
* Executables (including shell scripts) usually never have any type of extension
* Files with a specific format use dot **`.` to separate the (file-type) extension**, e.g. `image.jpg`
* Capitalized file names are used for high-lighting e.g. `README.md`
* Following characters must be quoted if they are to represent themselves:
  - `|&;<>()$\"'` as well as `␣⇥↵` space, tab and newline
  - `*?[#~=%` depending on conditions
  - Quoting mechanisms are the escape character `\`, single-quotes (literal value) and double-quotes (`$` variable expansion)

```bash
# examples on escaping files names
>>> touch 'foo?bar' foo\ bar foo%bar foo~bar "foo*bar" foo\$\ bar
# list file names with special characters
>>> ls | grep -E '\s|\*|\?|\$|%'                                 
foo bar
foo?bar
foo$ bar
foo*bar
foo%bar
```

## Commands

Navigate the directory tree:

```bash
pwd                  # print working directory
cd <path>            # change to specified directory
cd                   # no path argument changes to the home directory of the login user
cd -                 # change to previous directory
pushd                # push directory to stack
popd                 # remove directory from stack
dirs                 # list directory stack
cd ~<n>              # change to nth diretory from stack
touch <path>         # create an empty file with specifed path and name
```


Manipulating files & directories:

```bash
rm <path>            # delete a file (permanently)
rm -r <path>         # remove a directory and all its content (recursive decent)
mkdir <path>         # create an (new) empty directory in the tree
mkdir -p <path>      # ^^ recursive create of a new directory (missing parents included)
rmdir <path>         # remove a directory if it is empty
cp <path> <path>     # copy a file
cp -R <path> <path>  # copy a directory
mv <path> <path>     # move a file/directory
rename <path>        # rename multiple files according to pattern
ln -s <path> <link>  # create a symbolic link
```

Work with files: 

```bash
file              # determine file type
stat              # display file status
cat               # print file content
head              # show the beginning of a file
tail              # show the end of a file
less              # pager for files
pg                # ^^
more              # ^^
wc                # count line/chars in a file
touch             # create empty file, change timestamp 
nl                # number lines of a file
```

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

## Find

The `find` command is used to search for files and directories by various criteria

```bash
find <path>                               # list only directories
find <path> -name "*.txt"                 # use wildcards
            -name "abc[a-z][0-9]"         # use regex 
find <path> -type f                       # files only
            -type d                       # directories onlyQ
            -type l                       # sym links
            -type f -path '*..*'          # file in selected dires
            -type f -not -path '*..*'     # files not selected dirs
find <path> -mmin n                       # modified n minutes ago
            -mmin -n                      # less then n minutes ago
            -mmin +n                      # more then n minutes ago
            -amin [+-]n                   # access time n minutes ago
            -cmin [+-]n                   # change time n minutes ago
            -mtime [+-]n                  # modified n days ago          
            -newermt 2007-06-07 ! -newermt 2007-06-08 # range of dates
            -size [+-]n[kMG]              # [more|less] blocksize [KB,MB,GB]                 
```

Work with the selected files:

```bash
find ... -print | xargs -r ...            # execute a command against the found files
find ... -print0 | xargs -r -0 ...        # files separated using null byte to supprot 
                                          # special chars, spaces, etc.
find ... -exec ... {} \;                  # use a subprocess to execute a command
```

Options to `-exec <command>`:

* Placeholder `{}` is replaced by the file name
* `;` end of the command to exec, might need to be escaped (with a `\`) 
* `+` append a list of file to the command (on call)

Examples:

```bash
# change permissions on directories (single call of chmod)
find . -type d -exec chmod 770 {} +
# embedded bash script consuming the list of files
find . -type d -exec bash -c 'for f; do echo "$f" ; done' _ {} +
# search files within a time frame
find . -newerat $(date -d '1 HOUR AGO' +%Y%m%d%H%M.%S) ! \
       -newerat $(date -d '10 MINUTE AGO' +%Y%m%d%H%M.%S) -print
# find file by appendix in currenct working directory (only)
find . -maxdepth 1 -type f -name "*.txt"
```
