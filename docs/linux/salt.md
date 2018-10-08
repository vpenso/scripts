

Documentation:

<https://docs.saltstack.com/en/latest/>

Source code:

<https://github.com/saltstack/salt>

Salt terminology:

* Master - Server daemon serving the configuration to client nodes (minions)
* Minion - Client daemon syncing with the salt-master
* Salt State System (SLS) - **States** are a representation of a state a system should be in (YAML)
* **Grains** - Information collected about systems by each salt-minion (upon execution)
* **Mine** - Periodically collected data by a process running on the master
* **Pillars** - Centralized conf. data available to minions (referenced in state files)
* Environments - Organization of the state tree directory
* Runners - Execution modules running (asynchronous or synchronous) on salt-master
* Beacons - Monitor things outside Salt, send notifications (events) on changes
* Reactor - Triggers actions in response to events (associate events to states)

Multiple execution methods:

* Master-less configuration (salt-call with local conf.)
* No agent needed (salt-ssh)
* Master-Minion
* "Dump" devices (salt-proxy)
* Multiple masters (salt-syndic)


## Master

Commands use on the master:

```bash
salt-master                             # daemon running the master process
systemctl restart salt-master           # restart the master 
/etc/salt                               # main configuration files
/etc/salt/master                        # master main configuration
/etc/sa;t/masgter.d/conf
/etc/salt/pki/master                    # authentication keys
/var/log/salt/master                    # master log-file
/var/cache/salt/master                  # cache data
```

Minions not part of the cluster until master accepts its key:

```bash
salt-key ...                            # manag public keys of minions
salt-key -A -y                          # accept all (unaccpeted) Salt minions
salt-key -L                             # list all keys
salt-key -d <minion>                    # remove a minion key
salt-key -a <minion>                    # add a single minion key
```

```bash
salt ...                                # control & execute states on remote systems
salt <target> test.ping                 # check if a minion repsonds
salt <target> state.apply               # configure a node
salt <target> state.apply <sls>         # limit configuration to a single SLS file
salt <target> cmd.run <command> ...     # execute a shell command on nodes
salt-run ...                            # execute runners (applications) on the master
salt-run jobs.active                    # list active jobs
salt-run jobs.exit_success <jid>        # check if a job has finished
salt <target> saltutil.kill_job <jid>   # remove jobs on target
salt <target> grains.items              # list all grains
salt <target> grains.get <item>         # show specific grain
salt-ssh ...                            # execute salt routins using SSH only
```

## Minion

Commands used on a minion:

```bash
salt-minion ...                         # daemon running the client process
salt-minion -l debug                    # start minion in forground
systemctl restart salt-minion           # restart minion
journalctl -f -u salt-minion            # read the minion log
/etc/salt/minion                        # main minion configuration
/etc/salt/grains                        # YAML formated grains
/etc/salt/pki/minion                    # authentication keys
/var/log/salt/minion                    # main minion log file
salt-call ...                           # fetch conf. from the master
salt-call state.apply <sls>             # limit configuration to a single SLS file
salt-call -l debug state.apply          # debug minion states
```

