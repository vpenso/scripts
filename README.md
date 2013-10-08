Description
===========

This repository contains lots of scripts for various purposes 
developed to make my life easier.

Use `source_me.sh` to add aliases and scripts to your environment.

In the `bin/` sub-directory

* **ansi-color** — Show ANSI color escaping.
* **chef-remote** —  Execute `chef-solo` on a remote node.
* **debian-default-config** — Install Debian dependencies.
* **dir-colors** — Deploys a simple coloring configuration.
* **git-default-config** — My custom Git configuration.
* **git-repos** — Maintains a list of Git remote repositories and 
  shows the status[…][git]
* **gnuplot-timeseries** – Create SVG plots from time-series data with Gnuplot.
* **hash-merge** — Merge multiple hash objects into one.
* **hash-transform** — Converts hash objects between JSON, YAML and CSV.
* **mpd-default-config** — Writes a personal MPD configuration.
* **music** — Controls the local Music Player Daemon.
* **node-state** — Collect host monitoring information and 
  serialize the data into JSON.   
* **pingable** — Wait until a host is pingable.
* **redis-values** — Store and load hash tables from a Redis database.
* **ruby-erb-template** – Render Erb templates.
* **ruby-skeleton** — Start developing ruby scripts from here.
* **segfaulter** — Create a small executable dieing with segfault.
* **shell-skeleton** — Start developing shell script from here.
* **ssh-agent-session** — Use the same SSH agent across multiple 
shells.
* **ssh-exec** — Wraps `ssh` to be used with `ssh-instance`.
* **ssh-fs** — Wrapper around `sshfs` for mounting remote paths
over SSH.
* **ssh-instance** — Create custom SSH configuration files `ssh_config`.
* **ssh-known-hosts** — Remove/add/update SSH host fingerprints.
* **ssh-sync** — Wraps `rsync` to be used with `ssh-instance`.
* **ssh-tunnel** — Easy access to remote networks with `sshuttle`.
* **sqlite-backup** — Backup SQLite database files into a Git 
remote repository.
* **time-elapsed** — Calculates elapsed time between two dates.
* **tmux-cheat** — Most important Tmux keys.
* **tmux-default-config** — helps to configure Tmux terminal
  multiplexer.
* **vim-cheat** — "What was this key again?" Vim cheat sheet. 
* **vim-default-config** — Install Vundle and my personal Vim configuration.
* **virsh-config** — Create XML configuration files[…][virsh]
* **virsh-instance** — Manage local virtual machines[…][virsh]
* **virsh-nat-bridge** — Configure a bridged NATed network for libvirt[…][virsh]
* **zsh-default-config** — Install antigen and my default Zsh 
  configuration.

[git]: docs/git.markdown
[virsh]: docs/virsh.markdown

License
=======

Copyright 2012-2013 Victor Penso

This is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. If not, see 
<http://www.gnu.org/licenses/>.
