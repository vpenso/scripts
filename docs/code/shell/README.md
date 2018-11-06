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

## Command Execution

    $(c)           execute command c in sub-shell (alternative `c`)
    c &            execute command c in background
    c1 && c2       if command c1 runs successful execute c2
    c1 || c2       if command c1 runs not successful execute c2
    c1 & c2        run commands c1 and c2 in parallel
    c1; c2         execute command c1 before c2
    {c1; c2}       execute commands in current shell environment
    (c1; c2)       execute the commands inside a sub-shell environment
    c1 $(c2)       command c1 uses output of c2 as parameters

## Expansion

    {a,b,c}        brace expansion
    {a..z}         extened brace expansion 
    ((v+=1))       increment variable v

## Primary Expressions

    n1 -lt n2       true if integer n1 less then n2
    n1 -gt n2       true if n1 greater then n2
    n1 -le n2       true if n1 less or equal n2
    n1 -ge n2       true if n1 greater or equal n2
    n1 -eq n2       true if n1 equals n2
    n1 -ne n2       true if n1 not equal n2
    s1 = s2         true if strings s1 equals s2 
    s1 != s2        true if strings s1 not equal s2
    -n s            true if string s is not empty
    -z s            true if string s is empty
    -c f            true if f is a special character file
    -d p            true if p is the path to an existing directory
    -e f            true if f is an existing file
    -f f            true if f is an existing file but not an directory
    -G f            true if f exists and is owned by effective group-id
    -g f            true if f exists and is set-group-id.
    -k f            true if f has sticky bit
    -L f            true if f is a symbolic link
    -O f            true if f exists and is owned by the effective user-id.
    -r f            true if f is readable
    -S f            true if f is socket
    -s f            true if f nonzero size
    -u f            true if f set-user-id bit is set
    -w f            true if f is writable
    -x f            true if f is executable
    f1 -nt f2       true if file f1 is newer the f2
    f1 -ot f2       true if file f1 os older then f2

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

## Control Structures

    if [ e1 ] ; then ; elif [ e2 ] ; then ; else ; fi
    case e in ; c1) ;; c2 | c3) ;; *) ;; esac 
    for i in $(e) ; do ; done
    for (( e1; e2; e3 )); do ; done 
    while [ e ] ; do ; done
    until [ e ] ; do ; done

## Here-Documents

Write here-documents to a file:

    cat > /path/to/file <<EOF
      [...SNIP...]
    EOF

Store here-document in a variable:

    var=$(cat <<EOF
      [...SNIP...]
    EOF
    )

Avoid substitution and expansion by quoting the tag (here EOF):

    cat <<"EOF"
      [...SNIP...]
    EOF

Using `<<-` suppresses leading tabs. Note that the closing tag
needs to be indented by tabs (not spaces).

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

