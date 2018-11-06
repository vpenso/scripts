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
    echo "s"       prints string s to screen
    echo -n "s"    prints string s to screen without linefeed
    export V=v     set global variable V to value v
    local V=v      set variable V to value v locally in function         
    dirs           show all directories in stack
    cd ~n          go to nth directory in stack
    pushd d        add directory d to stack
    popd           remove directory from stack
    eval `c`       execute command c in sub-shell and evaluate
    read v         read value into v
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

## Pattern Matching

    =~              pattern match operator
    \               escape, match special character literaly
    .               matches one 
    ?               matches zero or one 
    +               matches one or more 
    *               matches any number 
    ^               matches the beginning of a line
    $               matches the end of a line
    [a-z0-9]        matches any single lowercase letter or any digit
    [^b-d]          matches any character except those in the range b to d
    (a|e)           matches a or e
    [:alnum:]       equivalent to [A-Za-z0-9]
    [:alpha:]       equivalent to [A-Za-z]
    [:digit:]       equivalent to [0-9]
    [:xdigit:]      matches hexadecimal digits, equivalent to [0-9A-Fa-f]
    [:blank:]       matches a space or a tab
    [:space:]       all whitespace characters [ \t\v\f]

## Error Handling

Read about the available signals with `man 7 signal`. Get a short 
signal listing with `kill -l`. 

    EXIT     0         end of program reached
    HUP      1         disconnect 
    INT      2         Interrupt (usally Ctrl-C)
    KILL     9         Stop execution immediatly (can not be trapped)
    TERM     15        default shutdown

Exit and error in a sub-shell, simple cases:

    (c)                execute command c in sub-shell, ignore errors
    (c) || exit $?     same as above but propagate signal code

**Catching Signals**

Execute commands COMMAND on signal SIG

    trap 'COMMAND' SIG [SIG,..]

Trap breaking child processes

    set -m
    # rescue function executed by trap
    ensure() {
      echo "Clean up after child process died with signal $?."
    }
    # catch errors
    trap ensure ERR
    # execute child process
    segfaulter &    
    # wait for the child process to finish
    wait $!

