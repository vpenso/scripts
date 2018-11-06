
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

