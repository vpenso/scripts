# Pi-hole

**Block internet advertisement, tracking and malware**

Network-level DNS sinkhole:

* Intended for use in small private networks (at home).
* Blocks traffic of all devices in a network including
  - Desktops, workstations, laptops
  - Mobiles, tablets
  - Smart TVs, gaming consoles
  - Other "smart" devices... (watches, fridges, TV sticks, etc.)
* Benefits...
  - Improve overall network performance
  - Faster loading of web-sites
  - Reduce data usage
  - Monitor performance and statistics

Blocks DNS requests for known tracking and advertising domains

* Hands out non-routable addresses for all domains in the sinkhole.
* Modified `dnsmasq` called **FTLDNS** acts as...
  - ...caching and forwarding DNS server

## Installation

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

Customize the docker container configuration with [environment variables][01].

Cf. [Docker DHCP and Network Modes][03]

## Usage

Select your [upstream DNS providers][02] or setup with a recursive DNS server [rcdns]

Configure blocklists...

* Defaults to list hosted at [github.com/StevenBlack/hosts][04] [blsbh]...
* ...provides alternative list with expanded blocking adult content and fake news
* OISD [osdib] provides a very comprehensive "Full" blocklist

The `pihole` command:

```
pihole status        # status of blocking services
pihole -v            # list versions of components
pihole -g            # [gravity] retrieve blocklists, consolidate with black/whitelists
pihole -q DOMAIN     # search white/blacklist, wildcards and adlists for a specified domain
pihole -w DOMAIN     # whitelist DNS domain
pihole -w DOMAIN -d  # remove a DNS domain from whitelist
pihole -c -e         # [cronometer] console dashboard
```


### References

[picwr] Pi-hole Community Resources  
<https://pi-hole.net/>  
<https://docs.pi-hole.net/>  
<https://github.com/pi-hole/pi-hole>

[dkpic] Docker Pi-hole Container  
<https://hub.docker.com/r/pihole/pihole>  
<https://github.com/pi-hole/docker-pi-hole>

[blsbh] Default Blocklist by Steven Black  
<https://github.com/StevenBlack/hosts>

[rcdns] Unbound Recursive, Caching DNS Resolver  
<https://nlnetlabs.nl/projects/unbound>  
<https://github.com/NLnetLabs/unbound>  
<https://docs.pi-hole.net/guides/dns/unbound>

[osdib] Official OISD Blocklist  
<https://oisd.nl/>

### Links

AdGuard Home (Pi-hole alternative)  
<https://adguard.com/en/adguard-home/overview.html>  
<https://github.com/AdguardTeam/AdguardHome>

How to Setup Pi-hole on a Local Computer without Raspberry Pi  
<https://pawelurbanek.com/pihole-local-computer>

Pihole + unbound docker setup on Raspberry Pi, 2020/09  
<https://www.xfelix.com/2020/09/pihole-unbound-docker-setup-on-raspberry-pi>

The Best PiHole Blocklists, 2021/04  
<https://avoidthehack.com/best-pihole-blocklists>

[01]: https://github.com/pi-hole/docker-pi-hole/#environment-variables
[02]: https://docs.pi-hole.net/guides/dns/upstream-dns-providers/
[03]: https://docs.pi-hole.net/docker/dhcp
[04]: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
