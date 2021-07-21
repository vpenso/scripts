# Pi-hole

**Block internet advertisement, tracking and malware**

Network-level DNS sinkhole:

* Intended for use in small private networks (at home).
* Blocks traffic of all devices in a network including
  - Desktop, workstations
  - Mobiles, tablets
  - Smart TVs, gaming consoles
* Benefits...
  - Improve overall network performance
  - Faster loading of web-sites
  - Reduce data usage
  - Monitor performance and statistics

Blocks DNS requests for known tracking and advertising domains

* Hands out non-routable addresses for all domains in the sinkhole.
* Modified `dnsmasq` called **FTLDNS** acts as DNS server for a private network.

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

### Script

Deployment using the official script:

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

### Docker

Deployment using the official docker container [dkpic]:

```bash
# download a docker configuration file
wget -O docker-compose.yml \
      https://raw.githubusercontent.com/pi-hole/docker-pi-hole/master/docker-compose.yml.example
sudo su 
# start the docker container
docker-compose up --detach
# find the randomly generated admin password
docker logs pihole | grep random
# use the `pihole` command in the container
docker exec pihole pihole status
```

Customize the docker container configuration with [environment variables][01]:

* [Upstream DNS Providers][02]

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

[adghm] AdGuard Home  
<https://adguard.com/en/adguard-home/overview.html>  
<https://github.com/AdguardTeam/AdguardHome>

[01]: https://github.com/pi-hole/docker-pi-hole/#environment-variables
[02]: https://docs.pi-hole.net/guides/dns/upstream-dns-providers/
