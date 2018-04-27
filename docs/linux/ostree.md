
### ostree

OSTree is a tool to manage bootable, immutable, versioned file-system trees (filetrees).

* Git-like repository that records the changes in a filetree
* Client/server architecture to replicate filetrees (to subscribers)
* Filetree replication protocol:
  - Efficient (transfers only deltas over the network)
  - Atomic (deployments are completely decoupled)
  - Predictable, reproducible (rollback, no state drift)

<http://ostree.readthedocs.io/>  
<https://github.com/ostreedev/ostree>

```bash
/etc/ostree/remotes.d     # 
/ostree                   # top-level directory
/ostree/repo              # repository
/ostree/deploy            # deployments
```

### rpm-ostree

Filetree replication system that is also (RPM) package-aware:

<https://rpm-ostree.readthedocs.io>

On the client side:

```bash
rpm-ostree status            # show deployments
rpm-ostree upgrade           # system upgrade (create new deployments & switch on boot)
rpm-ostree rollback          # back to previous deployment
rpm-ostree install <pkg>     # layer additional package
rpm-ostree uninstall <pkg>   # remove packages
```
