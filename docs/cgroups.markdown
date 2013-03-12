
# Linux Control Groups

Control Groups (called by its short name `cgroups`) is a method to **group processes, isolate them, and control (limit) their resource consumption**. It is implemented as a pseudo file-system in Linux and supports control of resources like CPU time, resident memory, network bandwidth and other special devices. Administrators can use `cgroups` for access control, prioritization, limiting and monitoring hardware resources.

[Control Groups][1] is organized hierarchically, where child processes inherit attributes of their parent cgroup. In the cgroup terminology processes are called tasks. Hardware resources are manged by different subsystems (controllers), for example `cpuset` assigns individual CPU cores and `blkio` limits input/output access to block devices. A cgroup hierarchy usually uses several subsystems to control a group of processes. A single processes/task can only belong to a single cgroup hierarchy while controlled by many subsystems. 

## Basics

Debian provides the [cgroup-bin][5] package ([bugs][6]) to support this functionality. The `lssubsys` command lists all available subsystems.

    » lsb_release -ic
    Distributor ID: Debian
    Codename:       wheezy
    » uname -r
    3.2.0-3-amd64
    » apt-get install cgroup-bin
    » lssubsys -am
    cpuset
    cpu
    cpuacct
    memory
    devices
    freezer
    net_cls
    blkio
    perf_event
    » cat /proc/cgroups
    [...SNIP...]

Mount a control group subsystem into a directory of your choice (in this case the directory `/cgroup/cpu` mounts the `cpu` subsystem).

    » mkdir -p /cgroup/cpu
    » mount -o cpu -t cgroup cgroup:cpu /cgroup/cpu
    » grep cgroup /proc/mounts
    cgroup:cpu on /cgroup/cpu type cgroup (rw,cpu)
    » tree /cgroup/
    /cgroup/
    └── cpu
        ├── cgroup.clone_children
        ├── cgroup.event_control
        ├── cgroup.procs
        ├── cpu.shares
        ├── notify_on_release
        ├── release_agent
        └── tasks
    » lssubsys -m
    cpu /cgroup/cpu
    » wc -l /cgroup/cpu/tasks 
    57 /cgroup/cpu/tasks

All processes running on the system are associated with the control group hierarchy already. In order to add a new group simply create a new directory (here `/cgroup/cpu/background`), adjust the CPU shares in the file `cpu.shares`, and add processes to the `tasks` file.

    » mkdir /cgroup/cpu/background
    » echo 100 > /cgroup/cpu/background/cpu.shares
    » stress -c 1 &
    » echo $! > /cgroup/cpu/background/tasks
    » stress -c 1 &
    » ps -C stress -o "pid,stat,ni,psr,pset,cgroup,comm"
      PID STAT  NI PSR PSET CGROUP                      COMMAND
     2785 S      0   0    - 1:cpu:/background           stress
     2786 R      0   0    - 1:cpu:/background           stress
     2797 S      0   0    - -                           stress
     2798 R      0   0    - -                           stress
    » top -n 1 -b -i
    top - 15:03:59 up 38 min,  1 user,  load average: 2.01, 2.13, 1.57
    Tasks:  57 total,   3 running,  54 sleeping,   0 stopped,   0 zombie
    %Cpu(s): 49.9 us,  0.5 sy,  0.0 ni, 39.8 id,  9.4 wa,  0.0 hi,  0.0 si,  0.4 st
    KiB Mem:   1027072 total,   958872 used,    68200 free,     4584 buffers
    KiB Swap:        0 total,        0 used,        0 free,   898920 cached
    
      PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
     2798 root      20   0  6508   92    0 R  92.3  0.0   6:27.28 stress
     2786 root      20   0  6508   92    0 R  13.2  0.0   5:32.40 stress

## Tools

Besides directly manipulating the control group file-system it is possible to utilize the user-space tools. The command `cgexec` for example adds a program to a control group.

    » cgcreate -g cpu:background
    » cgget -g cpu:background
    background:
    cpu.shares: 1024
    » cgset -r cpu.shares=100 background
    » cgexec -g cpu:background stress -c 1 &
    » cat "/proc/$!/cgroup"
    1:cpu:/background

Users can manage their own control group (in this example the user is called `devops`).

    » cgcreate -a devops:devops -t devops:devops -g cpu:devops
    » ls -l /cgroup/cpu/devops/
    -rw-r--r-- 1 devops devops 0 Nov  5 15:36 cgroup.clone_children
    --w--w--w- 1 devops devops 0 Nov  5 15:36 cgroup.event_control
    -rw-r--r-- 1 devops devops 0 Nov  5 15:36 cgroup.procs
    -rw-r--r-- 1 devops devops 0 Nov  5 15:36 cpu.shares
    -rw-r--r-- 1 devops devops 0 Nov  5 15:36 notify_on_release
    -rw-r--r-- 1 devops devops 0 Nov  5 15:36 tasks
    » cgdelete -r cpu:devops

# Subsystems

## Memory

The [Memory Resource Controller][2] isolates the memory of a group of tasks from the rest of the systems. Administrators can use this subsystem for example to limit the allocatable memory for a process.

    » cgcreate -g memory:128MB
    » cgset -r memory.limit_in_bytes=128M 128MB
    » cgget -r memory.limit_in_bytes 128MB
    128MB:
    memory.limit_in_bytes: 134217728
    » cat /cgroup/memory/128MB/memory.usage_in_bytes
    0
    » echo $$ > /cgroup/memory/128MB/tasks 
    » cat /cgroup/memory/128MB/memory.usage_in_bytes
    253952
    » stress -m 128MB
    stress: info: [2177] dispatching hogs: 0 cpu, 0 io, 120 vm, 0 hdd
    Killed
    » dmesg
    [...SNIP...]
    [65861.142801] Memory cgroup out of memory: Kill process 2278 (stress) score 971 or sacrifice child
    [65861.142844] Killed process 2278 (stress) total-vm:268656kB, anon-rss:130812kB, file-rss:168kB

