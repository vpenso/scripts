

```
{/etc,/usr/lib}/firewalld                 # configuration
firewall-cmd                              # command-line interface
```

### Zones

Zones manage **group off rules**:

* Define what traffic is allowed based on network/package origin
* Network interfaces are assigned to a zone

```bash
firewall-cmd --get-default-zone           # show default zone
firewall-cmd --get-active-zones           # active zones
firewall-cmd --get-zones                  # list available zones
firewall-cmd --zone=$zone --list-all      # zone configuration
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
