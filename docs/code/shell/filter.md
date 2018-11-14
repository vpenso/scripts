
Commands used to work with text (strings): 

```bash
grep                    # print lines matching a pattern
sort                    # sort lines of a text file
uniq                    # report or omit repeated lines
cut                     # remove sections from each line of files
tr                      # translate or delete characters
sed                     # stream editor for filtering and transforming text
awk                     # pattern scanning and processing language
fmt                     # text formater
paste                   # merge lines of files
split                   # split files into pieces
tac                     # concatenate and print files in reverse
```

## Characters

[ASCII](https://en.wikipedia.org/wiki/ASCII) character encoding standard:

* ASCII order (ASCIIbetical)
  - Uppercase come before lowercase letters
  - Digits and many punctuation marks come before letters
* First 32 codes (0–31 decimal) for **control characters**

Conventions to describe characters

* **Octal** digit characters (01234567), `\<octal>` 1,2 or 3 
* **Escape sequence**, starting with a backslash  `\[abfnrtv]`
* **Caret notation**, `^` followed by a single character (usually a capital letter) 

```bash
printf `\O`                         # print octal
printf '\xH'                        # print hex H
printf "\\$(printf %o D)"           # print decimal d
```

### Non-Printable Characters

Non-pritnable (white-space) characters:

* **space** (blank, word divider)
* backspace (BS), `\b`, `^H`
* **tab** (horizontal tab (HT), `\t`, `\011`, `^I`
* **newline** (line feed (LF)), `\n`, `\012`, `^J`
* null (NUL) `\0`, `^@`
* escape (ESC) `\e`, `^[`

`cat` show non-printable characters with `-A` (equivalent to `-vET`)

```bash
>>> s="\tone\n\011two\040three\0"
>>> echo "$s" | cat -A
^Ione$
^Itwo three^@$
```

^ and M- notation (100-137 ascii chars), for LF `$`

`od` show non-printable chars with backslash escapes:

```bash
>>> echo "$s" | od -c
0000000  \t   o   n   e  \n  \t   t   w   o       t   h   r   e   e  \0
0000020  \n
0000021
```

## Regex

Regular expressions (regex), strings of character that define a search pattern:

```
[a-z0-9]        matches any single lowercase letter or any digit
[^b-d]          matches any character except those in the range b to d
(a|e)           matches a or e
[:alnum:]       equivalent to [A-Za-z0-9]
[:alpha:]       equivalent to [A-Za-z]
[:digit:]       equivalent to [0-9]
[:xdigit:]      matches hexadecimal digits, equivalent to [0-9A-Fa-f]
[:blank:]       matches a space or a tab
[:space:]       all whitespace characters [ \t\v\f]
\               escape, match special character literaly
.               matches one
?               matches zero or one
!               invert match
+               matches one or more
*               matches any number
^               matches the beginning of a line
$               matches the end of a line
{N}             match N (number) of chars
{N,}            match N or more chars
{,N}            match less or equal N chars
```

```bash
grep "R" P        # match a regex R in files at path P 
```

Expression **comparison operator** matching string S with regex R

    [[ "S" =~ "R" ]]

* `0` if the regular expression matches the string
* Sub-patterns in `()` for capturing parts of the match; matches in `BASH_REMATCH[0]`

[bin/regex](../../../bin/regex) a regex with an argument list:

```bash
>>> regex '^[f,b].[o]' foo bar
regex: ^[f,b].[o]\n
foo matches
bar does not match
```

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