## Network (net_cls)

The `net_cls` subsystems is used to apply tags to network packages to allow the Linux kernel traffic control system to manage network bandwidth. Read the man pages `tc` and `tc-htb` to configure the traffic controller to limit packages tagged by control groups.

    » tc qdisc del root dev eth0
    » tc qdisc add dev eth0 root handle 1: htb default 2
    » tc class add dev eth0 parent 1: classid 1:2 htb rate 64kbit
    » tc filter add dev eth0 protocol ip parent 1:0 prio 1 handle 1: cgroup
    » tc class show dev eth0
    class htb 1:2 root prio 0 rate 64000bit ceil 64000bit burst 1600b cburst 1600b
    » cgcreate -g net_cls:throttle 
    » cgset -r net_cls.classid=0x10002 throttle
    » cgget -r net_cls.classid throttle
    throttle:
    net_cls.classid: 65537
    » cgexec -g net_cls:throttle wget -O /dev/null http://cdimage.debian.org/[...SNIP...]
    » tc -s class show dev eth0
    class htb 1:2 root prio 0 rate 64000bit ceil 64000bit burst 1600b cburst 1600b 
     Sent 354060 bytes 4577 pkt (dropped 0, overlimits 0 requeues 0) 
     rate 56888bit 92pps backlog 0b 145p requeues 0 
     lended: 4432 borrowed: 0 giants: 0
     tokens: -451998 ctokens: -451998

The `net_cls.classid` contains the handle used by traffic control. Its format is hexadecimal 0xAAAABBBB where a classid `1:2` translates to 0x10002 (leading zeros can be omitted). 

## Processor Affinity (cpuset)

Processor affinity (also called CPU pinning) binds processes to individual CPU cores. The control groups `cpuset` subsystem assigns CPUs and memory to groups of tasks. After setting at least the two mandatory parameters `cpuset.cpus` and `cpuset.mems` tasks can be moved into the control group.

    » cgcreate -g cpuset:stress
    » cgset -r cpuset.cpus=0 stress
    » cgset -r cpuset.mems=0 stress
    » cgexec -g cpuset:stress stress -c 3 &
    » ps r -AL -o stat,pid,psr,lastcpu,pcpu,cputime -C stress
    STAT   PID PSR   C %CPU     TIME COMMAND
    R     2803   0   0 35.0 00:00:00 stress
    R     2804   0   0 35.5 00:00:00 stress
    R     2805   0   0 35.0 00:00:00 stress
    R+    2806   1   1  0.0 00:00:00 ps

The example above illustrates the binding of several stress processes to s single core.

# Deployment

Memory control group support is deactivated by default (the same is true for SWAP accounting) and needs to be enabled by kernel boot parameter.

    » grep GRUB_CMDLINE_LINUX= /etc/default/grub 
    GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount"
    » update-grub2
    [...SNIP...]


## Configuration

Deploy configurations from a file with the command `cgconfigparse`.

    » cat /etc/cgconfig.conf
    mount {
      cpuset = /cgroup/cpuset;
      cpu = /cgroup/cpu;
      cpuacct = /cgroup/cpuacct;
      memory = /cgroup/memory;
      devices = /cgroup/devices;
      freezer = /cgroup/freezer;
      net_cls = /cgroup/net_cls;
      blkio = /cgroup/blkio;
    }
    » cgclear
    » cgconfigparser -l /etc/cgconfig.conf
    » lscgroup 
    cpuset:/
    cpu:/
    cpuacct:/
    memory:/
    devices:/
    freezer:/
    net_cls:/
    blkio:/
    » grep cgroup /proc/mounts 
    cgroup /cgroup/cpuset cgroup rw,relatime,cpuset 0 0
    cgroup /cgroup/cpu cgroup rw,relatime,cpu 0 0
    cgroup /cgroup/cpuacct cgroup rw,relatime,cpuacct 0 0
    [...SNIP...]


Before loading from a new configuration file it may be needed to destroy **all** control group hierarchies with the command `cgclear`.

## Authorization by PAM module

Use the Debian package [libpam-cgroup][4] to install the cgroups PAM module. Add group configurations to the `/etc/cgconfig.conf` file (in this example for the group `devops`).

    
    » apt-get install libpam-cgroup
    » grep cgroup /etc/pam.d/*
    /etc/pam.d/login:session                optional        pam_cgroup.so
    /etc/pam.d/sshd:session                optional        pam_cgroup.so
    /etc/pam.d/su:session                optional        pam_cgroup.so
    » cat /etc/cgconfig.conf
    [...SNIP...]
    group devops {
      cpu {
        cpu.shares="250"; }
      cpuacct {  
        cpuacct.usage="0"; }
      memory { 
        memory.limit_in_bytes="2G"; }
    }

[1]: http://www.kernel.org/doc/Documentation/cgroups/cgroups.txt
[2]: http://www.kernel.org/doc/Documentation/cgroups/memory.txt
[4]: http://packages.debian.org/libpam-cgroup
[5]: http://packages.debian.org/cgroup-bin
[6]: http://bugs.debian.org/cgi-bin/pkgreport.cgi?package=cgroup-bin

