# Environment Modules

http://modules.sourceforge.net/

Configures a shell environment in a comfortable and modular way:

* Based on **modulefiles** containing environment settings for an application (software).
* Dynamically adds (or removes) software packages to a shell environment (i.e. `$PATH` or `$LD_LIBRARY_LOAD`).
* Allows to use multiple versions of a software package by loading the proper module.
* Module files are create per application and per version.

```bash
yum install -y environment-modules                    # install on CentOS
apt-get install environment-modules                   # install on Debian
/etc/profile.d/modules.sh                             # system module initialization
cat ${MODULESHOME}/init/.modulespath | grep -v ^#     # default module search path
```

## Modulefiles

The following example illustrates how a modulefile is created:

```bash
>>> ls /opt/openmpi/2.1.1/
bin  configure.log  etc  include  install.log  lib  make.log  share
>>> mkdir -p /opt/modulefiles/openmpi/
>>> cat /opt/modulefiles/openmpi/2.1.1
#%Module1.0
proc ModulesHelp { } {
  puts stderr "openmpi/2.1.1 - Adds OpenMPI 2.1.1 from /opt/openmpi/2.1.1 to the environment."
}

module-whatis                      "OpenMPI 2.1.1"
set             OPENMPI_PATH       /opt/openmpi
set             OPENMPI_VERSION    2.1.1
prepend-path    PATH               $OPENMPI_PATH/$OPENMPI_VERSION/bin
prepend-path    LD_LIBRARY_PATH    $OPENMPI_PATH/$OPENMPI_VERSION/lib
prepend-path    INCLUDE_PATH       $OPENMPI_PATH/$OPENMPI_VERSION/include
>>> module use /opt/modulefiles/
>>> module whatis openmpi/2.1.1
openmpi/2.1.1        : OpenMPI 2.1.1
>>> module show openmpi/2.1.1
-------------------------------------------------------------------
/opt/modulefiles//openmpi/2.1.1:

module-whatis    OpenMPI 2.1.1
prepend-path     PATH /opt/openmpi/2.1.1/bin
prepend-path     LD_LIBRARY_PATH /opt/openmpi/2.1.1/lib
prepend-path     INCLUDE_PATH /opt/openmpi/2.1.1/include
-------------------------------------------------------------------
>>> module load openmpi/2.1.1
>>> module list
Currently Loaded Modulefiles:
  1) /openmpi/2.1.1
>>> which mpirun
/opt/openmpi/2.1.1/bin/mpirun
```

Cf. [modulefile(4)](http://modules.sourceforge.net/c/modulefile.html)

## Usage

```bash
module use <path>                                     # use module files from given path
module avail                                          # list available modules
module load <module>                                  # add module into the environment
module list                                           # list loaded module
module unload <module>                                # remove module from the environment
module purge                                          # remove all modules from the environment
```
