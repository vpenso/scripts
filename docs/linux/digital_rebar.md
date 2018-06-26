# Digital Rebar

[Digital Rebar Provision][1] (DRP) bare-metal automation:

* Compostable on-premises hardware provisioning (Bare-Metal as a Service)
* REST API driven service (self-contained single Golang binary) utilizes:
  - DHCP (67/udp), PXE, address managment, next boot service
  - TFTP (69/udp), HTTP (8091/tcp) for PXE boot images, dynamic templates, static files
  - HTTPS (8092/tcp) service API, web user-interface
* Handles boot requests using native OS installers (i.e. Kickstart)
* Supports immutable provisioning/deployments (destroy-create pattern)
  - Focus on repeatabilifty
  - Avoids configuration-drift
  - Security hardening

**Staged workflow** (operation & control), cloud-like provisioning:

Stage            | Boot | Workflow
-----------------|------|---------------------------------
discover         | live | discovery & inventory
install          | live | RAID/BIOS updates, OS installer or image deployment, post-provision
boot             | disk | control tasks & plugins with DR agent (optional) 
recover          | live | clean-up & recover

* Multi-boot stages composed of environment specific, reusable tasks (compostable control)
* Some stages/tasks (e.g. RAID/BIOS management) provided by [RackN][3] (commercial plugins)

**Post-provisioning** with DR agent

* Live-boot into RAM (custom distro Sledgehammer) 
* Pulls & runs post-provision scripts (without SSH) 
* Can stream (pre-backed) OS image to local storage
* Hands off to configuration management, orchestration system (Chef, Puppet, SaltStaack, etc.)
* Integrates with asset management, monitoring, reporting


[1]: http://rebar.digital "DRP home page"
[2]: https://github.com/digitalrebar/provision "DRP source code on GitHub"
[3]: https://www.rackn.com
[4]: https://www.youtube.com/channel/UCr3bBtP-pMsDQ5c0IDjt_LQ "RackN youtube channel"
[5]: http://provision.readthedocs.io/en/stable/README.html "DRP documentation"
