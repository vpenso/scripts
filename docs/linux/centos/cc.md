# Cern CentOS 7

List or package repositories used by default:

```bash
>>> yum repolist enabled --verbose | grep baseurl | cut -d: -f2- | sort
 http://linuxsoft.cern.ch/cern/centos/7/cern/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/extras/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/updates/x86_64/
 http://linuxsoft.cern.ch/elrepo/elrepo/el7/x86_64/
 http://linuxsoft.cern.ch/epel/7/x86_64/
```

## Security Updates

Install security updates [2]:

```bash
# check for security related package updates
>>> yum --security check-updates
...
25 package(s) needed for security, out of 73 available
...
# install all security updates
>>> yum --security update
# enable automatic system updates [1]
>>> systemctl enable yum-autoupdate

```

# References

[1] Cern CentOS - Software Management  
<http://linux.web.cern.ch/linux/scientific5/docs/softwaremgmt.shtml#sysconfenable>

[2] System Updates for CERN CentOS 7  
<http://linux.web.cern.ch/linux/updates/updates-cc7.shtml>
