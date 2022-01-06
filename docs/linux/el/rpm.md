# RPM Package Manager

The name RPM refers to `.rpm` file format and the package manager program itself [rpmp].

* Package can contain an arbitrary set of files.
* Binary RPMs containing the compiled version of some software
* Source RPMs `.src.rpm` containing the source code used to build a binary package

RPMs are often collected centrally in one or more RPM repository. Several
front-ends to RPM ease the process of obtaining and installing RPMs from
repositories such as [DNF](dnf.md) and its predecessor [Yum][yum.md].

Packages use following name specification:

```
name
name.arch
name-[epoch:]version
name-[epoch:]version-release
name-[epoch:]version-release.arch
```

## Usage

```bash
rpm -e --nodeps $package           # remove a package without its dependencies
rpm --rebuilddb                    # Error: rpmdb open failed
```

## Build Packages

Install development tools

```bash
sudo dnf install -y @development rpmdevtools mock
```

```bash
# create and populate the spec file
rpmdev-newspec ${name}.spec
```

## References

[rpmp] RPM Package Manager Project Page  
<https://rpm.org>

[rpgu] RPM Packaging Guide  
<https://rpm-packaging-guide.github.io>
