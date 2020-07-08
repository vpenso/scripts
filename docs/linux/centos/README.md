# CentOS Linux

CentOS (Community Enterprise Operating System):

* Built from publicly available open-source source code provided by Red Hat
* Aims to be **functionally compatible with Red Hat Enterprise Linux**

Expected delays after upstream publishes updates, and new releases:

Update        | Time
--------------|--------
Package       | <72 hours
Point release | 4-8 weeks
Major release | month

Cf. [Wikipedia, CentOS Releases](https://en.wikipedia.org/wiki/CentOS#CentOS_releases)

Git repositories for all RPM packages are available on the CentOS Git server [3].

Support EOL (end of live) according to the CentOS FAQ [5]:

Major release | EOL
--------------|----------------------
CentOS 6      | 2020/11
CentOS 7      | 2024/06
CentOS 8      | 2029/05

**Upgrade between major releases not supported nor recommended** by CentOS [6].

Version conventions [7]:

* **Major** branch, i.e. CentOS-7
* **Minor** (point in time) versions of major branch
  - Date code included in minor versions, i.e. CentOS-7 (1406) means June 2014
  - **Updates only for the latest (minor) version of each major branch**
  - Minor version are snapshots of previous updates rolled into a new repo

Setting up yum repositories on CentOS Linux you should only use the single digit 
for the active branch [5], i.e.:

<http://mirror.centos.org/centos/7/>

**CentOS Stream** is a **rolling-release** Linux distribution:

* Midstream between the upstream development in Fedora Linux..
* ..downstream development for Red Hat Enterprise Linux (RHEL)

Released alongside the traditional CentOS Linux 8, which is a downstream rebuild
of the current RHEL release.

## Repositories

Name      | Description
----------|------------------------
base      | Packages that form CentOS (minor) point releases
updates   | Security, bugfix or enhancement updates, issued between the regular update sets for point releases
addons    | Packages not provided by upstream, used to build the CentOS distribution

List of CentOS related package repositories:

Name                  | Description
----------------------|------------------------
EPEL                  | https://fedoraproject.org/wiki/EPEL
ELRepo                | http://elrepo.org
Software Collections  | https://www.softwarecollections.org
RPM Fusion            | https://rpmfusion.org
OpenHPC               | https://github.com/openhpc/ohpc

# References

### CentOS

[1] The CentOS Rebuild and Release Process  
<https://wiki.centos.org/FAQ/General/RebuildReleaseProcess>

[2] Official CentOS Linux Package Mirror  
<http://mirror.centos.org/centos/>  
<https://mirror-status.centos.org/>

[3] CentOS Git server  
<https://git.centos.org/>

[4] CentOS - Additional Package Repositories  
<https://wiki.centos.org/AdditionalResources/Repositories>

[5] CentOS General FAQ  
<https://wiki.centos.org/FAQ/General>

[6] CentOS Migration Guide  
<https://wiki.centos.org/HowTos/MigrationGuide>

[7] CentOS Versions  
<https://wiki.centos.org/Download>

[8] CentOS Bug Tracker  
<https://bugs.centos.org>

[9] CentOS Mailing Lists  
<https://wiki.centos.org/GettingHelp/ListInfo>

[10] CentOS Build Server  
<https://koji.mbox.centos.org>

[11] CentOS Project, Youtube  
<https://www.youtube.com/user/TheCentOSProject>

[12] CentOS Stream  
<https://wiki.centos.org/Manuals/ReleaseNotes/CentOSStream>  
<https://wiki.centos.org/FAQ/CentOSStream>
