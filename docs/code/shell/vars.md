
## Variables and Literals 

Quoting strings:

* Variable expansion with the character `$`
* **Weak** quoting `"` (double quotes) expands arguments
* **Strong** quoting `'` (single quotes) does not expands arguments
* Prevent expansion with the escape character `\`

```bash
V=v              # assign value v to variable V (no spaces allowed)
$V               # expansion character, followed by a variable name V
's'              # preserves literal value of characters in string s
"s $V"           # preserves literal value of characters in string s except $ \ ,
\                # escape character (preserves the literal value)
"s \$V"          # using an escape sequenze to prevent variable expansion
"${V}s"          # name to be expanded in braces, protect from characters not part of the name
$'s'             # expands string s with backslash-escaped characters replaced
${V:-v}          # use variable V if set, otherwise use value v
${V:=v}          # use variable V if set, otherwise set V to value v
${V:+v}          # use value v if variable V is set
${V:?M}          # print message M unless variable V is set
${#V}            # length of variable V
${v%P}           # remove shortest match of pattern P from the end  
${v%%P}          # remove longest match of pattern P from the end
${v#P}           # remove shortest match of pattern P from the beginning
${v##P}          # remove longest match of pattern P from the beginning
${v/p/s}         # replace first match of pattern p with string s
${v//p/s}        # replace every match of pattern p with string s 
${p##*/}         # extract filename of path p
${p%/*}          # extract directory name of path p
${f%.*}          # remove last suffix of file f
${f%%.*}         # remove all suffixe of file f
${f#*.}          # extract file extension (suffix) of file f
${0##*/}         # name of executed file
${s%?}           # remove last character of string s
${s^}            # first character of string s to uppercase
${s,}            # first character of string s to lowercase
${s^^}           # all characters of string s to uppercase
${s,,}           # all characters of string s to lowercase
```

Build in environment variables

```bash
$1...$n        # direct access to parameters n
$@             # all parameters
"$@"           # each parameter in double-quotes ("$1" "$2"...)
"$*"           # all parameters in double-quotes ("$1 $2...")
$#             # number of parameters
$?             # most recent exit status
$$             # current shell process ID
$!             # most recent process ID
$0             # name of executed script
$_             # absolute path to executed script
$IFS           # list of field separators
$PATH          # search path for executables (; seperated)
$SHELL         # current interpreter
$PWD           # current working directory
$HOME          # user home directory
```

### Here-Documents

Write here-documents to a file:

```bash
cat > /path/to/file <<EOF
  ...
EOF
```

Store here-document in a variable:

```bash
var=$(cat <<EOF
  ...
EOF
)
```

Avoid substitution and expansion by quoting the tag (here EOF):

```bash
cat <<"EOF"
  ...
EOF
```

Using `<<-` suppresses leading tabs. Note that the closing tag needs to be indented by tabs (not spaces).
