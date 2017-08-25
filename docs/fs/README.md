
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
>>> tree /home
/home
└── /home/jdow
    ├── /home/jdow/bin
    ├── /home/jdow/docs
    │   ├── /home/jdow/docs/manual.pdf
    │   └── /home/jdow/docs/readme.md
    ├── /home/jdow/music
    │   ├── /home/jdow/music/song.mp3
    │   └── /home/jdow/music/sound.mp3
    └── /home/jdow/var
>>> pwd                                  # show the working directory
/home/jdow
>>> ls -1 docs/                          # list the sub directory docs/
files.md
manual.pdf
readme.md
```

A **path** specifies a unique location in the directory tree: 

* A path is separated by **slashes `/`** like `/home/jdoe/docs`.
* An **absolute path** starts with a slash, hence specifies a "full" path to a location in the tree.
* A **relative path** specifies a path in relation to the current working directory.

Paths are constructed with the following notation:

```bash
~                        # abbr. for the home directory
/                        # root directory
### absolute path
/<dir>[/<dir>/]          # starts with / for the root directory
### realtive path
.                        # current directory
..                       # parent directory
../..[/..]               # parent of the parent directory
<dir>/[<dir>/]           # sub/child directory
../<dir>[/<dir>/]        # relative to parent directory
~/<dir>[/<dir>/]         # relative to the (login user) home directory
~<user>/<dir>[/<dir>/]   # relative to a specific user home directory 
```

Examples for commands use to explore and navigate the directory tree:

```bash
pwd                  # print working directory
cd <path>            # change to specified directory
cd                   # no path argument changes to the home directory of the login user
cd -                 # change to previous directory
ls                   # list content in the working directory
ls <path>            # list content specified by path
tree                 # show the tree structure decending from the working directory
tree -f -l 1 <path>  # show absolute tree structure with a decending depth of 1 of specified directory
```

