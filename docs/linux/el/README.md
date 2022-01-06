# Enterprise Linux

[Red Hat](https://www.redhat.com) compatible Linux distributions based on
the [RPM package manager](rpm.md).

List of RPM related package repositories:

Name                  | Description
----------------------|------------------------
EPEL                  | https://fedoraproject.org/wiki/EPEL
ELRepo                | http://elrepo.org
Software Collections  | https://www.softwarecollections.org
RPM Fusion            | https://rpmfusion.org
OpenHPC               | https://github.com/openhpc/ohpc

The **[CentOS Project](centos.md) provides an upstream distribution the RHEL**
with CentOS Stream. 

Fedora [CoreOS](coreos.md) is an RPM based distribution within the ecosystem
build to host containerized workloads on an immutable infrastructure.

The High-Energy Physics (HEP) community is using [CERN "Enterprise Linux"](cern.md).

## Downstream RHEL

**[AlmaLinux](almalinux.md) and [RockyLinux](rockylinux.md)** are successors to
original CentOS...enterprise-grade, production-ready Linux in the form of a
(100% binary compatible) downstream release of RHEL. The AlmaLinux project
provides an [comparison over the available Enterprise Linux][01] (EL)
distributions.

[01]: https://wiki.almalinux.org/Comparison.html

> CloudLinux commits an annual $1 million endowment and leads the development &
> maintenance of AlmaLinux. CloudLinux has more than a decade of experience
> with RHEL fork, as owner of the CloudLinux OS. AlmaLinux’s prominent partners
> include AWS, Equinix, cPanel and Plesk, essentially leaders of the hosting
> community...Gregory Kurtzer, the original founder of CentOS heads the
> development of Rocky Linux. Rocky Linux is community-driven and does not have
> commercial developers the way AlmaLinux does. The prominent sponsors of Rocky
> Linux include AWS and Google Cloud [crar]

Governing organizations:

* The **AlmaLinux Foundation** (Delaware Reg. 5561017) was created as a
  **501(c)(6) non-profit** (the same as the Linux Foundation) in order to put
  OWNERSHIP of the OS, the Intellectual Property and the direction of the
  project into the hands of the community. By joining as a member (100% free
  for community members) you have the right and the ability to vote on board
  members and the direction of the project and other decisions as they will
  come up in the future. [alof]
* The **Rocky Enterprise Software Foundation** (RESF) is a **Public Benefit
  Corporation** (PBC) formed in Delaware (file number 4429978). The RESF was
  founded and is owned by Gregory Kurtzer and is backed by an advisory board of
  trusted individuals and team leads from the Rocky Linux community. [resf]

> The chief difference between a non-profit corporation and a benefit
> corporation—sometimes called a B Corporation—is the ownership factor. **There
> are no owners or shareholders in a non-profit company. A benefit corporation,
> however, does have shareholders who own the company**...A traditional
> non-profit (or not-for-profit) company aims to serve a public benefit without
> making a profit...If a non-profit company decides to stop doing business and
> dissolve, it must distribute its assets among other non-profits...The
> shareholders of a benefit corporation actually own the company as well as its
> assets...If a benefit corporation decides to stop doing business and
> dissolves, the shareholders receive the proceeds of the sales of assets,
> after liabilities are paid. [npbp]

Why is Rocky Linux a PBC?

* _Kurtzer talked at length about the governance of Rocky Linux and the fact
  that he created a B (public benefit) Corporation rather than a 501(c)
  (non-profit) for the Rocky Enterprise Software Foundation,..."What I've
  learned along the way is that **a 501(c) anything is not a guarantee of
  integrity and honesty and good behavior**... and I said to myself, if I'm
  going to do this, I don't want to put myself in that environment again."_
  [trgg]
* Based on the experience from the CentOS project G. Kurtzer decided against a
  non-profit [gkfc]: _The process was started by Greg to create a 501c3
  non-profit entity - the Caos Foundation - which would host the CentOS
  Project. There was a framework being created to cover governance, funding,
  and organizing volunteer effort. Unfortunately, the individual who came up
  with the name ‘CentOS’ also owned the domain name, and declined to release it
  to the foundation as promised..._ Multiple accounts of the original struggle
  on the CentOS project in the middle of 2009 are documented [rhpd] [wucp]:
  _...developers accuse project co-founder Lance Davis of putting the entire
  project at risk by disappearing from everyday involvement without ceding
  control to others._
* From the Rocky Linux Community Update - June 2021 [rlcu]: RESF _is a Public
  Benefit Corporation (PBC) formed in Delaware (file number 4429978), backed by
  a **board of advisors with access control policies that utilize the principle
  of least privilege and separation of duty to ensure that no action can be
  taken unilaterally** (not even by the legal owner, Gregory Kurtzer). For more
  information, see our [Organizational
  Structure](https://rockylinux.org/organizational-structure/)._
* From the RESF Community Charter [rlcc]: _The Rocky Enterprise Software
  Foundation is responsible and accountable only to the community that consumes
  its projects. RESF shall be structured and governed in a way that ensures
  that no single entity, organization, corporation, association, etc. will be
  permitted to have a controlling influence over the RESF or its
  projects....the work generated by the RESF and its community will be released
  under an existing **OSI permissive open source license (non-copyleft)**._


# References

[crar] CentOS Replacement: AlmaLinux vs Rocky Linux  
<https://www.expertvm.com/centos-replacement-almalinux-rocky-linux/>

[alof] The AlmaLinux OS Foundation  
<https://wiki.almalinux.org/Transparency.html>  
<https://almalinux.org/p/foundation-bylaws/>
<https://almalinux.org/blog/what-almalinux-foundation-membership-means-for-you/>  
<https://www.businesswire.com/news/home/20211005005953/en/AlmaLinux-OS-Foundation-Membership-Opens-to-the-Public>

[resf] Rocky Enterprise Software Foundation (RESF)  
<https://rockylinux.org/organizational-structure>

[npbp] Non-Profit Corporation vs Public Benefit Corporation  
<https://www.delawareinc.com/blog/non-profit-corporation-vs-public-benefit-corporation/>

[trgg] Interview with Greg Kurtzer, The Register (2021/07/09)  
<https://www.theregister.com/2021/07/09/centos_stream_greg_kurtzer/>

[gkfc] Greg Kurtzer: Founder of the CentOS project  
<https://blog.centos.org/2019/03/greg-kurtzer-centos-founder/>

[rhpd] Red Hat Enterprise clone poised to 'die'  (2009/07/30)  
<https://www.theregister.com/2009/07/30/centos_open_letter/>

[wucp] What is up with the CentOS project (2009/07/30)  
<https://misterd77.blogspot.com/2009/07/what-is-up-with-centos-project.html>  
<https://lists.centos.org/pipermail/centos/2009-July/079767.html>

[rlcu] Rocky Linux Community Update - June 2021  
<https://forums.rockylinux.org/t/community-update-june-2021/3260>

[rlcc] Rocky Enterprise Software Foundation - Community Charter  
<https://forums.rockylinux.org/t/community-charter>
