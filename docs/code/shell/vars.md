
## Variables and Literals 

Quoting strings:

* **Weak** quoting `"` (double quotes) expands arguments
* **Strong** quoting `'` (single quotes) does not expands arguments
* Prevent string expansion with the escape charater `\`

```bash
'abc'            # preserves literal value of characters in string s
"abc"            # preserves literal value of characters in string s except $ \ ,
"abc \$def"      # using an escape sequenze
```

```bash
# mark line as comment
;              # statement (command) separator
\              # escape character (preserves the literal value)
:              # null-statement (returns 0)
$              # expansion character
$[e]           # evaluate integer expression
((e))          # expand and evaluate of integer expression e
$((e))         # expand, evaluate and substitute integer expression e
[[e]]          # returns bool after evaluation of the conditional expression e
V=v            # assign value v to variable V (no spaces allowed)
!e             # true if expression e is false
e1 && e2       # true if both expressions e1 and e2 are true (alternative e1 -a e2)
e1 || e2       # true if either expression e1 or e2 is true (alternative e1 -o e2)
a[i]=v         # store value v as element i in array a
{c;}           # block of code anonymous subroutine
f() {c;}       # named subroutine (key-word `function` optional)
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
a=(e1 e2 ...)  # assign list of elements e1,e2,... to variable a
${a[i]}        # use element i from array a
${a}           # use element 0 from array a
${a[*]}        # use all elements from array a
${#a[*]}       # length of array a
```

