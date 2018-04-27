
### ostree

(lib)ostree is a tool to manage bootable, immutable, versioned file-system trees:

* Git-like repository that records the changes in a filetree
* Client/server architecture to replicate filetrees (to subscribers)
* Deduplicating object store in `/ostree/repo` (hardlinks)

<http://ostree.readthedocs.io/>  
<https://github.com/ostreedev/ostree>

```bash
/etc/ostree/remotes.d     # 
/ostree                   # top-level directory
/ostree/repo              # repository
/ostree/deploy            # deployments
```

### rpm-ostree

Uses ostree to atomically replicate a base OS. Supports
"package layering" (additional RPMs layered on top of the base image).

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
