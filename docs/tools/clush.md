# Clustershell

[Clustershell](http://cea-hpc.github.com/clustershell/) executes commands on multiple remote computers over SSH

- Manage list of target node names
- Manage number of parallel connections
- Merge identical command output, and return codes

### Configuration

File                                  | Description
--------------------------------------|---------------------------------------
[var/aliases/clustershell.sh][sh] [1] | Shell configuration (env. variables, functions)
[bin/nodeset-accessible][na]          | Probes a nodeset for SSH login
[bin/nodeset-loop][nl]                | Sequentially executes a command on a nodeset 

[1] defines a shell function `NODES` to export, and show an environment variable
`$NODES` containing a nodeset:

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

This simplifies the export of `$NODES` to a shorthand:

```bash
# set the environment variable
>>> NODES abcd00[1-9]         # equals `export NODES=abcd00[1-9]`
# print the value of $NODES
>>> NODES                     # equals `echo $NODES`
abcd00[1-9]
```

Programs supporting the nodeset notation can then work by convention with the
environment variable `$NODES`.

[sh]: ../../var/aliases/clustershell.sh
[na]: ../../bin/nodeset-accessible
[nl]: ../../bin/nodeset-loop

### Usage

Use an environment variable `$NODES` to access a nodeset:

```bash
alias NODES='noglob NODES'                            # disable globing
function exp() { read n; export $1=$n }               # pipe to an environment variable
alias -g NE='| exp NODES'                             # ^^ global alias
alias -g NF='| nodeset -f'                            # global folding
alias -g NC='| nodeset -c'                            # global counting
nodeset -S "\n" -e $NODES                             # expand to one node per line
clush -b -l root -w $NODES <command>                  # execute command on a set of nodes
alias rush='clush -l root -w $NODES'                  # ^^ alias root exec with clush
```

Examples:

```bash
mount -t nfs | cut -d':' -f1 | nodeset -f             # fold all NFS mount points 
sinfo -o '%N' -h -p <partition> | nodeset -e          # expand all nodes for a Slurm partition
knife status -H 'role:exec*' | cut -d',' -f2 NF NE    # get a nodeset from Chef
nodeset-loop ssh-known-hosts update {}                # Update SSH fingerprints of nodeset
```





```bash
nodeset-loop ssh-known-hosts update {}                 # Update SSH fingerprints of ndoeset
```





