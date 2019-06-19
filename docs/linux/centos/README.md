# CentOS Linux

Built from publicly available open-source source code provided by Red Hat

Aims to be **functionally compatible with Red Hat Enterprise Linux**

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
CentOS 6      | November 30, 2020
CentOS 7      | June 30, 2024
CentOS 8      | Cf. [CentOS 8 Rough Status Page](https://wiki.centos.org/About/Building_8)

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



## Package Errata

Package errata are listings from the package manager (upstream) with 
updates for when CVE’s and vulnerabilities are found.

### Red Hat

Red Hat **Security Advisories** (RHSA) inform customers about security flaws for all Red Hat products:

<https://access.redhat.com/security/security-updates/#/security-advisories>

RHSA are continuously published to a **announcement mailing list**:

<https://www.redhat.com/archives/rhsa-announce/>

Security issues receiving special attention by Red Hat are documented by **Vulnerability Responses**:

<https://access.redhat.com/security/vulnerabilities>

Data related to security is programmatically available with the Red Hat [Security Data API][rhsda]. Red Hat customers may have access to [Extended Update Support][rheus] (EUS) which provides update channels to stay with a minor version of the base OS. The support time frames are explained at Red Hat [Enterprise Linux Life Cycle][rhellc].

Information is kept in the `UPDATEINFO.XML` file for each repository upstream.

* Use the yum-plugin-security plugin, to list all vulnerable packages `yum list-sec cves`
* Update any package that has listed errata with `yum update --security`

### CentOS

CentOS Security Advisories (CESA) are continuously published to the **announcement mailing list**:

<https://lists.centos.org/pipermail/centos-announce/>

CESA follows RHSA on its respective mailing-lists closely keeping the same naming convention.

**_Packages distributed by the CentOS repositories do not provide security errata information!_**

CentOS does not have official errata: the CentOS upstream repos do not have an `UPDATEINFO.XML`

**CentOS Errata for Spacewalk** (CEFS) imports security errata information 
from the CentOS announce mailing list and provides it to a 
[Spacewalk](http://spacewalk.redhat.com/) server:

<http://cefs.steve-meier.de/>

Following scripts are bases on the security [errata XML file][cefsxml] published by CEFS.

1. The script [generate_updateinfo][cefsgu] creates an `updateinfo.xml` file to be published on a CentOS package repository mirror.
2. The [Centos-Package-Cron][cefscpc] reports advisories by mail related to packages installed on a specific node.

[rhsda]: https://access.redhat.com/documentation/en-us/red_hat_security_data_api/0.1/html-single/red_hat_security_data_api/
[rheus]: https://lists.centos.org/pipermail/centos-announce/
[rhellc]: https://access.redhat.com/support/policy/updates/errata/
[cefsxml]: http://cefs.steve-meier.de/errata.latest.xml
[cefsgu]: https://github.com/vmfarms/generate_updateinfo
[cefscpc]: https://github.com/wied03/centos-package-cron

### CERN CentOS

[Cern CentOS][cernc] is a customized distribution that is built on top of the CentOS Core

* Fully compatible with CentOS Core therefore with the [ Red Hat ] Enterprise Linux
* It includes [security, enhancement and bugfix errata][ccera]

Available for mirroring at <http://linuxsoft.cern.ch/>

[cernc]: https://linux.web.cern.ch/linux/centos.shtml
[ccera]: https://linux.web.cern.ch/linux/updates/updates-cc7.shtml


# References

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


