 Who's there?

    uptime
    who -uw
    w
    last -n 20 -ax
    fuser -va 22/tcp

Where am I?

    hostname -f
    lsb_release -a
    uname -a
    last reboot

Some text based monitoring tools:

    nmon
    atop
    htop
    iotop
    top
    powertop         # energy consumption
    nload            # network traffic by interface
    iftop
    iptraf           # network traffic by IPs
    nethoqs          # traffic by process IDs

Log files:

    dmesg
    tail -f -n 50 /var/log/syslog | ccze
    multitail /var/log/syslog /var/log/messages

Current system state:

    procinfo -D -n1
    /proc/interrupts

Hardware:

    dmidecode --type processor
    hwinfo --cpu
    lshw -class processor
    lscpu
    lspci -tv
    lsusb -tv
    /proc/cpuinfo
    /proc/devices

### Processes

Get an overview of the resources and system state:

    pstree -lpu
    ps -AfH
    watch -n1 ps r -AL -o stat,pid,user,psr,pcpu,pmem,args
    dstat
    mpstat -P all

Follow the execution flow of a process:

    strace -f -p PID
    gdb attach PID
    (gdb) bt
    (gdb) detach
    (gdb) quit

Open file handles of a process:

    lsof -p PID

### Storage

Hardware identification:

    hwinfo --disk
    lshw -class storage -class disk --class volume
    fdisk -l
    hdparm -I /dev/sda
    smartctl -a /dev/sda
    /proc/partitions

Available space on local devices:

    df -hlP | sed 1d | sort -rn -k5,5

Mount table:

    mount | column -t

Read/write traffic

    iostat -xh 1
    /proc/diskstats

File handles in path:

    lsof PATH

### Memory

Hardware identification:

    lshw -C memory -short
    hwinfo --memory

Memory consumption on the system

    free -mt
    vmstat
    /proc/meminfo

Top 10 memory consumers:

    ps -A -o pid,user,rss,%mem --sort -rss | head

Search for processes killed by the kernel:

    egrep -i 'killed process' /var/log/messages

Memory mapping of a single process:

    pmap PID

### Network

Hardware identification:

    ethtool eth0

List network interfaces:
 
    ip a
    ip -s link
    ifconfig -a
    netstat -ie
    tcpdump -D

Host IP address:

    hostname -i

Ethernet ARP table:

    ip n
    arp -a

Listening ports:

    ss -l
    netstat -lN

Established connections:

    lsof -nPi tcp
    ss -r

Process socket binding:

    netstat -p
    ss -p
    socklist

Routing table:

    ip r
    route -n 
    netstat -rn 

Firewall rules:

    iptables -L -n -v

Follow the route to an IP address:

    mtr www.google.com
    tcptraceroute www.google.com
    traceroute www.google.com

Listen to network traffic:

    tcpdump -X -C NUM -i INTERFACE
    tcpdump -i eth0 arp
    tcpdump -i eth0 port 22
    tcpdump -i eth0 dst W.X.Y.Z and port 22


