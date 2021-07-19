
### Deployment

```bash
# prepare a virtual machine for testing
cat > Vagrantfile <<EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define  "pihole"
  config.vm.box = "debian/buster64"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.0.10"
end
EOF
vagrunt up && vagrant ssh
# after login install the software
curl -sSL https://install.pi-hole.net | bash

$BROWSER http://192.168.0.10/admin/
```


### References



[picwr] Pi-hole Community Resources  
<https://pi-hole.net/>  
<https://github.com/pi-hole/pi-hole>

[htsph] How to Setup Pi-hole on a Local Computer without Raspberry Pi  
<https://pawelurbanek.com/pihole-local-computer>
