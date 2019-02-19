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
