# Vagrant


Quickstart with `libvirt`:

```bash
# install libvirt & vagrant on Debian/Ubuntu
sudo apt-get install libvirt-daemon-system vagrant vagrant-libvirt vagrant-mutate
# alternativly install libvirt support with the plugin sub-command
vagrant plugin install vagrant-libvirt
vagrant plugin list
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

**Boxes**

* Virtual machine images use a clone templates
* Dedicated box storage for each user

<https://app.vagrantup.com/boxes/search>

```bash
# list localy available boxes
vagrant box list
# download a specific version
vagrant box add centos/stream8 --box-version 20210210.0
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
vagrant status           # state of the machines
vagrant halt             # stop machine, keep environment (for later use)
vagrant destroy          # remove machine, discard environment
```

SSH into a running Vagrant machine

```bash
vagrant ssh          # login
vagrant ssh-config   # show SSH configuration
# copy a file
vagrant ssh-config > ssh-config
scp -F ssh-config vagrant@${name:-default}:/bin/bash /tmp
```

## Multiple Boxes

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

## Provisioning

<https://www.vagrantup.com/docs/provisioning>

`shell` and `file` provisioner:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
mkdir projects
cd projects
git clone https://github.com/vpenso/scripts.git
SCRIPT

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

  # execute a script defined as here-document
  config.vm.provision "shell", inline: $script
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
