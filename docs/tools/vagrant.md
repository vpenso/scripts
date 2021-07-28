# Vagrant

Command line utility for managing the life cycle of virtual machines.

### Providers

Providers interface with different virtual machine monitors (aka. hypervisors).
By default Vagrant uses VirtualBox:

```bash
# install VirtualBox and vagrant on Ubuntu/Debian
sudo apt install -y virtualbox vagrant
```

Alternatively use `libvirt`:

```bash
# install libvirt & vagrant on Debian/Ubuntu
sudo apt-get install libvirt-daemon-system vagrant vagrant-libvirt vagrant-mutate
# download the offical CentOS 7 box
vagrant box add centos/7 --provider=libvirt
# create a Vagrantfile configuration and start a box
cd $(mktemp -d)
cat > Vagrantfile <<EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "centos7" do |config|
  config.vm.hostname = "centos7"
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.18.9"
  config.vm.provider :libvirt do |v|
    v.memory = 1024
    end
  end
end
EOF
vagrant up
```

Configure the default provider with an environment variable:

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

### Boxes

* Virtual machine images use a clone templates
* Dedicated box storage for each user
* Vagrant boxes are all provider-specific
  - A box must be installed for each provider
  - Can share the same name as long as the providers differ

<https://app.vagrantup.com/boxes/search>

```bash
# list localy available boxes
vagrant box list
# download a specific version
vagrant box add centos/stream8 --box-version 20210210.0
# download for a specific provider
vagrant box add centos/7 --provider=libvirt
vagrant box remove centos/7
# convert a VirtualBox image [vgpmu]
vagrant box add ubuntu/focal64
vagrant mutate ubuntu/focal64 libvirt
```

`Vagrantfile`...

* ...configure provisioning of a virtual machine
* ...Ruby syntax
* ...use one file per project
* ...commit to version control

```bash
vagrant init centos/7    # create a ./Vagrantfile
vagrant validate         # check ./Vagrantfile
vagrant up               # start machine (described in Vagrantfile)
vagrant up --provider=libvirt
vagrant status           # state of the machines
vagrant halt             # stop machine, keep environment (for later use)
vagrant destroy          # remove machine, discard environment
```


Configure multiple nodes with the same configuration:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes = [ 'alpha', 'beta' ]
  (0..(nodes.length - 1)).each do |num|
    name = nodes[num]
    config.vm.define "#{name}" do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: "192.168.18.#{10+num}"
    end
  end
end
```

Use names to operate on a specific box:

```bash
vagrant up alpha       # start specifc box
vagrant ssh alpha      # login to a box
vagrant destroy alpha  # remove a box 
```

### SSH

Login to a running box:

```bash
vagrant ssh ${name:-}
```

Append commands to be executed:

```bash
vagrand ssh ${name:-} -- ls -l
```

Use `ssh-config` to copy files from localhost with `scp`

```bash
vagrant ssh-config > ssh-config
scp -F ssh-config vagrant@${name:-default}:/bin/bash /tmp
```

### Networking

Typically virtual machines are given a private network address:

* Multiple machines can shared the same sub-network
* Configuration of IP address can be static of via DHCP

```bash
# automatic assignment of IP via DHCP
config.vm.network "private_network", type: "dhcp"
# specify a static IP for the machine
config.vm.network "private_network", ip: "192.168.50.4"
```

[Forwarded Ports](https://www.vagrantup.com/docs/networking/forwarded_ports):

```bash
# change the default port got the SSH connection
config.vm.network "forwarded_port", id: "ssh", host: 2200, guest: 22
```

### Synced Folders

By default the project directory is shared to `/vagrant`

```bash
# Disabling the default /vagrant share
config.vm.synced_folder ".", "/vagrant", disabled: true
```

## Provisioning

<https://www.vagrantup.com/docs/provisioning>

`shell` and `file` provisioner:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

content = 'write this to a file'

script = %q(
mkdir ~/projects
echo "foo'bar" > ~/projects/bar.txt
)

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # run a command as root
  config.vm.provision "shell" do |s|
    s.inline = "yum install -y git vim"
    s.privileged = true
  end

  # copy multiple files
  [
    ".gitconfig",
    ".gitignore_global"
  ].each do |file|
     config.vm.provision "file", source: "~/#{file}", destination: file
  end

  # variable expansion...
  config.vm.provision "shell",
    inline: %Q(echo "#{content}" > /tmp/content.txt)

  # execute multiline string as script
  config.vm.provision "shell", inline: script
end
```


### Chef

Configure provisioning with Chef:

```ruby
config.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "#{ENV['HOME']}/chef/cookbooks"
      chef.roles_path = "#{ENV['HOME']}/chef/roles"
      chef.add_role "role"
      chef.add_recipe "recipe"
      chef.json = { "key" => "value" }
end
```

Run provisioning:

```bash
vagrant up             # implicitly runs provisioning
vagrant up --no-provision
vagrant provision      # provision a running environment
vagrant reload --provision
```

## References

[vgpmu] Vagrant Plugin Mutate  
<https://github.com/sciurus/vagrant-mutate>
