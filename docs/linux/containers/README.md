# Linux Containers

Major components used in Linux containers:

* Kernel **Namespaces**
  - Isolation layer to implement different user-spaces views for processes
  - Partitions process, users, network stacks, etc into separate spaces to provide processes a unique view onto the system
  - Kernel no designed with namespaces in mind, ongoing development to make more sub-systems namespace aware 
* **Control Groups** (cgroups), more powerful `ulimit()`/`rlimit()`
  - Mechanism to apply hardware resource limits and access control to processes
  - Tree-based hierarchical, inheritable and optionally nested
  - Configured via a special cgroup virtual file-system
* Root **Capabilities**
  - Enforce namespaces (in privileged containers) by reducing the power of root
  - Capability privilege bitmap per process used by the kernel to partition root access
  - Restricts root-level operations to follow the principle of least privilege
* System call `pivot_root` - Change the root file-system for a new container
* Tools to enforce security for containers
  - `seccomp-bpf` - Berkeley Packet Filter system call filtering
  - `prctl` (`PRE_SET_NO_NEW_PRIVS`) kernel-level flags to prevent system escalation
  - SELinux - Labeling system for file-systems and applications
  - AppAmor - Profile-based MAC (Manditory Acess Control) system for limiting applications abilities

## Container Runtime

Low level component used by a container engine (i.e. Docker):

* Communicates with the kernel to start containerized process
* Uses metadata to configure various namespaces (i.e. mount, cgroup) and the container security envelope (i.e. App)
* [Open Container Initiative (OCI) Runtime Specification][ocispec]

[ocispec]: https://github.com/opencontainers/runtime-spec

Container run-time systems:

* [runc][runc]
* [ccon][ccon]
* [charliecloud][charlie]
* [nsjail][nsjail]
* [firejail][firejail]
* [bubblewrap][bubble]
* [podman](https://github.com/containers/libpod)
* [systemd-nspawn][nspawn]
* [singularity][sing]

[runc]: https://github.com/opencontainers/runc
[ccon]: https://github.com/wking/ccon
[nsjail]: https://github.com/google/nsjail
[firejail]: https://github.com/netblue30/firejail
[bubble]: https://github.com/projectatomic/bubblewrap
[nspawn]: https://github.com/systemd/systemd/blob/master/src/nspawn/nspawn.c
[sing]: https://github.com/sylabs/singularity
[charlie]: https://github.com/hpc/charliecloud

## Container Build

Tools to build container images:

* [buildah](https://github.com/containers/buildah)
* [docker](https://github.com/docker)
* [kaniko](https://github.com/GoogleContainerTools/kaniko)
* [nixery](https://github.com/google/nixery)
