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
