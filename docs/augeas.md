
**Lenses** parse configuration files into a `/files` hierarchy, which can be queried using XPath

```bash
agp() { augtool print /files/$@ }     
alias ags='augtool -sb'               # modify target an backup to <path>.augsave
alias agn='augtool -n'                # don't modifiy target, but create <path>.augnew 
agdiff() { diff -up $1 $1.augnew ; }  # compare test output with original
# create a sandbox with a copy of /etc
export AUGEAS_ROOT=/tmp/augeas_root ; mkdir $AUGEAS_ROOT ; cd $AUGEAS_ROOT
sudo cp -pr /etc $AUGEAS_ROOT ; sudo chown -R $(id -nu):$(id -ng) $AUGEAS_ROOT
```

Onliner examples:

```bash
augtool print /files/etc/hosts                         # print a configuration file
augtool match /files/etc/hosts/*/ipaddr 127.0.0.1      # find a configuration in a file
augtool -sb set '/files/etc/hosts/1/alias[last()+1]' local.domain
                                                       # add alias to host
augtool -sb rm "/files/etc/hosts/*[alias = 'local.domain']"
                                                       # remove entity in hosts with alias
augtool print "/files/etc/passwd/*[uid='0'][1]"        # print configuration of a defined UID 
augtool match "/files/etc/passwd/*[name='root']/shell" # show shell used by user 
augtool -sb set "/files/etc/passwd/*[uid='0']/shell /bin/zsh"
                                                       # modify shell use by UID
```

Custom function for a configuration file, e.g `resolv.conf`

```bash
ags_resolv() { local cmd=$1 ; shift ; augtool -t 'Resolv.lns incl /etc/resolv.conf' -sb set /files/etc/resolv.conf/$@ ; }
ags_resolv nameserver[1] <ipaddress>                     # change IP of primary DNS
ags_resolv nameserver[2] $(host <fqdn> | cut -d' ' -f4)  # change IP of secondary DNS using a hostname
```
