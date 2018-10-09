
## Runtime Environment

Use following libraries:

* [argparse](https://docs.python.org/3/library/argparse.html) to parse command-line options, arguments and sub-commands
* [logging](https://docs.python.org/3/library/logging.html) for multi-level application logging

Following script can be used as a starting point:

↴ [python-skeleton](../bin/python-skeleton)

Runtime services in the [sys](https://docs.python.org/3/library/sys.html) library:

```python
import sys
sys.argv                        # list of command line arguments
sys.stdout.write(s)             # write string s to standard output
sys.stderr.write(s)             # write string s to standard error
s = sys.stdin.read()            # read from standard input
sys.exit(i)                     # exit with error code i
```

Python modules executable as main program also:

* Source files executed as the main program have the variable `__name__` set to `__main__`
* Call an optional `main()` function if not loaded by an `import <module>`

```python
def main():
    pass

if __name__ == '__main__':
    main()
```

# Python Language

## Variables

The **assigns operation** `name = object` references values to variables:

* Assignment **declares** and **initializes** a variable with a value
* Most suitable data type for assignment is select automatically by the interpreter.
* A cascading assignment **modifies** an object referenced by a variable

```python
x = 1.2 + 8     # assign right expression
x = y = z = 0   # assign a single value to multiple variables
x,y,z = 1,2,3   # multiple assignments
x,y = y,x       # variable swap
a,*b = [1,2,3]  # unpacking a sequence
del x           # remove variable
x = None        # undefined value
id(x)           # return object memory address for variable x
hex(id(x))      # ...hexadecimal memory address
globals()       # dictionary of global variables
```


**Naming conventions**:

```python
var_with_sep    # underscore separated downcase letters
_               # unused variable (i.e. within a loop)
var             # public
_var            # internal
var_            # convention to avoid conflict keyword
__var           # private use in class
_var_           # protected use in class
__var__         # "magic: method or attribute
```

* Names are case sensitive
* Python keywords can not be used as names

## Numbers

Type      | Description
----------|-------------------------------
`int`     | Integer number are of arbitrary size
`float`   | Floating point number precision depends on the implementation and system architecture
`complex` | Complex number

### Literals

```python
123             # integer
-123            # negative signed integer
9.23            # float 
-1.7e-6         # scientific notation
2 + 1j          # complex number
0b010           # 2         binary notation
0o642           # 418       octal
0xf3            # 243       hexadecimal
None            # indefined value
```

Types, and type-casting:

```python
type(1)                  # <class 'int'>
type(1.2)                # <class 'float'>
type(None)               # <class 'NoneType'>
## string to numerical
int('123')               # 123
float('1.23')            # 1.23
## Type check ##
isinstance(10,int)       # True
isinstance(1.234,float)  # True
```

**Ranges**, integer sequences:

```python
list(range(5))           # [0, 1, 2, 3, 4]
tuple(range(4,12))       # (4, 5, 6, 7, 8, 9, 10, 11)
tuple(range(0,10,2))     # (0, 2, 4, 6, 8)
tuple(range(100,0,-10))  # (100, 90, 80, 70, 60, 50, 40, 30, 20, 10)
```

### Arithmetic

```python
1+2                       # 3
1-2                       # -1
1*2                       # 2
1/2                       # 0.5
5%3                       # 2 (remainder)
2**3                      # 8
## Built-in functions ##
abs(-2.3)                 # 2.3
round(1.6666,2)           # 1.67
pow(2,3)                  # 8
sum((1,2,3,4,5))          # 15
max([1,2,3,4,5])          # 5
min([1,2,3,4,5])          # 1
```

### Logic

```python
## Booleans
True               # logic true
False              # logic fales
not True           # False
True and True      # True
True and False     # False
True or False      # True
False or False     # False
1                  # True
0                  # False
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

## Control & Loop Constructs

Block **indentation**:

* Blocks of code begin with a colon (:) and contain indented lines below (no ending identifier)
* Always use **4 spaces** for indentation
* Single line statements may be put on the same line (considered bad style)
* Empty blocks cause an _IndentationError_, use `pass` (a command that does nothing)`

### Conditional Statements

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

Python has no direct analogous to a switch-case statement. 

```python
def switch(case):
    return {
        'a': 'A',
        'b': 'B'
    }.get(case,None)

print(switch('a'))                   # A
```
```python
def a():
    return 'A'

def b():
    return 'B'

switch = { 'a': a(), 'b': b() }

print(switch['a'])                   # A
```

## Sequences & Collections

### Tuple

A tuple is a immutable sequences of elements with an index number and a value.

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

### List

A list is a sequences (with dynamic length) of elements with an index number and a value. 

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

### Set

A set is a unordered collections of unique elements:

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

### Dictionary

A dictionary is a associative list with defined keys and values.

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
## Multi-line strings in triple (double/single) quotes ##
"""string"""
## Raw strings ##
r"\t\n\\"                          # '\\t\\n\\\\'
R"\"\n\""                          # '\\"\\n\\"'
## Built-in function to get ASCII codes ##
ord('a')                           # 97
```

**Raw-string** prefixed with `r` or `R` use different rules for backslash escape sequences

### Format

```python
## format() method of the String class ##
"{}|{}".format(1,2)                            # '1|2'
# ...positional index
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
# ...positional arguments
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
# Join by separator
':'.join('123')                    # '1:2:3'
# Leading, trailing white-space management 
" s ".strip()                      # 's'
# Matching
't' in 'str'                       # True
"st".startswith('s')               # True
'str'.endswith('r')                # True
'   '.isspace()                    # True
'12'.isdecimal()                   # True
'1.2'.isdecimal()                  # False
'strts'.find('r')                  # 2
# Replacement
'srtr'.replace('r','R')            # 'sRtR'
'srtr'.replace('r','R',1)          # 'sRtr'
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

Using a **context manager**:

```python
with open('/etc/hosts') as f:
    for _ in f.readlines():
        print(_)
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

### Lambda

The [Lambda][lambda] expression (anonymous function) creates a function objects with following notation:

    lambda: <<args,...>> : <<expression>>

Semantically `lambda` is a shorthand for a function definition:

* Lambda functions can be used wherever function objects are required.
* It can have **any number of arguments** before the colon.
* The function **body** is syntactically restricted to a **single expression**.
* Typically used as nameless function as argument to a higher-order function.

```python
f = lambda x,y : x+y
f(1,1)                        # 2
f = lambda x: x**2 + 2*x - 5
f(2)                          # 3
# Fahrenheit to Celsius conversion
f2c = lambda c: float('{:.2f}'.format((5.0 / 9) * ( c - 32 )))
f2c(32)                       # 0
```

Lambda functions are used along with build-in function like `map()`, or `filter()`.

[lambda]: https://docs.python.org/3.6/tutorial/controlflow.html#lambda-expressions

### Map

The `map(<<func>>,<<sequence>>)` function applies a function to every item in an sequence. It returns a list containing all the function call results.

```python
def sqr(x): return x ** 2
list(map(sqr, [1, 2, 3, 4, 5]))                            # [1, 4, 9, 16, 25]
# with a lambda expression
list(map(lambda x: x+1, [1,2,3,4,5,6]))                    # [2, 3, 4, 5, 6, 7]
list(map(lambda x: x**2, range(0,12,2)))                   # [0, 4, 16, 36, 64, 100]
```

### Filter

The `filter(<<func>>,<<sequence>>)` function extracts each element in a sequence for which a function returns `True`.

```python
list(filter(lambda x: x<0,range(-5,5)))                     # [-5, -4, -3, -2, -1]
list(filter(lambda x: (x%2==0), [1,5,4,6,8,11,3,12]))       # [4, 6, 8, 12]
## intersection
a,b = [1,2,3,5,7,9],[2,3,5,6,7,8]
list(filter(lambda x: x in a,b))                            # [2, 3, 5, 7]
```

### Reduce

The `reduce()` function reduces a sequence to a single value by combining all elements via a defined function. 

    reduce(<<func>>,<<sequence>>[,<<initializer>>])

By default, the first item in the sequence initialized the starting value.

```python
from functools import reduce
reduce(lambda x,y: x+y, [1,2,3,4])                          # 10
reduce(lambda x,y: x*y, [2,3],2)                            # 12
import operator
reduce(operator.sub,[50,3,4,6])                             # 37
## flatten a list
reduce(list.__add__, [[1, 2, 3], [4, 5], [6, 7, 8]], [])    # [1, 2, 3, 4, 5, 6, 7, 8]
## union of a list of sets
reduce(operator.or_, ({1},{1,2},{1,3}))                     # {1, 2, 3}
## intersection of a list of sets
reduce(operator.and_, ({1},{1,2},{1,3}))                    # {1}
```

## Classes

Classes, instances, and data attributes:

* A class is defined with the keyword `class` followed by a name (capitalized) and colon.
* Class instantiation uses function notation to assign a class object (**instance**") to a variable.
* Class attributes are referenced with the **dot notation** `<object>.<attribute>`.
* Object data attributes (**instance variables**) need not be declared, they are assigned on first used.

```python
class Human():      # define a class called Human
    pass            # Use pass for a class without attributes/methods

# create two instances of the class
alice = Human()
bob = Human()

# set data attributes of both instances
alice.age = 25
bob.age = 31

# print instance attributes
print(bob.age,alice.age) # 31 25
```

### Class Constructor & Instance Methods

* **Methods** automatically pass a class object `self` (by convention) as first argument.
* The method `__init__()` (the constructor) is automatically invoked on newly-created class instances.
* Instance objects can use **attribute references** to data attributes and methods.

```python
class Human():
    # constructor
    def __init__(self, name, age):
        self.name = name
        self.age = age
    # method
    def who(self):
        return '{} age {}'.format(self.name, self.age)

# Iterate over two class objects
for _ in (Human('alice',25),Human('bob',31)):
    # call the method of an object
    print(_.who())
    # pass an object to a method
    print(Human.who(_))
```

### Class Variables & Class Methods

Class variables:

* Shared among all instances of a class
* Accessible as `<class>.<attribute>` or as `<object>.<attribute>`

Class methods:

* Declared with a decorator `@classmethod`
* Automatically pass a class as first argument called `cls` (by convention)
* Typically use to build alternative constructors

```python
class Human():

    num = 0 # define a class variable

    # constructor
    def __init__(self, name, age):
        self.name = name
        self.age = age
        # increment the number of humans
        Human.num += 1

    # decorator to identify a class method
    @classmethod
    def from_str(cls, string):
        name, age =  string.split(':')
        return Human(name,age)

    # method
    def who(self):
        # use self to access a class variable
        return '{} age {} [of {}]'.format(self.name, self.age, self.num)

humans = [
  Human('alice',25),
  Human('bob',31),
  Human.from_str('joe:19')
]

print(humans[2].who())       # joe age 19 [of 3]
```

### Class Properties

A method used to get a value is decorated with `@property` before its definition.

A method used to set a value is decorated with `@<<name>>.setter` before its definition.

```python
class C:

    def __init__(self,v):
        self._v = v
    # getter
    @property
    def v(self):
        return self._v
    # setter
    @v.setter
    def v(self,__):
        self._v = __

c = C(123)
c.v = 321         # set a value
print(c.v)        # get a value
```
