
Download and install the Miniconda Python distribution:

<https://conda.io/miniconda.html>

```bash
>>> cd /tmp && wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
>>> chmod +x Miniconda3-latest-Linux-x86_64.sh && ./Miniconda3-latest-Linux-x86_64.sh
# ...follow the installation...
# small script to add the installation to your environment
>>> echo 'export PATH=~/miniconda3/bin:$PATH' > ~/miniconda3/source_me.sh
```

## Conda

Conda installs/updates package and manages environments, cf. user guide:

→ [User Guide](https://conda.io/docs/user-guide/index.html)

Managing Python environments:

```bash
conda search --full-name python                 # list available Python versions
conda info --envs                               # display a list of all environments
conda create --name <env> python=<ver>          # install another Python version
source activate <env>                           # active environment
conda remove --name <env> --all                 # delete an environment
```
Managing packages in an environment

→ [Anaconda package list](https://docs.continuum.io/anaconda/packages/pkg-docs)

```
conda list                                      # list packages
conda search <pkg>                              # search for a package
conda install <pkg>                             # install into current environment
conda remove <pkg>                              # delete package fro current environment
```


