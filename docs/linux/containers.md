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
* **Manditory Acess Control** (MAC) - Tools to enforce security controls implemented for containers (i.e. AppAmor, SELinux)

### Namespaces

Namespaces wrap a particular global resource in an abstraction:

* Processes within a namespace have a dedicated isolated instance of the global resource
* Namespaces support the implementation of containers (lightweight virtualization)

Namespaces implemented in Linux:

* **mnt** mount namespace (2.4.19)
  - Specific view of the system's mounted file-systems
  - Includes mount paths (physical/network drives), union/bind/overlay file-systems
* **ipc** namespace (2.6.19)
  - System V IPC onjects, POSIC message queues
  - Used for shared memory segments
* **uts** namespace (2.6.19) - Hostname and domain name values
* **pid** namespace (2.6.24)
  - Process identifier (PID) namespace groups processes
  - Start at PID 1, can be nested
* **net** network namespace (2.6.29)
  - Different IPv4/6 stacks (devices, addresses, routing, firewall rules. procfs, sockets, etc)
  - Most container solutions default to birdge-style virtual networks (using NAT)
* **user** namespace (3.8)
  - Processes believe to be root when inside a namespace
  - Paved to way for full-unprivileged containers
* Not implemented yet...
  - security namespace
  - device namespace
  - time namespace

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
