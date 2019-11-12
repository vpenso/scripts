Install JupyterLab on Debian:

```bash
sudo apt install -y python python-pip python3 python3-pip
sudo python3 -m pip install jupyterlab
# (optional) install Python 2 kernel
sudo python2 -m pip install ipykernel
sudo python2 -m ipykernel install --user
```

Start the server:

```bash
jupyter lab
```

## Kernels

> Kernels are separate processes started by the server that run your code in 
> different programming languages and environments […] connect any open text
> file to a code console and kernel. This means you can easily run code from 
> the text file in the kernel interactively. [kern]

```bash
jupyter kernelspec list               # list installed kernels
```

Install a kernel for [Bash](https://github.com/takluyver/bash_kernel)

```bash
sudo python3 -m pip install bash_kernel
python3 -m bash_kernel.install
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

* [jupyterlab-drawio](https://github.com/QuantStack/jupyterlab-drawio)
* [jupyterlab-git](https://github.com/jupyterlab/jupyterlab-git)
* [jupyterlab-latex](https://github.com/jupyterlab/jupyterlab-latex)
* [jupyterlab-toc](https://github.com/ian-r-rose/jupyterlab-toc)
* [jupyterlab-vim](https://github.com/jwkvam/jupyterlab-vim)

```bash
sudo apt install -u nodejs npm
# install an extension
sudo jupyter labextension install @jupyterlab/toc
sudo jupyter labextension install jupyterlab_vim
```

### References

[julab] JupyterLab Documentation  
https://jupyterlab.readthedocs.io/en/stable/index.html

[exten] JupyterLab Documentation - Extensions  
https://jupyterlab.readthedocs.io/en/stable/user/extensions.html

[kern] JupyterLab Documentation - Documents and Kernels  
https://jupyterlab.readthedocs.io/en/stable/user/documents_kernels.html

[kerls] Jupyter Kernel List  
https://github.com/jupyter/jupyter/wiki/Jupyter-kernels

[docks] Jupyter Notebooks on DockerHub  
https://hub.docker.com/r/jupyter/minimal-notebook
