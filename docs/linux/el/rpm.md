# RPM Packages

Packages use following name specification:

    name
    name.arch
    name-[epoch:]version
    name-[epoch:]version-release
    name-[epoch:]version-release.arch

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

[rpg] RPM Packaging Guide  
https://rpm-packaging-guide.github.io/
