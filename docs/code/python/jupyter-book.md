Jupyter Book
============

<https://jupyterbook.org>  
<https://executablebooks.org/>  
<https://github.com/executablebooks/jupyter-book>

## Example

Install Jupyter Book using a Python 3 virtual environment:

```bash
# store a virtual environment in /tmp
jupyter_book=$(mktemp -d /tmp/$USER-jupyther-book.venv.XXXXXX)
# create a new virtual environment
python3 -m venv $jupyter_book
source $jupyter_book/bin/activate
# install the required package including dependencies
pip install jupyter-book
```

Using the build in template for a skeleton book:

```bash
# create a template book called demo
jupyter-book create demo
# build the HTML book
jupyter-book build demo
# open the HTML page
$BROWSER demo/_build/html/index.html
```

<https://jupyterbook.org/content/myst.html>

Clean up:

```bash
# remove the demo book
rm -rf ./demo
# unload the virtual environment
deactivate
# remove the virtual environment
rm -rf $jupyter_book
```

```
