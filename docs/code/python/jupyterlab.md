# JupyterLab

Install using `pip`:

```bash
sudo apt install -y python-pip
sudo pip install jupyterlab
```

Start the server:

```bash
jupyter lab --ip=127.0.0.1
```

## Extensions

> JupyterLab extensions are npm packages (the standard package format in 
> Javascript development). [exten]

```bash
jupyter labextension list          # show installed extensions
```

Search for extensions on [Github][01] or [npm][02]

[01]: https://github.com/search?utf8=%E2%9C%93&q=topic%3Ajupyterlab-extension&type=Repositories
[02]: https://www.npmjs.com/search?q=keywords%3Ajupyterlab-extension

Noteworthy extensions include:

* [jupyterlab-toc](https://github.com/ian-r-rose/jupyterlab-toc)
* [jupyterlab-git](https://github.com/jupyterlab/jupyterlab-git)
* [jupyterlab-latex](https://github.com/jupyterlab/jupyterlab-latex)
* [jupyterlab-drawio](https://github.com/QuantStack/jupyterlab-drawio)

```bash
# install an extension
jupyter labextension install @jupyterlab/toc
```

### References

[julab] JupyterLab Documentation  
https://jupyterlab.readthedocs.io/en/stable/index.html

[exten] JupyterLab Documentation - Extensions  
https://jupyterlab.readthedocs.io/en/stable/user/extensions.html
