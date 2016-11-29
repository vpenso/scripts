
Use [../source_me.sh](../source_me.sh) to add aliases and scripts to your environment.

Build development virtual machines on your workstation → [libvirt.md][../docs/libvirt.md]

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
* [ruby-skeleton-daemon](   ruby-skeleton-daemon) – Start developing scripts with run as daemon from here

* **ansi-color** — Show ANSI color escaping.
* **binary-prefix** – Add binary prefixes (e.g. K,G,M) to numbers.
* **chef-remote** —  Execute `chef-solo` on a remote node
* **debian-default-config** — Install Debian dependencies.
* **dir-colors** — Deploys a simple coloring configuration.
* **git-default-config** — My custom Git configuration.
* **git-repos** — Maintains a list of Git remote repositories and shows the status[…][git]
* **gnuplot-timeseries** – Create SVG plots from time-series data with Gnuplot.[…][gnuplot]
* **hash-merge** — Merge multiple hash objects into one.
* **hash-transform** — Converts hash objects between JSON, YAML and CSV.
* **music** — Controls the local Music Player Daemon.
* [nodeset-accessible](nodeset-accessible) – Check if a set of nodes allows SSH login, cf. [clush.md](../docs/clush.md)
* [nodeset-loop](nodeset-loop) — Loop a command of a list of nodes, cf. [clush.md](../docs/clush.md)
* **node-state** — Collect host monitoring information and serialize the data into JSON.
* **pingable** — Wait until a host is pingable.
* **redis-values** — Store and load hash tables from a Redis database.
* **ruby-erb-template** – Render Erb templates.
* **segfaulter** — Create a small executable dieing with segfault.
* **ssh-agent-session** — Use the same SSH agent across multiple shells[…][ssh]
* **ssh-fs** — Wrapper around `sshfs` for mounting remote directories over SSH[…][ssh]
* **ssh-known-hosts** — Remove/add/update SSH host fingerprints.
* **ssh-tunnel** — Easy access to remote networks with `sshuttle`.
* **sqlite-backup** — Backup SQLite database files into a Git remote repository.
* **time-elapsed** — Calculates elapsed time between two dates.
* **tmux-cheat** — Most important Tmux keys.
* **tmux-default-config** — helps to configure Tmux terminal multiplexer.
* **until-success** – Execute a command until it is successful.
* **vim-cheat** — "What was this key again?" Vim cheat sheet. 
* **vim-default-config** — Install Vundle and my personal Vim configuration.
* **zsh-default-config** — Install antigen and my default Zsh 
  configuration.



[git]: ../docs/git.markdown
[gnuplot]: ../docs/gnuplot.markdown
[ssh]: ../docs/ssh.markdown
[virsh]: ../docs/libvirt.markdown

