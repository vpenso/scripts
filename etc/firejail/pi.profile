# vi: nospell
#
# Firejail security profile for opencode
# Description: CLI AI coding assistant — sandboxed with minimal privileges

# For persistent customizations, edit opencode.local instead
quiet          # Suppress Firejail startup messages (parent/child PID output)

# Persistent local customizations (survives firejail package updates)
# Searched in ~/.config/firejail/ first, then /etc/firejail/
include opencode.local

# Persistent global definitions applied to all profiles
# Useful for system-wide overrides (e.g., shared whitelist paths)
include globals.local

###############################################################################
# NOBLACKLIST — Prevent disable-programs.inc from blocking pi dirs
###############################################################################
# These directories are listed in disable-programs.inc by default. The
# noblacklist directives override that blacklist so they remain accessible
# when combined with the whitelist section below.

noblacklist ${HOME}/bin            # Pi Executable linked to ~/opt
noblacklist ${HOME}/opt            # Pi installation path, sub-directories pi-${version}
noblacklist ${HOME}/.pi/agent      # Pi configuration files

###############################################################################
# SECCOMP — Block dangerous system calls at kernel level
###############################################################################
# Installs an eBPF seccomp filter that blocks a default list of dangerous
# syscalls including: mount, umount2, ptrace, kexec_load, init_module,
# delete_module, iopl, ioperm, swapon, swapoff, syslog, reboot, pivot_root,
# perf_event_open, fanotify_init, uselib, acct, modify_ldt, and others.
seccomp

###############################################################################
# CAPABILITIES — Drop all Linux capabilities
###############################################################################
# Removes all 40+ Linux capabilities (CAP_NET_RAW, CAP_SYS_ADMIN, etc.)
# so the sandboxed process cannot perform privileged operations like
# packet sniffing, mounting filesystems, or modifying kernel parameters.
caps.drop all

###############################################################################
# PRIVILEGE ESCALATION PREVENTION
###############################################################################
nonewprivs             # Set NO_NEW_PRIVS prctl; child processes can't gain new
                       # privileges via execve (blocks SUID/SGID binaries)
noroot                 # Enable user namespace with no root (uid 0) account;
                       # even if the process escapes, it has no root mapping
nogroups               # Disable supplementary user groups; prevents accessing
                       # files/group resources outside the primary group
restrict-namespaces    # Install seccomp filter blocking creation of new cgroup,
                       # ipc, net, mount, pid, time, user, or uts namespaces;
                       # prevents the sandboxed process from creating sub-sandboxes

###############################################################################
# FILESYSTEM ISOLATION — Private (tmpfs-backed) directories
###############################################################################
private-tmp            # Mount empty tmpfs on /tmp; prevents cross-sandbox file
                       # sharing and temp-file-based attacks
private-cache          # Mount empty tmpfs on ~/.cache; the opencode-specific
                       # subdirectory is re-added persistently below via mkdir+whitelist
private-dev            # Create minimal /dev with only safe devices (null, zero,
                       # random, urandom, tty, pts, log, shm); further restricted
                       # by the no3d/nosound/novideo/etc. directives below

# How private-etc works: Builds a new /etc in a tmpfs and copies only the
# listed files/directories. The sandbox cannot see /etc/shadow, SSH configs,
# crontabs, fstab, or any other system configuration not explicitly listed.
# All modifications to /etc inside the sandbox are discarded on exit.

private-etc alternatives           # System alternative symlinks (/usr/bin/env, etc.)
private-etc ca-certificates        # CA bundle for TLS verification during API calls
private-etc crypto-policies        # Crypto policy configs needed by OpenSSL/LibreSSL
private-etc fonts                  # Font configs for any terminal rendering
private-etc ld.so.cache            # Dynamic linker cache for faster library resolution
private-etc ld.so.preload          # Preload library config (kept empty for safety)
private-etc machine-id             # Machine ID (spoofed separately via machine-id dir)
private-etc pki                    # Platform trust store (RHEL/Fedora CA certificates)
private-etc resolv.conf            # DNS resolver config for API endpoint resolution
private-etc ssl                    # SSL certificate configs and cipher defaults


