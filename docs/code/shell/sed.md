## Stream Editor

Use `sed` (stream editor) by piping input or reading it from a file:

```bash
cat f | sed 'c'             # input from stdin, aplly command c
sed 'c' f                   # input from file f aplly command c
sed -f f ...                # read commands from file f
sed 'c1;c2' ...             # multiple commands colon sep.
sed -e 'c1' -e 'c2' ...     # ^^ alternative
```

Stand-alone script spawns a shell calling sed, and printing
output to standard out with `$*`.

    sed 'command' $*

Call sed directly with a shebang like `#!/bin/sed -f`

Basic _command_ format (omit address to process all input lines)

    [address[,address]] instruction [arguments]

Use `;` to separate multiple commands. Available instructions:

    a\        append
    c\        change
    d         delete
    i\        insert
    n         next
    N         next without write
    p         print
    q         quit
    s/ / /    substitute (delimiter `/`)
    w file    write

Substitution commands can use an alternative separator e.g. 
`sed "s'P'S'g"` or `sed "s|P|S|g"`. Examples for substitutions:

```sed
s/P/S/             # substitute first match of pattern P with S
s/P/S/g            # substitute all matches of pattern P with S
/M/s/P/S/g         # like above but only lines matching pattern M
s/^[ \t]*//        # delete leading white spaces
s/[ \t]*$//        # delete trailing white spaces
s/^/ /             # insert leading space 
N,M s/P/S/         # substitute only in lines between N and M
N,$ s/P/S/         # substitute after line N 
```

Pattern flags are `/g` global, `/I` ignore case. `&` refers to 
pattern found, use `\` to escape.

Use with option `sed -n 'E'` to suppress unselected input when using the 
print command:

```sed
/P/p              # print lines matching pattern P 
/P/!p             # print lines not matching pattern P
N,Mp              # print lines with numbers from N to M
/P1/,/P2/p        # print lines between pattern P1 and P2
/P/{p;q;}         # print first line matching pattern P
```

### White Spaces

`crush` removes duplicate blank lines: 

```sed
#!/bin/sed -f
/^[[:blank:]]*$/d
```
```bash
>>> echo "\n\na\nb\n\nc\n" | crush
a
b
c
```

`pushin` reduces multiple spaces to one

```sed
#!/bin/sed -f
s/[ ][  ]*/ /g
```
```
>>> echo "a   b      c" | pushin
a b c
```

`chop` removes trailing spaces

```sed
#!/bin/sed -f
s/[[:blank:]]*$//
```
```bash
>>> echo "a   b      c  " | chop | cat -A
a   b      c$
```

