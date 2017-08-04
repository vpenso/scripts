

## Literals

```python
123             # 123       integer
-123            # -123      negative sign
9.23            # 9.23      float 
-1.7e-6         # -1.7e-6   scientific notation
0b010           # 2         binary notation
0o642           # 418       octal0o642
0xf3            # 243       hexadecimal 
"a\"bc"         # 'a"bc'    string (double quote)
'a\'bc'         # "a'bc"    string (singel quote)
b'abc'          # b'abc'    byte literal
```

## Variables

```python
x = 1.2 + 8     # 
x = y = z = 0   # assign the same value to multiple variables
x,y,z = 1,2,3   # multiple assignments
x,y = y,x       # variable swap
a,*b = [1,2,3]  # unpacking a sequence
del x           # remove variable
x = None        # undefined value
```

Casting:

```python
int("15")               # cast to integer
int("3f",16)            # hex-decimal to integer
int(1.23)               # float to integer truncates decimal part
float("-11.24e8")       # scientific notation
chr(64)                 # integer to character
```

Strings:

```python
type("abc")             # str
'a' + 'b'               # 'ab'      concatenation
"%s, %s" % ('a','b')    # 'a, b'    format string
'abc'[1]                # 'b'       slice access by index
'abc'[:2]               # 'ab'      from the first character 
'abc'[2:]               # 'c'       until las character
'abcde'[2:4]            # 'cd'      absolute range
"""Multi...
...line"""              # here-document
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