###############################################################################
# WHITELIST — Default-deny: only these paths are accessible in $HOME
###############################################################################
# Each pair creates the directory (if missing) and bind-mounts it into the
# tmpfs-backed home. Without mkdir, the directory would be ephemeral and
# deleted when the sandbox closes.

mkdir ${HOME}/bin
whitelist ${HOME}/bin

mkdir ${HOME}/opt
whitelist ${HOME}/opt

mkdir ${HOME}/.pi/agent
whitelist ${HOME}/.pi/agent


# How whitelist works: A tmpfs is mounted on $HOME. Only the explicitly
# whitelisted directories are bind-mounted back inside. Everything else
# (.ssh, .gnupg, Documents, Desktop, Downloads, etc.) becomes invisible.

###############################################################################
# HARDCODED BLACKLISTS — Explicitly block sensitive paths
###############################################################################
# These provide a failsafe: even if the whitelist above is disabled via a
# .local override, these paths remain inaccessible.

blacklist ${HOME}/.ssh                    # SSH keys, known_hosts, config
blacklist ${HOME}/.gnupg                  # GPG keys and trust database
blacklist ${RUNUSER}/wayland-*            # Wayland display sockets (CLI-only tool)
blacklist ${RUNUSER}                      # Block all of /run/user/$UID (XDG runtime dir);
                                          # prevents access to D-Bus sockets, flatpak, etc.
blacklist /usr/libexec                    # System helper binaries (package managers, polkit, etc.)

###############################################################################
# DISABLED RESOURCES
###############################################################################
no3d           # Disable 3D hardware acceleration (OpenGL/EGL/Vulkan devices)
nodvd          # Disable DVD and audio CD devices (/dev/cdrom, /dev/sr*)
noinput        # Disable input devices (keyboard, mouse, touchpad — /dev/input/*)
nosound        # Disable sound system (/dev/snd*, PulseAudio, PipeWire audio)
notv           # Disable DVB TV capture devices (/dev/dvb/*)
nou2f          # Disable U2F security key devices (FIDO2/WebAuthn hardware keys)
novideo        # Disable video capture devices (/dev/video*, V4L2 webcams)
noprinters     # Disable CUPS printer access and lp device nodes

###############################################################################
# NETWORK — Allow only what's needed for API calls
###############################################################################
# Restricts socket() syscalls via seccomp to only the listed protocols.
# unix = local Unix domain sockets (needed for DNS resolver, localhost)
# inet = IPv4 TCP/UDP (API endpoints)
# inet6 = IPv6 TCP/UDP (API endpoints over IPv6)
# Blocked: netlink (routing/netconfig), packet (raw packets/sniffing), bluetooth
protocol unix,inet,inet6

# For a fully offline setup (local LLM, no API):
#   net none
#   protocol unix

###############################################################################
# IPC & DBUS ISOLATION
###############################################################################
ipc-namespace    # Create a new IPC namespace; isolates System V semaphores,
                 # shared memory segments, and POSIX message queues from other
                 # sandboxes and the host
machine-id       # Spoof /etc/machine-id with a random value; prevents fingerprinting
                 # and breaks services that rely on the real machine ID
dbus-user none   # Block session D-Bus entirely; no access to desktop bus services
dbus-system none # Block system D-Bus entirely; no access to systemd, NetworkManager, etc.

###############################################################################
# MISC HARDENING
###############################################################################
disable-mnt                    # Blacklist /mnt, /media, /run/mount, /run/media;
                               # prevents access to removable media and mount points
noexec ${HOME}/.cache          # Remount noexec/nodev/nosuid; prevent executing code
                               # from cache directories (supply chain attack mitigation)
noexec ${HOME}/.config         # Same protection for config directory
noexec ${HOME}/.local/share    # Same protection for shared data directory
env NO_BROWSER=true            # Set environment variable so opencode skips browser launch
                               # (useful for OAuth flows that should fail gracefully in sandbox)
apparmor                       # Enable AppArmor "firejail-default" mandatory access control
                               # profile as an additional defense-in-depth layer

