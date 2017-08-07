
Make Python 3 the default on Debian:

```bash
>>> sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
update-alternatives: using /usr/bin/python3 to provide /usr/bin/python (python) in auto mode
>>> update-alternatives --list python
/usr/bin/python3
>>> python --version
Python 3.5.3
# Revert this change...
>>> sudo update-alternatives --remove python /usr/bin/python3
```

# Python

## Numerical

### Literals

```python
123             # integer
-123            # negative signed integer
9.23            # float 
-1.7e-6         # scientific notation
0b010           # 2         binary notation
0o642           # 418       octal
0xf3            # 243       hexadecimal 
```

### Ranges

Integer sequences:

```python
list(range(5))           # [0, 1, 2, 3, 4]
tuple(range(4,12))       # (4, 5, 6, 7, 8, 9, 10, 11)
tuple(range(0,10,2))     # (0, 2, 4, 6, 8)
tuple(range(100,0,-10))  # (100, 90, 80, 70, 60, 50, 40, 30, 20, 10)
```

## Arithmetic

```python
1+2             # 3
1-2             # -1
1*2             # 2
1/2             # 0.5
5%3             # 2 (remainder)
2**3            # 8
abs(-2.3)       # 2.3
round(1.6666,2) # 1.67
pow(2,3)        # 8
```

### Logic

```python
True               # logic true
False              # logic fales
not True           # False
True and True      # True
True and False     # False
True or False      # True
False or False     # False
## Comparison with boolean results
1 < 2              # True
1 > 2              # False
1 <= 1             # True
2 >= 3             # False
1 == 1             # True
1 != 1             # False
## Ternary conditional statement
1 if True else 2   # 1
1 if False else 2  # 2
```

Conditional statements:

* Can go with multiple `elif` followed by a single `else`
* First true condition is executed

```python
if x < 2:
    ...
elif x > 2:
    ...
else:
    ...
```

## Variables

```python
x = 1.2 + 8     # assign right expression
x = y = z = 0   # assign the same value to multiple variables
x,y,z = 1,2,3   # multiple assignments
x,y = y,x       # variable swap
a,*b = [1,2,3]  # unpacking a sequence
del x           # remove variable
x = None        # undefined value
id(x)           # return object memory address for variable x
hex(id(x))      
```

## Ordered Sequences

A **tuple** is a immutable sequences of elements with an index number and a value.

```python
# literals for tuples
()
(1,2,3)
('a','b','c')
type((1,2))             # tuple
# assign tuple to a variable t
t = ('a','b','c')
t                       # ('a', 'b', 'c')
# does a value exists in a tuple t 
'a' in t                # True
'a' not in t            # False
# access elements in a tuple t
t[0]                    # 'a'
t[-2]                   # 'b'
t[:2]                   # ('a', 'b')
t[2:]                   # ('c',)
# find index of value
t.index('b')            # 1
# number of occurrences of a given value
t.count('b')            # 1
# concatenation return a new tuple
(1, 2, 3) + (4, 5, 6)   # (1, 2, 3, 4, 5, 6)
# number of elements in a tuple
len(('a','b'))          # 2
# sort a tuple
sorted(('b','a'))       # ['a', 'b']
# smallest/largest value in tuple
min(34,23,45)           # 23'
max(34,23,45)           # 45
# convert a string to tuple
tuple('abcd')           # ('a', 'b', 'c', 'd')
# convert a list into a tuple
tuple([1,2,3,4,5])      # (1, 2, 3, 4, 5)
```

A **list** is a sequences (with dynamic length) of elements with an index number and a value. 

```python
type([1,'a',2])         # list
[]                      # empty list
l = [1,2,'a',3,'b']     # list assignment to variable
# append value to the end of the list list
l.append(4)             
# append multiple values to list
l.extend([5,'c'])
# print a list
l                       # [1, 2, 'a', 3, 'b', 4, 5, 'c']
# does a value exists in a list
'a' in l                # True
# find index of a value
l.index('a')            # 2
# number of elements in list
len(l)                  # 8
# access values by index
l[:]                    # [1, 2, 'a', 3, 'b', 4, 5, 'c']
l[:4]                   # [1, 2, 'a', 3] 
l[-4]                   # 'b'
l[4:-1]                 # ['b', 4, 5]
# delete element by value 
l.remove(3)             
l                       # [1, 2, 'a', 'b', 4, 5, 'c']
# remove index from list and return its value
l.pop(-1)               # 'c' 
l                       # [1, 2, 'a', 'b', 4, 5]
# concatenation return a new list
l + [6,7,'c']           # [1, 2, 'a', 'b', 4, 5, 6, 7, 'c']
l                       # [1, 2, 'a', 'b', 4, 5]
# delete element by index
del l[3]
l                       # [1, 2, 'a', 4, 5]
# number of occurrences of a given value
l.count('a')            # 1
# shallow copy of the list
m = l.copy()
m[0] = 'z'
l                       # [1, 2, 'a', 4, 5]
m                       # ['z', 2, 'a', 4, 5]
# iteration
for i in l: print(l.index(i),i)
# convert a string into a list
list("abcde")           # ['a', 'b', 'c', 'd', 'e']
# convert tuple into a list
list((1,2,3,4,5,6))     # [1, 2, 3, 4, 5, 6]
```

## Unordered Collections

A **set** is a unordered collections of unique elements:

```python
{}
{1,2,'a'}               # {1, 2, 'a'}
{1,2,1,2,1}             # {1, 2}
type({1,2})             # set
# union
{1,2} | {2,3,4}         # {1, 2, 3, 4}
# intersection
{1,2} & {2,3,4}         # {2}
# difference
{1,2} - {2,3,4}         # {1}
# symmetric difference
{1,2} ^ {2,3,4}         # {1, 3, 4}
# does a value exists in set
1 in {1,2,3}            # True
'a' in {1,2,3}          # False
# iterator
for v in {1,2,3}:
```

