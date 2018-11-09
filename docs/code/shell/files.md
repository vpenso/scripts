
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

List the content of a directory-tree

```bash
ls                   # list content in the working directory
ls <path>            # list content specified by path
ls -a <path>         # show hidden pathes also
tree                 # show the tree structure decending from the working directory
tree -f -l 1 <path>  # show absolute tree structure with a decending depth of 1 of specified directory
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

Access control:

```bash
chmod             # change file permissions
chown             # change file owner
getfacl           # show ACL permissions
setfacl           # modify ACL permissions

```

## Search

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
