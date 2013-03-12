
[Clustershell][clustershell] is a open-source Python library for highly parallel execution of remote commands over SSH. Even if you are operating an infrastructure with a configuration management system like [Chef][chef] (Puppet, or CfEngine) numerous situations demand interactive remote login to many nodes. Among the tools developed to help cluster administrators a common shorthand notation for defining groups of hosts is widely used. **Clustershell contains a tool called `nodeset` to transform lists of nodes into this host-list shorthand notation.**

    » echo "node1 node2 node3 node10" | nodeset -f
    node[1-3,10]
    » nodeset -S"\n" -e "node[1-3,6,8-10].foo.org"
    node1.foo.org
    node2.foo.org
    node3.foo.org
    node6.foo.org
    node8.foo.org
    node9.foo.org
    node10.foo.org

Seasoned administrators will find use-cases immediately. Simple for-loops over sets of nodes for example: 

    » for i in `nodeset -e 'node[001-100]'`; do ssh $i ifconfig eth0 | grep HWaddr; done
    eth0      Link encap:Ethernet  HWaddr 00:25:95:60:86:8a  
    eth0      Link encap:Ethernet  HWaddr 00:25:95:60:87:62  
    eth0      Link encap:Ethernet  HWaddr 00:25:95:60:87:de  
    [...]

Needless to say that `clush`, Clustershells tool to execute remote commands in parallel supports host-list expressions. Another prominent tool for parallel remote command execution `pdsh`, as well as the configuration of Lustre and Slurm are using this notation too. 

In case of infrastructures operated with Chef it is very helpful to **combine Knife searches with `nodeset`**. One possibility to implement this is by writing a Knife plugin (find an example [nodeset.rb][nodeset_rb] on Github). Basically **executing `knife nodeset QUERY` prints a host list expression representing the list of nodes you have been searching for. This expression can then be used in combination with `clush`.** Since such expression can become rather long and unpractical to cut&paste, storing them into a shell environment variable is advisable. For instance you can define a simple shell function to pipe an command output directly into such a variable. Here this function is called `exp()` and expects one parameter defining the name of the environment variable to export: 

    » function exp() { read n; export $1=$n }
    » knife nodeset "role:worker" | exp NODES
    » clush -b -l root -w $NODES uname -r
    ---------------
    node[682-776,781-788] (103)
    ---------------
    2.6.32-5-amd64

The clush option `-w $NODES` consumes the node-set. Different node-sets can be stored to environment variables, and can be reused without repeated queries to the Chef inventory. Alternatively you can use different shells to operate on different node-sets all stored in `$NODES`. In this case you can add a handy alias to use  this environment variable:

    » alias rush='clush -l root -w $NODES'
    » rush uptime | cut -d' ' -f 2- 
    09:15:18 up 66 days, 18:41,  9 users,  load average: 0.04, 0.09, 0.22
    09:15:18 up 66 days, 18:42, 21 users,  load average: 0.15, 0.20, 0.35
    09:15:18 up 66 days, 18:46, 33 users,  load average: 1.37, 1.29, 1.29
    09:15:18 up 66 days, 18:41,  3 users,  load average: 0.05, 0.07, 0.02
    » alias -g NS='| exp NODES'
    » knife nodeset "name:worker*" NS && rush uptime
    [...]
    » knife ssh -x root -m "`nodeset -e $NODES`" uptime 
    [...]

At this point there is still to remember that **`$NODES` can be consumed by Knife itself**, also. 

