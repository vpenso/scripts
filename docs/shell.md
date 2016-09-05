# Shell

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

## Variables and Literals 

    #              mark line as comment
    ;              statement (command) separator
    \              escape character (preserves the literal value)
    :              null-statement (returns 0)
    $              expansion character
    $[e]           evaluate integer expression
    ((e))          expand and evaluate of integer expression e
    $((e))         expand, evaluate and substitute integer expression e
    [[e]]          returns bool after evaluation of the conditional expression e
    's'            preserves literal value of characters in string s
    "s"            preserves literal value of characters in string s except $ \ ,
    V=v            assign value v to variable V (no spaces allowed)
    !e             true if expression e is false
    e1 && e2       true if both expressions e1 and e2 are true (alternative e1 -a e2)
    e1 || e2       true if either expression e1 or e2 is true (alternative e1 -o e2)
    a[i]=v         store value v as element i in array a
    {c;}           block of code anonymous subroutine
    f() {c;}       named subroutine (key-word `function` optional)
    $1...$n        direct access to parameters n
    $@             all parameters
    "$@"           each parameter in double-quotes ("$1" "$2"...)
    "$*"           all parameters in double-quotes ("$1 $2...")
    $#             number of parameters
    $?             most recent exit status
    $$             current shell process ID
    $!             most recent process ID
    $0             name of executed script
    $_             absolute path to executed script
    $IFS           list of field separators
    $PATH          search path for executables (; seperated)
    a=(e1 e2 ...)  assign list of elements e1,e2,... to variable a
    ${a[i]}        use element i from array a
    ${a}           use element 0 from array a
    ${a[*]}        use all elements from array a
    ${#a[*]}       length of array a

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

## Input/Output Redirection 

Descriptors stdin 0, stdout 1, stderr 2:

    > f            create empty file f (same as : > f)
    c > f          stdout of command c to file f (same as c 1> f)
    c >> f         append stdout of c to f
    c < f          content of file f to stdin of c (same as c 0< f)
    c 1>&-         close stdout of command c
    c 2> f         stderr of c to file f
    c > f 2>&1     stdout/stderr fo command c to file f
    c &> f         same as above
    c1 <(c2)       stdout of command c2 to stdin of command c1
    c1 >(c2)       stdout of command c1 to stdin of command c2
    c < f1 > f2    content of file f1 to stdin of command c, stdout to file f2  
    (c1 ; c2) > f  redirect stdout of multiple commands to file f (sub-shell)
    {c1 ; c2} > f  same as above in current shell
    c1 | c2        pipe stdout of command c1 to stdin of command c2
    c1 |& c2       pipe stdout and stderr of command c1 to stdin of command c2
    c | tee f      stdout of command c to screen and file f
    c |:           pipeline sink (like >/dev/null)

## Expansion

    {a,b,c}        brace expansion
    {a..z}         extened brace expansion 
    ~              current user home directory (like $HOME)
    ~/path         path in home directory 
    ~user          a users home directory
    ~+             current directory (like $PWD)
    ~-             previous working directory 
    ${V}           expand variable V (curly braces optional)
    $'s'           expands string s with backslash-escaped characters replaced
    ${V:-v}        use variable V if set, otherwise use value v
    ${V:=v}        use variable V if set, otherwise set V to value v
    ${V:+v}        use value v if variable V is set
    ${V:?M}        print message M unless variable V is set
    ${#V}          length of variable V
    ${v%P}         remove shortest match of pattern P from the end  
    ${v%%P}        remove longest match of pattern P from the end
    ${v#P}         remove shortest match of pattern P from the beginning
    ${v##P}        remove longest match of pattern P from the beginning
    ${v/p/s}       replace first match of pattern p with string s
    ${v//p/s}      replace every match of pattern p with string s 
    ${p##*/}       extract filename of path p
    ${p%/*}        extract directory name of path p
    ${f%.*}        remove last suffix of file f
    ${f%%.*}       remove all suffixe of file f
    ${f#*.}        extract file extension (suffix) of file f
    ${0##*/}       name of executed file
    ${s%?}         remove last character of string s
    ${s^}          first character of string s to uppercase
    ${s,}          first character of string s to lowercase
    ${s^^}         all characters of string s to uppercase
    ${s,,}         all characters of string s to lowercase

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

