# Pi-hole

Pi-Hole [picwr] is a network-level DNS sinkhole to:

**Block internet advertisement, tracking and malware**

* Intended for use in small private networks (at home)
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
* Hands out non-routable addresses for all domains in the sinkhole.
* Modified `dnsmasq` called **FTLDNS** acts as caching and forwarding DNS server

## Installation

Installation is supported on multiple Linux distributions including
Debian/Ubuntu and Fedora/CentOS. Furthermore an official Docker container image
is supported.

### Script

Using the official installation script [piiss].

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
end
EOF
vagrant up && vagrant ssh
```

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

Deployment using the official docker container [dkpic]

```bash
# install Docker (Debian packages) 
apt-get install -y docker docker-compose
# download a docker configuration file
wget -O docker-compose.yml \
      https://raw.githubusercontent.com/pi-hole/docker-pi-hole/master/docker-compose.yml.example
sudo su 
# start the docker container
docker-compose up --detach
# find the randomly generated admin password
docker logs pihole | grep random
# use the `pihole` command in the container
docker exec pihole pihole SUBCOMMAND
# start a shell in the container
docker exec -it pihole bash
```

* Customize the configuration with [environment variables][01].
* Cf. [Docker DHCP and Network Modes][03] depending on the deployment scenario

Vagrant box with docker container:

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
  config.vm.provision "shell" do |s|
    s.privileged = true,
    s.inline = <<-SCRIPT
      apt-get update
      apt-get install -y docker docker-compose
    SCRIPT
  end
end
EOF
vagrant up && vagrant ssh
```




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

[adfho] AdGuard Home (Pi-hole alternative)  
<https://adguard.com/en/adguard-home/overview.html>  
<https://github.com/AdguardTeam/AdguardHome>

[blpah] Blocklists for Pihole and Adguard Home  
<https://blocklists.info>

[blsbh] Default Blocklist by Steven Black  
<https://github.com/StevenBlack/hosts>

[dkpic] Docker Pi-hole Container  
<https://hub.docker.com/r/pihole/pihole>  
<https://github.com/pi-hole/docker-pi-hole>

[osdib] Official OISD Blocklist  
<https://oisd.nl/>

[picwr] Pi-hole Community Resources  
<https://pi-hole.net/>  
<https://docs.pi-hole.net/>  
<https://github.com/pi-hole/pi-hole>

[piiss] Pi-hole Installation Script  
<https://github.com/pi-hole/pi-hole/#one-step-automated-install>
<https://github.com/pi-hole/pi-hole/blob/master/automated%20install/basic-install.sh>

[rcdns] Unbound Recursive, Caching DNS Resolver  
<https://nlnetlabs.nl/projects/unbound>  
<https://github.com/NLnetLabs/unbound>  
<https://docs.pi-hole.net/guides/dns/unbound>

[slcrp] How to Setup Pi-hole on a Local Computer without Raspberry Pi  
<https://pawelurbanek.com/pihole-local-computer>

[tbpib] The Best PiHole Blocklists, 2021/04  
<https://avoidthehack.com/best-pihole-blocklists>

[udsrp] Pihole + unbound docker setup on Raspberry Pi, 2020/09  
<https://www.xfelix.com/2020/09/pihole-unbound-docker-setup-on-raspberry-pi>

[01]: https://github.com/pi-hole/docker-pi-hole/#environment-variables
[02]: https://docs.pi-hole.net/guides/dns/upstream-dns-providers/
[03]: https://docs.pi-hole.net/docker/dhcp
[04]: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