A **dictionary** is a associative list with defined keys and values.

```python
{}
{1:'a','b':2}          # {1: 'a', 'b': 2} 
# add/change key/value
d = {}
d['a'] = 1             
d['b'] = 2             
d                      # {'a': 1, 'b': 2}
d['b']                 # 2
# remove element by key
del d['a']
d                      # {'b': 2}
# merge 
d.update({'c':3, 'd':4})
d                      # {'b': 2, 'c': 3, 'd': 4}
# remove element, return value
d.pop('c')             # 3
d                      # {'b': 2, 'd': 4}
# get a value
d.get('b')             # 2
d                      # {'b': 2, 'd': 4}
# remove all elements
d.clear()
d                      # {}
# iterators
for k in d.keys()
for v in d.values()
for k,v in d.items()
# conversion
dict(a=1,b=2,c=3)                  # {'a': 1, 'b': 2, 'c': 3}
dict(zip(['a','b'],[1,2]))         # {'a': 1, 'b': 2}
```

## Strings

### Literals

Escape sequences interpreted according to rules similar to those used by Standard C

```python
# Double quote (escape with \)
"a\"bc"                            # 'a"bc'
# Single quote
'a\'bc'                            # "a'bc"
# Multi-line strings in triple (double/single) quotes
"""string"""
# Raw strings
r"\t\n\\"                          # '\\t\\n\\\\'
R"\"\n\""                          # '\\"\\n\\"'
```

**Raw-string** prefixed with `r` or `R` use different rules for backslash escape sequences


### Format

```python
## format() method of the String class ##
"{}|{}".format(1,2)                            # '1|2'
# ...postional index
"{1},{0},{2}".format('r','s','t')              # 's,r,t'
# ...parameter names
"{b}{a}".format(a='s',b='t')                   # 'ts'
# ...nested data structures
'{d[2]},{d[0]}'.format(d=['r','s','t'])        # 't,r'
'{d[b]},{d[a]}'.format(d={'a':1,'b':2})        # '2,1'
## Padding ##
"{:4d}".format(123)                            # ' 123'
'{:06.2f}'.format(3.14159)                     # '003.14'
"{:>3}".format('s')                            # '  s'
"{:.<4}".format('s')                           # 's...'
"{:^5}".format('s')                            # '  s  '
## Parametrized format ##
'{:{a}{w}}'.format('s',a='>',w=5)              # '    s'
# ...postional arguments
'{:{}{}{}.{}}'.format(2.7182,'>','+',10,3)     # '     +2.72'
## Global build in function ##
format(10.0,"7.3g")                            # '     10'
## Legacy format operator ##
"%s, %s" % ('s','t')                           # 's, t'
```

### Manipulation

```python
# Concatenation
"s" + "t"                          # 'st'
# Cut by separator
"s\nt\nr\n".splitlines()           # ['s', 't', 'r']
"s|t".split("|")                   # ['s', 't']
'p:q:r:s'.rsplit(':',2)            # ['p:q', 'r', 's']
# return tuple, preserve the delimiter
"s:r:t".partition(':')             # ('s', ':', 'r:t')
"s:r:t".rpartition(':')            # ('s:r', ':', 't')
# Leading, trailing white-space management 
" s ".strip()                      # 's'
# Matching
't' in 'str'                       # True
"st".startswith('s')               # True
'str'.endswith('r')                # True
'strts'.find('r')                  # 2
# Replacement
'srtr'.replace('r','R')            # 'sRtR'
```

## Modules

Load a module:

```python
import math
math.pi          # 3.141592653589793
math.sqrt(81)    # 9.0
```

Load module, and allow direct access to functions:

```python
from math import pi,e,sin,log
sin(pi/4)       # 0.7071067811865475
log(e**2)       # 2.0
```

Cf. [Python Module Index](https://docs.python.org/3/py-modindex.html)

## Runtime Environment

Standard output, error, and input stream:

```python
import sys
sys.argv                        # list of command line arguments
sys.stdout.write(s)             # write string s to standard output
sys.stderr.write(s)             # write string s to standard error
s = sys.stdin.read()            # read from standard input
sys.exit(i)                     # exit with error code i
```

## Functions

Functions are defined using the `def` keyword

* Followed by the function **name**, i.e. `f`
* **Arguments** given between parentheses followed by `:` (colon) 
* The function **body** (blocks) must be indented
* The `return` keyword passes values from the function 

```python
# inculde argument with default value
def f(x,y,z=3)
    """documentation"""
    return (x,y,z)
f(1,2)                        # (1, 2, 3)
# variable positional arguments as tuple
def g(x,*y):
    return (x,y)
g(1,2,3,4,5,6)                # (1, (2, 3, 4, 5, 6))
# variable named arguments as dict
def h(x,**y):
    return [x,y]
h(1,a=1,b=2)                  # [1, {'a': 1, 'b': 2}]
```


## File I/O

Use `open()` to store data in a file and read it back:

* The **path** to the file is the first argument.
* Followed by the access mode: `r` (read), `w` (write), `a` (append)
* Encoding: 'ascii', 'utf8'

```python
txt = "1st line\n2nd line\n3rd line\n4th line"
path = '/tmp/file.txt'
## write into a file
f = open(path,'w',encoding='utf8')
f.write(txt)                   # write into the file
f.flush()                      # write cache
f.close()                      # close when finished
f = open(path,'r')
f.name                         # path ot the file '/tmp/file.txt'
f.read()                       # read entire file
# iterate over file content
for l in f.readlines()         # by line
for l in iter(f): 
for l in f.read().split('\n')  # by seperator
```

