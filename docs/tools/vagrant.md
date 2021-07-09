# Vagrant


Quickstart with `libvirt`:

```bash
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-mutate
vagrant plugin list
vagrant box add centos/7 --provider=libvirt
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

Change the default provider with an environment variable:

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

## Provisioning

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

