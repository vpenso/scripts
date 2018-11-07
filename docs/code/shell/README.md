# Shell

* **Interactive**
  - Reads user input on a tty, enable users to enter/execute commands
  - Shells commonly used in interactive mode started by default upon launch of a terminal
* **Non-interactive**
  - A shell executing a script (no human interaction) is always non-interactive
  - Scripts must be executable `chmod +x <script>`

If a script requires input from the users it is called **interactive script**.

Executing a script:

```bash
/path/to/script            # (recommended) interpreted defined by shabang line
/bin/bash /path/to/script  # interpreter followed by the path to a script
bash /path/to /script      # assumes bash is in PATH
```

The first line may indicate the script interpreter with a 
`#!` (shabang), i.e. the absolute path to the interpreter
executable:

```bash
#!/bin/bash
```

Execute a script file with the bash executable found in 
the `PATH` environment variable:

```bash
#!/usr/bin/env bash
```


Build-in Commands: 

    set -v         print shell input lines as they are read
    set -x         print commands and their arguments when executed
    set -f         disable globbing
    source f       execute file f in current shell environment
    eval `c`       execute command c in sub-shell and evaluate
    shift          remove leading positional parameter
    jobs           list active jobs associated with current shell
    disown         detach jobs from current shell
    nohup          continue job after logout
    bg             move job to background 
    fg j           resume job j to foreground
    stop j         stops background job j
    trap c s       execute command c when catching signal s

Cursor movement, cf. `man readline`:

    tab            command line completion
    ctrl-r         search command history
    ctrl-l         clear screen
    ctrl-w         delete last word
    alt-b|f        move by word
    ctrl-u|k       delete until start/end of line
    ctrl-a|e       move cursor to beginning/end of line         
    ctrl-x ctrl-e  open command in editor

Rarely known but very useful commands:

    nl             number lines of file
    hd             convert to hexadecimal
    bc             calculator
    xargs          use input as argument to command (rather then stdin)
    rehash         re-index executables in $PATH (Zsh)
    reset          reset terminal
    pv             pipe monitor
    rename         rename multiple files
    jq             JSON processor
    xmlstarlet     XML processor
