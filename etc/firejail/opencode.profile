# vi: nospell
#
# This file is overwritten after every install/update
quiet

# Persistent local customizations (survives updates)
include opencode.local

# Persistent global definitions
include globals.local

###############################################################################
# NOBLACKLIST — Prevent disable-programs.inc from blocking opencode dirs
###############################################################################
noblacklist ${HOME}/.cache/opencode
noblacklist ${HOME}/.config/opencode
noblacklist ${HOME}/.local/share/opencode
noblacklist ${HOME}/.local/state/opencode

###############################################################################
# SECCOMP — Block dangerous system calls at kernel level
###############################################################################
seccomp

###############################################################################
# CAPABILITIES — Drop all Linux capabilities
###############################################################################
caps.drop all

###############################################################################
# PRIVILEGE ESCALATION PREVENTION
###############################################################################
nonewprivs       # Child processes can't gain new privileges via execve
noroot           # Enable user namespace with no root (uid 0) account
nogroups         # Disable supplementary user groups
restrict-namespaces  # Block creation of new cgroup, ipc, net, mount, pid,
                     # time, user, or uts namespaces by the sandboxed process

###############################################################################
# FILESYSTEM ISOLATION — Private (tmpfs-backed) directories
###############################################################################
private-tmp          # Empty tmpfs on /tmp
private-cache        # Empty tmpfs on ~/.cache (opencode cache re-added below)
private-dev          # New minimal /dev (only safe devices)
private-etc alternatives
private-etc ca-certificates
private-etc crypto-policies
private-etc dconf
private-etc fonts
private-etc ld.so.cache
private-etc ld.so.preload
private-etc machine-id
private-etc pki
private-etc resolv.conf
private-etc ssl

# private-etc explanation: Builds a new /etc in a tmpfs and only copies the
# listed files/dirs. The sandbox cannot see passwords (/etc/shadow), SSH
# configs, crontabs, or any other system configuration.

###############################################################################
# WHITELIST — Default-deny: only these paths are accessible in $HOME
###############################################################################
mkdir ${HOME}/.cache/opencode
whitelist ${HOME}/.cache/opencode

mkdir ${HOME}/.config/opencode
whitelist ${HOME}/.config/opencode

mkdir ${HOME}/.local/share/opencode
whitelist ${HOME}/.local/share/opencode

mkdir ${HOME}/.local/state/opencode
whitelist ${HOME}/.local/state/opencode

# Whitelist explanation: A tmpfs is mounted on $HOME. Only the explicitly
# whitelisted directories are bind-mounted back inside. Everything else
# (.ssh, .gnupg, Documents, Desktop, etc.) becomes invisible.

###############################################################################
# HARDCODED BLACKLISTS — Explicitly block sensitive paths
###############################################################################
blacklist ${HOME}/.ssh
blacklist ${HOME}/.gnupg
blacklist ${RUNUSER}/wayland-*      # Disable Wayland (CLI-only tool)
blacklist ${RUNUSER}                # Block all of /run/user/$UID (CLI-only)
blacklist /usr/libexec              # Remove system helper binaries

###############################################################################
# DISABLED RESOURCES
###############################################################################
no3d           # No 3D hardware acceleration
nodvd          # No DVD/audio CD devices
noinput        # No input device access
nosound        # No sound system
notv           # No DVB TV devices
nou2f          # No U2F security keys
novideo        # No video capture devices
noprinters     # No printer access

###############################################################################
# NETWORK — Allow only what's needed for API calls
###############################################################################
protocol unix,inet,inet6

# For a fully offline setup (local LLM, no API):
#   net none
#   protocol unix

###############################################################################
# IPC & DBUS ISOLATION
###############################################################################
ipc-namespace    # Isolate System V and POSIX IPC
machine-id       # Spoof /etc/machine-id with random value
dbus-user none   # No session D-Bus access
dbus-system none # No system D-Bus access

###############################################################################
# MISC HARDENING
###############################################################################
disable-mnt                    # Block /mnt, /media, /run/mount
noexec ${HOME}/.cache
noexec ${HOME}/.config
noexec ${HOME}/.local/share
env NO_BROWSER=true            # Opencode won't try to launch a browser
apparmor                       # Enable AppArmor "firejail-default" profile

