# Spack

> Spack is a package management tool designed to support multiple versions and
> configurations of software on a wide variety of platforms and environments. It
> was designed for large supercomputing centers, where many users and
> application teams share common installations of software on clusters with
> exotic architectures, using libraries that do not have a standard ABI. Spack
> is non-destructive: installing a new version does not break existing
> installations, so many configurations can coexist on the same system.

<https://spack.io>  
<https://spack.readthedocs.io>  
<https://github.com/spack/spack>  

* Install software either from source or from a binary cache

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
# install core spack utilities
spack bootstrap
```

Make sure a host compilers 

```bash
spack compilers                       # see which compilers spack has found
spack compiler find [$path]           # search for compilers(, in a specified path)
spack config edit compilers           # manual configuration
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

Install and uninstall:

```bash
spack install $name                   # install package (prefered versions)
spack install $name@$version [$spec]  # install specific version
spack uninstall $name                 # uninstall package..
spack uninstall --dependents ...      # ..including every packages that depend on
spack gc                              # remove build time dependencies
```

Optional **version specifier**:

<https://spack.readthedocs.io/en/latest/basic_usage.html#specs-dependencies>

* Package name identifier (`$name` above)
* `@` Optional version specifier (@1.2:1.4)
* `%` Optional compiler specifier, with an optional compiler version (`gcc` or
  `gcc@4.7.3`)
* `+` or `-` or `~` Optional variant specifiers (+debug, -qt, or ~qt) for
  boolean variants
* `name=<value>` Optional variant specifiers that are not restricted to boolean
  variants
* `name=<value>` Optional compiler flag specifiers. Valid flag names are
  `cflags`, `cxxflags`, `fflags`, `cppflags`, `ldflags`, and `ldlibs`.
* `target=<value> os=<value>` Optional architecture specifier (`target=haswell
  os=CNL10`)
* `^` Dependency specs (`^callpath@1.1`)

## Modules

```bash
spack install lmod
```


# References


[01] Spack – A Package Manager for HPC, Todd Gamblin, Stanford HPC Conference 2019  
<https://insidehpc.com/2019/03/spack-a-package-manager-for-hpc/>

[02] Spack and the U.S. Exascale Computing Project, Todd Gamblin, HPCKP'19  
<https://www.youtube.com/watch?v=DRuyPDdNr0M>

[03] Spack's new Concretizer, Tood Gamblin, FOSDEM 20  
<https://fosdem.org/2020/schedule/event/dependency_solving_not_just_sat/>
