# Interactive Python

Keyboard shortcuts:

```
ctrl-l                 clear terminal
ctrl-c                 interrupt command
ctrl-d                 exit session
ctrl-r                 search command history
ctrl-a                 cursor to the beginning of the line
ctrl-e                 cursor to the end of the linr
ctrl-k                 cut text from cursor to end of line
ctrl-u                 cut text from beginning of line to cursor
ctrl-y                 yank (paste) text cut before
```

## Documentation

Access the documentation with the build-in `help(<obj>[.<method>])` function. 

Alternatively use the short hand `<obj>[.<method>]?` with a question mark:

```
In [1]: tuple?
Init signature: tuple(self, /, *args, **kwargs)
Docstring:
tuple() -> empty tuple
tuple(iterable) -> tuple initialized from iterable's items

If the argument is a tuple, the return value is the same object.
Type:           type
In [2]: list.index?
Docstring:
L.index(value, [start, [stop]]) -> integer -- return first index of value.
Raises ValueError if the value is not present.
Type:      method_descriptor
```

It support objects **methods**, and includes **user defined code**.

```
In [3]: def square(a):
   ...:     """Return square of argument."""
   ...:     return a**2
   ...:
In [4]: square?
Signature: square(a)
Docstring: Return square of argument.
Type:      function

In [5]: square??
Signature: square(a)
Source:
def square(a):
    """Return square of argument."""
    return a**2
Type:      function
```

Display **source code** with the short hand `<obj>[.<method>]??` (two questions marks), unless it is a build-in implemented in C.

Help support wild card completion? 

```
In [6]: C*Error*?
ChildProcessError
ConnectionAbortedError
ConnectionError
ConnectionRefusedError
ConnectionResetError
In [7]: dict.*__g*?
dict.__ge__
dict.__getattribute__
dict.__getitem__
dict.__gt__
```

## Magic Commands

The `%lsmagic` command lists all magic commands:

* Single magic commands are prefixed with **%** (percent)
* Multi-line expressions start with **%%** (double percent)
* Prefix the magic command with **?** (question mark) to see the help text

```
In [1]: ?%lsmagic
Docstring: List currently available magic functions.
File:      /usr/lib/python3/dist-packages/IPython/core/magics/basic.py
In [2]: %cat square.py
def square(a):
    """Return square of argument."""
    return a**2

print(square(2))
print(square(10))

In [2]: %run square.py
4
100
```

General description of magic functions is available with `%magic`.

## Shell Commands

Shell commands are prefixed with **!**, which can be omitted if auto-magic is on:

```
In [1]: %automagic 1

Automagic is ON, % prefix IS NOT needed for line magics.
In [2]: ls
ipython.md  jupyter.ipynb  mathplot.ipynb  numpy.md  README.md
```

Store output of a shell command into a variables by assignment. (Here the exclamation mark is required)

```
In [3]: files = !ls
In [4]: print(files)
['ipython.md', 'jupyter.ipynb', 'mathplot.ipynb', 'numpy.md', 'README.md']
In [5]: s = "cheers"
In [6]: !echo {s}
```

Interpolate the contents of a variable with `{<var>}`.

Subshell started with `!` are non-interactive non-login instance of the user's default shell:

```bash
In [1]: !echo $SHELL
/bin/zsh
In [2]: !ps -p $$ && :
  PID TTY          TIME CMD
  19295 pts/5    00:00:00 zsh
```

ZSH user need to load their custom environment with `~/.zshenv`


