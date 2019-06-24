
# EPEL

EPEL (Extra Packages for Enterprise Linux) [00] from a Fedora project SIG:

* Add-on packages for Red Hat Enterprise Linux
* Follows the Fedora Packaging Guidelines [01]
* **Updates as long as the corresponding RHEL release is supported** [02]

```bash
# install yum configuration for EPEL repositories 
yum install -y epel-release && yum makecache
# configuration files for yum
/etc/yum.repos.d/epel*.repo
# show the configuration
yum repoinfo epel
# list all packages available in EPEL
yum repo-pkgs epel list
```

# References

[00] Fedora EPEL Packages  
<https://fedoraproject.org/wiki/EPEL>

[01] Fedora Packaging Guidelines  
<https://docs.fedoraproject.org/en-US/packaging-guidelines/>

[02] Fedora EPEL FAQ  
<https://fedoraproject.org/wiki/EPEL/FAQ>

[03] Fedora EPEL Mirrors  
<https://dl.fedoraproject.org/pub/epel/>  
<https://admin.fedoraproject.org/mirrormanager/mirrors/EPEL>


