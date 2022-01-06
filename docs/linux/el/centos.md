# CentOS project

Git repositories for all RPM packages are available on the CentOS Git server [3].

List of CentOS related package repositories:

Name                  | Description
----------------------|------------------------
EPEL                  | https://fedoraproject.org/wiki/EPEL
ELRepo                | http://elrepo.org
Software Collections  | https://www.softwarecollections.org
RPM Fusion            | https://rpmfusion.org
OpenHPC               | https://github.com/openhpc/ohpc

## CentOS Stream

The (rolling release) [CentOS Stream](https://www.centos.org/) becomes the
identity of CentOS project. A _continuously delivered distro that tracks just
ahead of Red Hat Enterprise Linux (RHEL) development, positioned as a midstream
between Fedora Linux and RHEL._ 

Timeline for CentOS Linux and CentOS Stream sponsorship by Red Hat [14]:

* Updates for the CentOS Linux 7 distribution continue as before until June 30, 2024.
* Updates for the CentOS Linux 8 distribution continue until December 31, 2021.
* There will not be a CentOS Linux 9.
* Updates for the CentOS Stream 8 distribution continue through the full RHEL support phase.
* CentOS Stream 9 will launch in Q4 2021 as part of the RHEL 9 development process.

[Why was CentOS Stream created?](https://www.redhat.com/en/blog/faq-centos-stream-updates#Q4)

>>>
* Shortening the feedback loop for ecosystem developers - including OEMs, ISVs,
  and Application Developers - to contribute their changes. By working in
  CentOS Stream between Fedora and RHEL, ecosystem developers will be working
  on a **rolling preview of what’s coming in the next RHEL release**. This will
  allow them to make changes much faster than they can today.
* Developing in the open. Currently, much of RHEL development is done with many
  of our ecosystem partners working behind Red Hat’s firewall. CentOS Stream
  enables Red Hat and the larger community to do **as much transparent
  development as possible** in what will become the next release of RHEL.
* Enabling access to innovation faster. Beginning with the release of RHEL 8,
  Red Hat committed to releasing major versions of RHEL every three years and
  minor releases every six months. Adhering to this faster and more predictable
  cadence means that we need a midstream development environment that anyone
  can contribute to. That environment is CentOS Stream.
* Providing a **clear method for the broader community to contribute to RHEL
  releases**. When Fedora was RHEL's only upstream project, most developers
  were limited to contributing only to the next major release of RHEL. With
  CentOS Stream, all developers will be able to contribute new features and bug
  fixes into minor RHEL releases as well.
>>>

Following talks are recommend for a broader overview:

CentOS Stream: What you need to know (2021/02 FOSDEM)  
<https://www.youtube.com/watch?v=oktwEpjO38M&list=PLuRtbOXpVDjC7RkMYSy-gk47s5vZyKPbt&index=2>

Everyone to contribute to RHEL now! (2021/02)  
<https://www.youtube.com/watch?v=E7St7gsafiA&list=PLuRtbOXpVDjC7RkMYSy-gk47s5vZyKPbt&index=3>

Neal Gompa (member of the OpenSUSE board) [15] described... 

> ...the move to Stream is giving the community a more direct mechanism than Fedora to interoperate with this. CentOS has gone from being the operating system for the community enterprise to now being the **developers' interface to the enterprise operating system**.

### AppStream

Content is distributed through the two main repositories:

Repository | Description
-----------|------------------------
BaseOS     | Core RPM packages that provide OS functionality
AppStream  | User space RPM packages and RPM modules

Both BaseOS and AppStream content sets are required for a basic installation.

AppStream (Application Stream) allows to install **multiple versions of a user
space component**.

* Each AppStream component has a given life cycle
* Packaged as RPM modules or individual RPM packages

**Modules are collections of packages** representing a logical unit.

## CentOS

Original CentOS it supported until EOL of CentOS 7:

Major release | EOL
--------------|----------------------
CentOS 6      | 2020/11
CentOS 7      | 2024/06
CentOS 8      | 2021/12

* Built from publicly available open-source source code provided by Red Hat
* Aims to be functionally compatible with Red Hat Enterprise Linux
* Support EOL (end of live) according to the CentOS FAQ [5]:
* Cf. [Wikipedia, CentOS Releases](https://en.wikipedia.org/wiki/CentOS#CentOS_releases)

Upgrade between major releases not supported nor recommended by CentOS [6].

Expected delays after upstream publishes updates, and new releases:

Update        | Time
--------------|--------
Package       | <72 hours
Point release | 4-8 weeks
Major release | month

Version conventions [7]:

* Major branch, i.e. CentOS-7
* Minor (point in time) versions of major branch
  - Date code included in minor versions, i.e. CentOS-7 (1406) means June 2014
  - Updates only for the latest (minor) version of each major branch
  - Minor version are snapshots of previous updates rolled into a new repo

Setting up yum repositories on CentOS Linux you should only use the single digit 
for the active branch [5], i.e.:

<http://mirror.centos.org/centos/7/>

Repo      | Description
----------|------------------------
base      | Packages that form CentOS (minor) point releases
updates   | Security, bugfix or enhancement updates, issued between the regular update sets for point releases
addons    | Packages not provided by upstream, used to build the CentOS distribution


## References

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

[13] CentOS Stream Fiasco  
<https://itsfoss.com/centos-stream-fiasco>

[14] FAQ: CentOS Stream Updates  
<https://www.redhat.com/en/blog/faq-centos-stream-updates>

[15] Interview with Greg Kurtzer, The Register (2021/07/09)  
<https://www.theregister.com/2021/07/09/centos_stream_greg_kurtzer/>
