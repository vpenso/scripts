# Expressions

Conditional expressions:

* `&&` (and), `||` (or) have no precedence (left-associative)
* Bit faster the `if...then`

```bash
!e             # true if expression e is false
e1 && e2       # true if both expressions e1 and e2 are true (alternative e1 -a e2)
e1 || e2       # true if either expression e1 or e2 is true (alternative e1 -o e2)
[[e]]          # returns bool after evaluation of the conditional expression e
:              # null-statement (returns 0)
$[e]           # evaluate integer expression
((e))          # expand and evaluate of integer expression e
$((e))         # expand, evaluate and substitute integer expression e
```

Brace expansion

```bash
{a,b,c}                             # brace expansion
{a..z}                              # extened brace expansion, ranges
name.{foo,bar}                      # typical for files
name{,.foo}                         # includes name
{1..20}                             # digits
{01..20}                            # with leading zero
{20..1}                             # reverse
{0..10..2}                          # use increments
{a..d}{1..3}                        # combine braces
```

Use the conditional operator test `[[...]]` to evaluate:

```bash
# string compare
s1 = s2         # true if strings s1 equals s2 
s1 != s2        # true if strings s1 not equal s2
-n s            # true if string s is not empty
-z s            # true if string s is empty
# file conditions
-c f            # true if f is a special character file
-d p            # true if p is the path to an existing directory
-e f            # true if f is an existing file
-f f            # true if f is an existing file but not an directory
-G f            # true if f exists and is owned by effective group-id
-g f            # true if f exists and is set-group-id.
-k f            # true if f has sticky bit
-L f            # true if f is a symbolic link
-O f            # true if f exists and is owned by the effective user-id.
-r f            # true if f is readable
-S f            # true if f is socket
-s f            # true if f nonzero size
-u f            # true if f set-user-id bit is set
-w f            # true if f is writable
-x f            # true if f is executable
f1 -nt f2       # true if file f1 is newer the f2
f1 -ot f2       # true if file f1 os older then f2
# numerical comparison
n1 -lt n2       # true if integer n1 less then n2
n1 -gt n2       # true if n1 greater then n2
n1 -le n2       # true if n1 less or equal n2
n1 -ge n2       # true if n1 greater or equal n2
n1 -eq n2       # true if n1 equals n2
n1 -ne n2       # true if n1 not equal n2
```

Distinguish between empty and unset strings:

```bash
case ${var+x$var} in
	(x) echo empty;;
	("") echo unset;;
	(x*[![:blank:]]*) echo non-blank;;
	(*) echo blank
esac
```

