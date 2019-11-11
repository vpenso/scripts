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


### Namespaces

Namespaces wrap a particular global resource in an abstraction:

* Processes within a namespace have a dedicated isolated instance of the global resource
* Namespaces support the implementation of containers (lightweight virtualization)

Namespaces implemented in Linux:

* **mnt** mount namespace (2.4.19)
  - Specific view of the system's mounted file-systems
  - Includes mount paths (physical/network drives), union/bind/overlay file-systems
* **ipc** namespace (2.6.19)
  - System V IPC objects, POSIC message queues
  - Used for shared memory segments
* **uts** namespace (2.6.19) - Hostname and domain name values
* **pid** namespace (2.6.24)
  - Process identifier (PID) namespace groups processes
  - Start at PID 1, can be nested
* **net** network namespace (2.6.29)
  - Different IPv4/6 stacks (devices, addresses, routing, firewall rules. procfs, sockets, etc)
  - Most container solutions default to bridge-style virtual networks (using NAT)
* **user** namespace (3.8), unprivileged
  - Processes believe to be root when inside a namespace
  - Paved to way for full-unprivileged containers
* **cgroup** namespace (4.6) - Private control group hierarchy
* Not implemented yet...
  - security namespace
  - device namespace
  - time namespace

All privileged namespaces - mount,pid,uts,net,ipc,cgroup - require `CAP_SYS_ADMIN` to create.

System calls used for namespaces:

* `clone()` creates a **new process** and a **new namespace**, instrumented via the `CLONE_NEW` flags during process creation
* `unshare()` creates a new namespace and attaches the current process to it
* `setns()` is used to join/leave a namespace

Linux namespaces from the command-line:

```bash
/proc/$$/ns                          # per process sub-directory for each namespace
unshare <args>                       # run a program in namespace 
ip-netns <args>                      # manage a network namespace
nsenter <args>                       # enter the namespace of another program
```

## Container Runtime

Low level component used by a container engine (i.e. Docker):

* Communicates with the kernel to start containerized process
* Uses metadata to configure various namespaces (i.e. mount, cgroup) and the container security envelope (i.e. App)
* [Open Container Initiative (OCI) Runtime Specification][ocispec]

[ocispec]: https://github.com/opencontainers/runtime-spec

Container run-time systems:

* [runc][runc]
* [ccon][ccon]
* [nsjail][nsjail]
* [firejail][firejail]
* [bubblewrap][bubble]
* [systemd-nspawn][nspawn]
* [singularity][sing]
* [charliecloud][charlie]

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
* [nixery](https://github.com/google/nixery)
