## Namespaces

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

