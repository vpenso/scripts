

## Usage

`conda` installs (updates) packages and manages environments → [User Guide](https://conda.io/docs/user-guide/index.html).

Managing Python environments:

```bash
conda info                                          # basic information
conda info --envs                                   # display a list of all environments
conda search --full-name python                     # list available Python versions
conda create --name <env> python=<ver> [<pkg>]      # install global environment
conda create --prefix ~/<path> python=<ver> [<pkg>] # install use specific version
source activate <env>                               # load global environment
source activate ~/<path>                            # load user specific environment
source deactivate                                   # unload environment
conda remove --name <env> --all                     # delete an environment
```
Managing packages in an environment

→ [Anaconda package list](https://docs.continuum.io/anaconda/packages/pkg-docs)

```
conda list                                      # list packages
conda search <pkg>                              # search for a package
conda install <pkg>                             # install into current environment
conda update <pkg>                              # update package in current environment
conda remove <pkg>                              # delete package fro current environment
```

## Deploy

Download and install the [Miniconda](https://conda.io/miniconda.html) Python distribution:

<https://repo.continuum.io/miniconda/>

```bash
>>> wget https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh
>>> chmod +x Miniconda3-4.3.21-Linux-x86_64.sh
>>> ./Miniconda3-4.3.21-Linux-x86_64.sh -b -p /opt/conda/4.3.21
```

Environment module configuration:

```bash
>>> cat /usr/share/modules/modulefiles/conda/4.3.21
#%Module1.0
set             CONDA_PATH           /opt/conda
set             CONDA_VERSION        4.3.21
prepend-path    PATH                 $CONDA_PATH/$CONDA_VERSION/bin
prepend-path    LD_LIBRARY_PATH      $CONDA_PATH/$CONDA_VERSION/lib
module-whatis                        "Conda 4.3.21 from /opt/conda/4.3.21"
proc ModulesHelp { } {
  puts stderr "conda/4.3.21 - Adds Conda 4.3.2 from /opt/conda/4.3.21 to the environment."
}
>>> module load conda/4.3.21
>>> which conda
/opt/conda/4.3.21/bin/conda
```
