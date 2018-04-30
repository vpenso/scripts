
## ostree

(lib)ostree is an upgrade system performing atomic upgrades of 
complete (bootable) filesystem trees (aka the OS root directory):

<http://ostree.readthedocs.io/>  
<https://github.com/ostreedev/ostree>

* **Content Addressable Storage** (CAS) optimized for storing trees 
  of binary files (similar to Git operating on trees of text files)
* Client/server architecture to **replicate read-only OS trees via 
  HTTP** (to subscribers)
* **Stateless** deployments, nodes can boot from an (effectively) 
  read-only disk
* Persistent writable directories that are preserved across 
  upgrades are `/etc` and `/var`
* Read-only content is kept in `/usr` (bind mount to prevent 
  inadvertent corruption)
* Designed to **parallel-install** multiple versions of multiple 
  independent operating systems

```bash
/etc/ostree/remotes.d     # remote repo. locations
/ostree                   # top-level directory
/ostree/repo              # repository (deduplicated)
/ostree/deploy            # deployments
```
```bash
# list all configured repos.
tail -n+1 /etc/ostree/remotes.d/*.conf
ostree admin status       # list deployments
```

### Deployments

Physically located at a path of the form:

```
/ostree/deploy/$stateroot/deploy/$checksum
```

* Boot directly into exactly one deployment at a time
  - Kernel in `/usr/lib/modules/$kver/vmlinuz`
  - Initramfs in `/usr/lib/modules/$kver/initramfs.img`
* Default configuration `/usr/etc` (3-way merge with `/etc`)
* Bootloader in `/boot/loader/entries/ostree*.conf`
* Atomic transitions between lists of bootable deployments
  - Running systems never altered by an upgrade
  - Swapping between boot configurations with `/ostree/boot.[0|1]`

## rpm-ostree

Uses libostree and supports "package layering" (additional RPMs layered 
on top of a deployment).

<https://rpm-ostree.readthedocs.io>  
<https://github.com/projectatomic/rpm-ostree>

On the client side:

```bash
rpm-ostree status            # show deployments
rpm-ostree upgrade           # system upgrade (create new deployments & switch on boot)
rpm-ostree rollback          # back to previous deployment
rpm-ostree install <pkg>     # layer additional package
rpm-ostree uninstall <pkg>   # remove packages
```

Information on the currently booted deployment:

```bash
# diff active system with the booted deployment
ostree admin config-diff
# current booted deplument ref
ref=$(rpm-ostree status -b | grep -i commit | cut -d: -f2) && echo $ref
# list packages installed in the currently booted deployment
rpm-ostree db list $ref
```

Inspect the history:

```bash
# remote for the current depl0yment
remote=$(rpm-ostree status -b | grep ostree | cut -d/ -f3-) && echo $remote
# pulling the commit metadata and the RPM database from each of the commits
ostree pull --commit-metadata-only --depth=-1 $remote
# show commit history
ostree log $ref
# compare commits (Git style)
rpm-ostree db diff $ref $ref^

```

Ref.:

* Fedora [Project Atomic](http://www.projectatomic.io/)
* CentOS SIG [Atomic](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel)


