## termtosvg

> terminal recorder written in Python that renders your command line sessions as
> standalone SVG animations [1]

Install the Python package:

```bash
pip3 install --user termtosvg
# executables installe by Pip in Debian
test -d ~/.local/bin && export PATH=$PATH:~/.local/bin
```

Usage:

```bash
termtosvg $file.svg                 # record a terminal session
termtosvg -t $termplate ...         # use a specific template [2]
```

[1] https://github.com/nbedos/termtosvg  
[2] https://nbedos.github.io/termtosvg/pages/templates.html
