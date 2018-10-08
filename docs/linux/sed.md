
# Sed (Stream Editor)

Use sed by piping input or reading it from a file:

    » cat input.txt | sed 'command'
    » sed 'command' input.txt > output.txt
    » sed -f sed.script ...
    » sed 'commnad;command' ...
    » sed -e 'command' -e 'command ...

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

    s/P/S/             substitute first match of pattern P with S
    s/P/S/g            substitute all matches of pattern P with S
    /M/s/P/S/g         like above but only lines matching pattern M
    s/^[ \t]*//        delete leading white spaces
    s/[ \t]*$//        delete trailing white spaces
    s/^/ /             insert leading space 
    N,M s/P/S/         substitute only in lines between N and M
    N,$ s/P/S/         substitute after line N 

Pattern flags are `/g` global, `/I` ignore case. `&` refers to 
pattern found, use `\` to escape.

Use with option `sed -n 'E'` to suppress unselected input when using the 
print command:

    /P/p               print lines matching pattern P 
    /P/!p              print lines not matching pattern P
    N,Mp               print lines with numbers from N to M
    /P1/,/P2/p         print lines between pattern P1 and P2
    /P/{p;q;}          print first line matching pattern P

