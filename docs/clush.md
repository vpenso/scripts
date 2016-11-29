[Clustershell](http://cea-hpc.github.com/clustershell/) executes commands on multiple remote computers over SSH

- Manage list of target node names
- Manage number of parallel connections
- Merge identical command output, and return codes

↴ [var/aliases/clustershell.sh](../var/aliases/clustershell.sh)

Export/show an environment variable `NODES` containing a nodeset:

```bash
function NODES() {
  if [ $# -lt 1 ]
  then
    : ${NODES:?}
    echo $NODES
  else
    export NODES=$@
  fi
}
```

Use this environment variable to access a nodeset:

```bash
alias NODES='noglob NODES'                            # disable globing
function exp() { read n; export $1=$n }               # pipe to an environment variable
alias -g NE='| exp NODES'                             # ^^ global alias
alias -g NF='| nodeset -f'                            # global folding
alias -g NC='| nodeset -c'                            # global counting
NODES <nodeset>                                       # export a nodeset to the environment
NODES                                                 # show content of environment variable
nodeset -S "\n" -e $NODES                             # expand to one node per line
clush -b -l root -w $NODES <command>                  # execute command on a set of nodes
alias rush='clush -l root -w $NODES'                  # ^^ alias root exec with clush
```
Probe a nodeset for SSH login with ↴ [bin/nodeset-accessible](../bin/nodeset-accessible)

Sequentially execute a command on a nodeset with ↴ [bin/nodeset-loop](../bin/nodeset-loop)

```bash
nodeset-loop knife node run_list add {} "role[<role>]" # Modify run-list of a nodeset in Chef 
nodeset-loop ssh-known-hosts update {}                 # Update SSH fingerprints of ndoeset
```

Examples:

```bash
mount -t nfs | cut -d':' -f1 | nodeset -f             # fold all NFS mount points 
sinfo -o '%N' -h -p <partition> | nodeset -e          # expand all nodes for a Slurm partition
knife status -H 'role:exec*' | cut -d',' -f2 NF NE    # get a nodeset from Chef
```




