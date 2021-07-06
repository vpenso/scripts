# Vagrant

Quickstart after installation with `libvirt`:

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

**Boxes** package format for Vagrant environments

<https://app.vagrantup.com/boxes/search>

```bash
vagrant box list
# download a specific version
vagrant box add centos/stream8 --box-version 20210210.0 --provider libvirt
vagrant box remove centos/7
```

```bash
vagrant up           # start machine (described in Vagrantfile)
vagrant status       # state of the machines
vagrant halt         # stop machine, keep environment (for later use)
vagrant destroy      # remove machine, discard environment
```

SSH into a running Vagrant machine

```bash
vagrant ssh          # login
vagrant ssh-config   # show SSH configuration
```

# Usage

`Vagrantfile`...

* ...is Ruby syntax
* ...configure and provision these machines
* ...uses one file per project
* ...commit to version control


