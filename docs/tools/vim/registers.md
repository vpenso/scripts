Commands to work on the registers:

```
:reg       show registers
:Wipe      empty registers (cf. vimrc)
```

Address a register with followed by a register name `"{register}`

Register   | Description
-----------|-----------------
"          | unnamed (or default), used by y/Y/d/D/x/X/c/C/s/S
_          | black hole register (content discarded, not store to viminfo)
0          | last yank from y/Y
1 to 9     | historical record of delete/change from d/D/c/C
-          | small delete register
.          | last insert text register
a to z     | named registers for users
%          | file name register
:          | command register (most recently executed)
```

