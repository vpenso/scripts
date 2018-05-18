

```
{/etc,/usr/lib}/firewalld                 # configuration
firewall-cmd                              # command-line interface
```

Temporarily enable **logging of rejects**:

```bash
>>> firewall-cmd --set-log-denied=all
success
>>> firewall-cmd --get-log-denied
all
>>> grep REJECT /var/log/messages
...
>>> firewall-cmd --set-log-denied=off
success
```

### Zones

Zones manage **group off rules**:

* Define what traffic is allowed based on network/package origin
* Network interfaces are assigned to a zone
* Unassigned network interfaces use the default zone

```bash
firewall-cmd --get-default-zone              # show default zone
firewall-cmd --get-active-zones              # active zones
firewall-cmd --info-zone=public              # show public zone details
firewall-cmd --zone=$zone --list-all         # zone configuration
firewall-cmd --get-zone-of-interface=$iface  # zone of a network interface
# add an network interface to a zone
firewall-cmd --permanent --zone=$zone --add-interface=$iface
``` 

### Services

Services are sets of rules to open **ports associated with a particular application** or system service

```bash
{/etc/,/usr/lib}/firewalld/services/*.xml   # service definition files
firewall-cmd --get-services                 # list of all services
firewall-cmd --zone=$zone --list-services   # active services in zone 
firewall-cmd --permanent --zone=$zone --add-service=$service
                                            # activate a service for a zone
```



