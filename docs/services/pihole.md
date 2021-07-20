
## Deployment

Simple test environment with Vagrant:

```bash
cd $(mktemp -d)
# prepare a virtual machine for testing
cat > Vagrantfile <<EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define  "pihole"
  config.vm.box = "debian/buster64"
  config.vm.network "private_network", ip: "192.168.50.10"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # this is only required for the deployment using Docker
  #config.vm.provision "shell" do |s|
  #  s.privileged = true,
  #  s.inline = <<-SCRIPT
  #    apt-get update
  #    apt-get install -y docker docker-compose
  #  SCRIPT
  #end
end
EOF
vagrant up && vagrant ssh
```

Install using the GitHub repository and a script:

```bash
# after login install the software (make sure to select the 
# right network interface in the dialog)
curl -sSL https://install.pi-hole.net | bash
# display running status
pihole status
# set the admin password
pihole -a -p 12345678
# open the web-interface
$BROWSER http://192.168.50.10/admin/
# query the DNS
host www.google.de 192.168.50.10
```

## References

[picwr] Pi-hole Community Resources  
<https://pi-hole.net/>  
<https://docs.pi-hole.net/>  
<https://github.com/pi-hole/pi-hole>

[dkpic] Docker Pi-hole Container  
<https://hub.docker.com/r/pihole/pihole>  
<https://github.com/pi-hole/docker-pi-hole>

[htsph] How to Setup Pi-hole on a Local Computer without Raspberry Pi  
<https://pawelurbanek.com/pihole-local-computer>
