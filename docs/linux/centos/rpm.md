# RPM Packages

Packages use following name specification:

    name
    name.arch
    name-[epoch:]version
    name-[epoch:]version-release
    name-[epoch:]version-release.arch

### Usage

```bash
rpm -e --nodeps $package           # remove a package without its dependencies
```

## References

[rpg] RPM Packaging Guide  
https://rpm-packaging-guide.github.io/
