# Unbound

[Unbound](https://www.unbound.net/) caching DNS resolver including DNSSEC support

```bash
apt -y install unbound                            # install the packages
## -- adjust resolv.conf after installation --  ##
dig +dnssec debian.org @127.0.0.1                 # query the local DNS resolver
ls -1 /etc/unbound/unbound.conf.d/*.conf          # configuration files
unbound-control status                            # service state
unbound-anchor -l                                 # list trusted achor key
unbound-control get_option auto-trust-anchor-file # show location of tursted key
unbound-control list_stubs                        # list root servers in use
```

Enable the control interface:

```bash
>>> cat /etc/unbound/unbound.conf.d/control-interface.conf 
remote-control:
  control-enable: yes                                 # enable remote control
  control-interface: 127.0.0.1                        # interface listening for remote control
>>> unbound-control-setup                             # generate the necessary keys
>>> systemctl restart unbound                         # restart the service
```
```bash
unbound-control stats_noreset                         # print statistics without reset
unbound-control dump_cache                            # print chache
unbound-control reload                                # flush cache reload config
```
