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

---

# References

[bwrge] BRE/ERE Regular Expressions  
<https://learnbyexample.github.io/learn_gnugrep_ripgrep/breere-regular-expressions.html>  
<https://learnbyexample.github.io/gnu-bre-ere-cheatsheet>
