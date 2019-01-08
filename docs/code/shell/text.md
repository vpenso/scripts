# Text

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

## Encoding

[Code][co], system of rules to **convert information** (letters, words, sound, images) 
into another form or representation for data transmissions/storage:

* **Decoding** is the reverse process, converting code symbols back
* [Character encodings][cc] are representations of textual data
* Character encoding associated with a specific character set (collection or representable characters)

[co]: https://en.m.wikipedia.org/wiki/Code
[cc]: https://en.m.wikipedia.org/wiki/Character_encoding

```bash
locale                   # current language and encoding settings           
localectl                # ^^with systemd tools
file -bi <file>          # show file encoding
# change encoding from ASCII to UTF-8
iconv -f utf-8 -t ascii -o <out_file> <in_file>
# change encoding from UTF-8 charset to ASCII, omit invalid characters
iconv -c -f utf-8 -t ascii -o <out_file> <in_file>
```

### Standards

[ASCII][ai], single byte encoding only using the bottom **7 bits**

* ASCII order (ASCIIbetical)
  - Uppercase come before lowercase letters
  - Digits and many punctuation marks come before letters
* First 32 codes (0–31 decimal) for **control characters**
* Many 8-bit encodings which are supersets of ASCII

[UTF-8][u8], general-purpose way of representing [Unicode][un] characters

* Character encoded as sequence of 1-4 bytes (variable width character encoding)
* Designed for backward **compatibility with ASCII** (valid ASCII text is valid UTF-8-encoded Unicode)
* Unicode [code charts][uc]

[ai]: https://en.m.wikipedia.org/wiki/ASCII
[uc]: http://www.unicode.org/charts/
[un]: https://en.m.wikipedia.org/wiki/Unicode
[u8]: https://en.m.wikipedia.org/wiki/UTF-8 

### Conversion

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

Regular expressions (regex), strings of character that define a search pattern.

```
## ranges
.               # any character (except newline)
(a|e)           # a or e
(...)           # group
[a-z0-9]        # range, lowercase letter or any digit
[^b-d]          # invert of range b to d
## quanrifiers
*               # 0 or more
?               # 0 or 1
+               # 1 or more
{N}             # exactly N (number)
{N,}            # N or more
{,N}            # less or equal to N
{N,M}           # between N and M
## anchors
^               # start of line
$               # end of line
```

`^$()<>[{\|.+*?` must be escaped with the character `\`

Character classes:

```bash
\c              # control character
\s              # white space
\S              # not white space
\d              # digit
\D              # not digit
\w              # word
\W              # not word
\xHH            # hex char HH
\Oxxx           # octal char xxx
### POSIX
[:alnum:]       # equivalent to [A-Za-z0-9]
[:alpha:]       # equivalent to [A-Za-z]
[:digit:]       # equivalent to [0-9]
[:xdigit:]      # matches hexadecimal digits, equivalent to [0-9A-Fa-f]
[:blank:]       # matches a space or a tab
[:space:]       # all whitespace characters [ \t\v\f]
```

Example patterns

```bash
([A-Za-z0-9-]+)                             # Letters, numbers and hyphens
(\d{1,2}\/\d{1,2}\/\d{4})                   # date DD/MM/YYYY
(#?([A-Fa-f0-9]){3}(([A-Fa-f0-9]){3})?)     # hex colour code
(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})            # email address
(\<(/?[^\>]+)\>)                            # HTML tag
```

### grep

Variants of the grep command

```
agrep         #  approximately matching a pattern
egrep         # extended regex
rgrep         # recursive grep
zgrep         # search compressed files
```

Examples:

```bash
# case insensitve search
>>> grep -i name /etc/os-release
PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
NAME="Debian GNU/Linux"

# use extended regex to match words
>>> grep -E -w 'bin|sys|adm' /etc/group
bin:x:2:
sys:x:3:
adm:x:4:

# match a regex in a file
>>> grep '^s[y,s].\:' /etc/group
sys:x:3:
ssh:x:112:

# match CIDR IP addresses from STDIN
>>> ip a | egrep -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}\/[0-9]{1,3}'
127.0.0.1/8
140.181.84.103/18
```


### Comparison Operator

Expression comparison operator matching string S with regex R

```bash
[[ "test" =~ "^t*" ]] && echo match
```

* `0` if the regular expression matches the string
* Sub-patterns in `()` for capturing parts of the match; matches in `BASH_REMATCH[0]`

[bin/regex](../../../bin/regex) matches a regex with an argument list:

```bash
>>> regex '^[f,b].[o]' foo bar
regex: ^[f,b].[o]\n
foo matches
bar does not match
```

