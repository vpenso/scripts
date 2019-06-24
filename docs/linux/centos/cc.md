# Cern CentOS 7

Cern CentOS [01] is a customized distribution that is built on top of the CentOS

* Fully compatible with CentOS therefore with the [Red Hat] Enterprise Linux
* Includes **security, enhancement and bugfix errata** [03]

Available for mirroring at <http://linuxsoft.cern.ch/>

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

Install security updates [03]:

```bash
# check for security related package updates
>>> yum --security check-updates
...
25 package(s) needed for security, out of 73 available
...
# install all security updates
>>> yum --security update
# enable automatic system updates [02]
>>> systemctl enable yum-autoupdate

```

# References

[01] CERN CentOS  
<https://linux.web.cern.ch/linux/centos.shtml>

[02] Cern CentOS - Software Management  
<http://linux.web.cern.ch/linux/scientific5/docs/softwaremgmt.shtml#sysconfenable>

[03] System Updates for CERN CentOS 7  
<http://linux.web.cern.ch/linux/updates/updates-cc7.shtml>
