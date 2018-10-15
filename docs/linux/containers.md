

Major components use in Linux containers:

* Kernel **Namespaces**
  - Isolation layer to implement different user-spaces views
  - Partitions process, users, network stacks, etc into separate spaces to provide processes a unique view onto the system
  - Instrumented via the `CLONE_NEW` flags during process creation with the `clone()` system call
  - `setns()`, `unshare()` facilitate namespace creation, and processes joining/leaving
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
* **Manditory Acess Control** (MAC) - Tools to enforce security controls implemented for containers (i.e. AppAmor, SELinux)


### Namespaces

* Mount Namespace (2.4.19)
  - Specific view of the system's mounted file-systems
  - Includes mount paths (physical/network drives), union/bind/overlay file-systems
* IPC Namespace (2.6.19), `CLONE_NEWIPC`
  - System V IPC onjects, POSIC message queues
  - Used for shared memory segments
* UTS Namespace (2.6.19), `CLONE_NEWUTS` - Hostname and domain name values
* PID Namespace (2.6.24), `CLONE_NEWPID`
  - Process identifier (PID) namespace groups processes
  - Start at PID 1, can be nested
* Network Namespace (2.6.24) `CLONE_NEWNET`
  - Different IPv4/6 stacks (devices, addresses, routing, firewall rules. procfs, sockets, etc)
  - Most container solutions default to birdge-style virtual networks (using NAT)
* User Namespace (2.6.23)
  - Processes believe to be root when inside a namespace
  - Paved to way for full-unprivileged containers



