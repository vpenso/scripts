
Use [../source_me.sh](../source_me.sh) to add aliases and scripts to your environment.

Build development virtual machines on your workstation, cf. [libvirt.md](../docs/libvirt.md)

* [ansible-instance](ansible-instance) – Execute ansible in a virtual machine
* [chef-remote](chef-remote) —  Execute `chef-solo` in a virtual machine
* [salt-instance](salt-instance) – Execute salt in a virtual machine
* [ssh-exec](ssh-exec) — Wraps `ssh` to be used with `ssh-instance`
* [ssh-instance](ssh-instance) — Create custom SSH configuration files `ssh_config`
* [ssh-sync](ssh-sync) — Wraps `rsync` to be used with `ssh-instance`
* [virsh-config](virsh-config) — Create XML configuration files
* [virsh-instance](virsh-instance) — Manage local virtual machines
* [virsh-instance-port-forward](virsh-instance-port-forward) – Port forwarding for libvirt virtual machines
* [virsh-nat-bridge](virsh-nat-bridge) — Configure a bridged NATed network for libvirt

Skeleton for script development:

* [shell-skeleton](shell-skeleton) — Start developing shell script from here
* [ruby-skeleton](ruby-skeleton) — Start developing ruby scripts from here
* [ruby-skeleton-daemon](ruby-skeleton-daemon) – Start developing scripts with run as daemon from here

Node remote management, cf. [clush.md](../docs/clush.md)

* [nodeset-accessible](nodeset-accessible) – Check if a set of nodes allows SSH login
* [nodeset-loop](nodeset-loop) — Loop a command of a list of nodes
* [pingable](pingable) — Wait until a host has been pinged successful
* [ssh-agent-session](ssh-agent-session) — Use the same SSH agent across multiple shells
* [ssh-fs](ssh-fs) — Wrapper around `sshfs` for mounting remote directories over SSH
* [ssh-known-hosts](ssh-known-hosts) — Remove/add/update SSH host fingerprints associations (including FQDNs and IPs)
* [ssh-tunnel](ssh-tunnel) — Easy access to remote networks with `sshuttle`

Customize the working environment:

* [ansi-color](ansi-color) — Show ANSI color escaping
* [dir-colors](dir-colors) — Deploys a simple coloring configuration for `ls`
* [git-default-config](gir-default-config) — My custom Git configuration
* [tmux-cheat](tmux-cheat) — Most important Tmux keys
* [tmux-default-config](tmux-default-config) — Helps to configure Tmux terminal multiplexer
* [vim-cheat](vim-cheat) — "What was this key again?"

Misc

* **binary-prefix** – Add binary prefixes (e.g. K,G,M) to numbers.
* **debian-default-config** — Install Debian dependencies.
* **git-repos** — Maintains a list of Git remote repositories and shows the status[…][git]
* **gnuplot-timeseries** – Create SVG plots from time-series data with Gnuplot.[…][gnuplot]
* **hash-merge** — Merge multiple hash objects into one.
* **hash-transform** — Converts hash objects between JSON, YAML and CSV.
* **music** — Controls the local Music Player Daemon.
* **node-state** — Collect host monitoring information and serialize the data into JSON.
* **redis-values** — Store and load hash tables from a Redis database.
* **ruby-erb-template** – Render Erb templates.
* **segfaulter** — Create a small executable dieing with segfault.
* **sqlite-backup** — Backup SQLite database files into a Git remote repository.
* **time-elapsed** — Calculates elapsed time between two dates.
* **until-success** – Execute a command until it is successful.



[git]: ../docs/git.markdown
[gnuplot]: ../docs/gnuplot.markdown
[ssh]: ../docs/ssh.markdown
[virsh]: ../docs/libvirt.markdown

