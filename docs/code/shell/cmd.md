
```bash
$(c)           # execute command c in sub-shell (alternative `c`)
c &            # execute command c in background
c1 && c2       # if command c1 runs successful execute c2
c1 || c2       # if command c1 runs not successful execute c2
c1 & c2        # run commands c1 and c2 in parallel
c1; c2         # execute command c1 before c2
{c1; c2}       # execute commands in current shell environment
(c1; c2)       # execute the commands inside a sub-shell environment
c1 $(c2)       # command c1 uses output of c2 as parameters
```

Use the exeit code of a command as `if..else..` condition

```bash
if command ; then
  ...
else
  
fi
```

Build-in Commands:

```bash
set -v         # print shell input lines as they are read
set -x         # print commands and their arguments when executed
set -f         # disable globbing
source f       # execute file f in current shell environment
eval `c`       # execute command c in sub-shell and evaluate
shift          # remove leading positional parameter
jobs           # list active jobs associated with current shell
disown         # detach jobs from current shell
nohup          # continue job after logout
bg             # move job to background 
fg j           # resume job j to foreground
stop j         # stops background job j
trap c s       # execute command c when catching signal s
rehash         # re-index executables in $PATH (Zsh)
reset          # reset terminal
```
