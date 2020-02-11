# Spack

> Spack is a package management tool designed to support multiple versions and
> configurations of software on a wide variety of platforms and environments. It
> was designed for large supercomputing centers, where many users and
> application teams share common installations of software on clusters with
> exotic architectures, using libraries that do not have a standard ABI. Spack
> is non-destructive: installing a new version does not break existing
> installations, so many configurations can coexist on the same system.

→  [Spack - Web-Site](https://spack.io)  
→  [Spack - Documentation](https://spack.readthedocs.io)  
→  [Spack - Source Code](https://github.com/spack/spack), GitHub

* Install software either from source or from a binary cache
* Mirror all source code dependencies (tarballs) on a local file-system
* Use Spack to build container images with Docker

## Installation

Install `spack`:

```bash
# install dependencies
sudo apt install -y git curl build-essential gfortran
# get the source code
git clone https://github.com/spack/spack.git
# add Spack to your environment
export SPACK_ROOT=$PWD/spack
# add spack tp PATH, load command-line completion (bash/zsh)
source $SPACK_ROOT/share/spack/setup-env.sh
```

Make sure a host compiler is available:

```bash
spack compilers                       # see which compilers spack has found
spack compiler find [$path]           # search for compilers(, in a specified path)
spack config edit compilers           # manual configuration
spack arch                            # host architecture
spack arch --known-targets            # supported architectures
```

Install core Spack utilities:

```bash
spack bootstrap
```

## Configuration

Configuration file in priority order:

```bash
~/.spack                              # user
$SPACK_ROOT/etc/spack/                # site
/etc/spack/                           # system
$SPACK_ROOT/etc/spack/defaults/       # defaults
```

Custom location with option `--config-scope`

## Usage

Available and installed packages:

```bash
spack list $name                      # available packages
spack info $name                      # package description
spack versions $name                  # available package versions
spack find                            # installed packages
spack find --paths                    # package installation path
spack find -lf                        # show hash, and compiler
spack find -ldf                       # include dependencies
```

Install and uninstall [packages](https://spack.readthedocs.io/en/latest/package_list.html):

```bash
spack install $name                   # install package (prefered versions)
spack install $name@$version [$spec]  # install specific version
spack uninstall $name                 # uninstall package..
spack uninstall --dependents ...      # ..including every packages that depend on
spack gc                              # remove build time dependencies
```

Optional **version specifier** →  [Specs & Dependencies](https://spack.readthedocs.io/en/latest/basic_usage.html#specs-dependencies)

```bash
spack install mpileaks                             # unconstrained
spack install mpileaks@3.3                         # @ custom version
spack install mpileaks@3.3 %gcc@4.7.3              #  % custom compiler
spack install mpileaks@3.3 %gcc@4.7.3 +threads     # +/- build option
spack install mpileaks@3.3 cppflags="-O3 –g3"      # set compiler flags
spack install mpileaks@3.3 target=skylake          # set target microarchitecture
spack install mpileaks@3.3 ^mpich@3.2 %gcc@4.9.3   # ^ dependency information
```

* Each expression is a spec for a particular configuration
* Spec syntax is recursive

Adding packages to the user environment

```bash
spack load $name                      # add paackage to environment
spack unload $name                    # remove package from environment
```

## Environments

> An environment is a virtualized spack instance that you can use for a specific
> purpose.

→ [Spack Tutorial - Environments](https://spack-tutorial.readthedocs.io/en/latest/tutorial_environments.html)

```bash
spack env create $name                    # create a new environment
spack env list                            # available environments
spack env status                          # show current environment
spack env activate $name                  # activate environment
spack env deactivate                      # leave environment
```

## Modules

→ [Spack Tutorial - Module Files](https://spack-tutorial.readthedocs.io/en/latest/tutorial_modules.html)

```bash
# add support for hierarchical and non-hierarchical module file layouts
spack install lmod
# generate the environment load file
source $(spack location -i lmod)/lmod/lmod/init/bash
# load environment modules
source $SPACK_ROOT/share/spack/setup-env.sh
# list available modules
module avail
```


# References


[01] Spack – A Package Manager for HPC, Gamblin, Stanford HPC Conference 2019  
<https://insidehpc.com/2019/03/spack-a-package-manager-for-hpc/>

[02] Spack and the U.S. Exascale Computing Project, Gamblin, HPCKP'19  
<https://www.youtube.com/watch?v=DRuyPDdNr0M>

[03] Spack's new Concretizer, Gamblin, FOSDEM 2020  
<https://fosdem.org/2020/schedule/event/dependency_solving_not_just_sat/>

[04] The Spack Package Manager: Bringing Order to HPC Software Chaos, Gamblin  
<https://tgamblin.github.io/pubs/spack-sc15.pdf>

[05] SPACK: The Daily Job of a User (and a Packager), Culpo, 2017  
<https://www.youtube.com/watch?v=2exsn9OHsMY>

[06] Binary packaging for HPC with Spack, Gamblin, FOSDEM 2018  
<https://archive.fosdem.org/2018/schedule/event/llnl_spack/>
