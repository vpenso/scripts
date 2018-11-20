


# Chef

<https://downloads.chef.io/chef>

Client:

```bash
## Debian Stretch (using the Jessie package)
wget https://packages.chef.io/files/stable/chef/14.7.17/debian/9/chef_14.7.17-1_amd64.deb
dpkg -i chef_14.7.17-1_amd64.deb
## CentOS 7
wget https://packages.chef.io/files/stable/chef/14.7.17/el/7/chef-14.7.17-1.el7.x86_64.rpm
yum install -y chef-14.7.17-1.el7.x86_64.rpm
```


## Knife

Configure [Knife](https://docs.chef.io/knife.html) for the devops user:

```bash
~/.chef/knife.rb         user specific configuration file
knife configure ...      generate a configuration file
```

A Knife configuration may look like:

```bash
>>> cat .chef/knife.rb
log_level                :info
log_location             STDOUT
node_name                "#{ENV['USER']}"
client_key               "~/.chef/#{ENV['USER']}.pem"
chef_server_url          'https://lxrm01.devops.test/organizations/devops'
ssl_verify_mode          :verify_none
cache_type               'BasicFile'
cache_options( :path => "~/.chef/checksums" )
cookbook_path            ["~/chef/cookbooks"]
```

Query Chefs index (infrastructure inventory) for nodes attributes, e.g.: 

```bash
knife search node "role:<foo>"    # node with a specific role
knife search node "role:<foo> AND role:<bar>" -a <attribute>
knife search node "name:<foo>*" -Fj -a ipaddress
```

### Bootstrap

Knife [bootstrap](https://docs.chef.io/knife_bootstrap.html) installs and configures the chef-client on a remote node.

Template example `~/.chef/bootstrap/default.erb` (cf. [chef-full.erb](https://github.com/chef/chef/blob/master/lib/chef/knife/bootstrap/templates/chef-full.erb)):

```
bash -c '

echo "Writing configuration to /etc/chef"
mkdir -p /etc/chef

<% if client_pem -%>
cat > /etc/chef/client.pem <<'EOP'
<%= ::File.read(::File.expand_path(client_pem)) %>
EOP
chmod 0600 /etc/chef/client.pem
<% end -%>

chmod 0600 /etc/chef/validation.pem
cat > /etc/chef/client.rb <<'EOP'
<%= config_content.concat "\nssl_verify_mode :verify_none" %>
EOP

cat > /etc/chef/first-boot.json <<'EOP'
<%= first_boot.to_json %>
EOP

echo "Starting first Chef Client run..."
<%= start_chef %>

'
```

Bootstrap a node with a given template

```bash
# configure and execute chef-client
knife bootstrap -N $fqdn $fqdn --bootstrap-template default
# prepare cookbook & role for chef-client configuration
mkdir -p chef/cookbooks
git clone https://github.com/vpenso/chef-base.git chef/cookbooks/base
knife cookbook upload base
knife role from file ~/chef/cookbooks/base/test/roles/chef_client.rb
# configure/execute chef-client to use a given role
knife bootstrap -N $fqdn $fqdn --bootstrap-template default -r 'role[chef_client]'
```

## Client

Official documentation from [docs.chef.io](http://docs.chef.io):

→ [chef-client](https://docs.chef.io/ctl_chef_client.html)  
→ [client.rb](https://docs.chef.io/config_rb_client.html)

### Manual

Chef-client configuration file example:

```bash
>>> cat /etc/chef/client.rb
node_name              "#{`hostname -f`.strip}"
chef_server_url        'https://lxrm01.devops.test/organizations/devops'
client_key             '/etc/chef/client.pem'
ssl_verify_mode        :verify_none
validation_client_name 'devops-validator'
validation_key         '/etc/chef/devops.pem'
log_level              :fatal
log_location           STDOUT
file_backup_path       '/var/backups/chef'
file_cache_path        '/var/cache/chef'
>>> chef-client -c /etc/chef/client.rb # test if the configuration is working
```

Systemd configuration to execute the chef-client periodically:

```bash
## Service unit file
>>> cat /etc/systemd/system/chef-client.service
[Unit]
Description=Chef Client daemon
After=network.target auditd.service

[Service]
Type=oneshot
ExecStart=/opt/chef/embedded/bin/ruby /usr/bin/chef-client -c /etc/chef/client.rb -L /var/log/chef-client.log
ExecReload=/bin/kill -HUP $MAINPID
SuccessExitStatus=3

[Install]
WantedBy=multi-user.target
## Timer unit file
>>> cat /etc/systemd/system/chef-client.timer
[Unit]
Description=Chef Client periodic execution

[Install]
WantedBy=timers.target

[Timer]
OnBootSec=1min
OnUnitActiveSec=1800sec
AccuracySec=300sec
## Enable periodic execution 
>>> systemctl start chef-client.timer && systemctl enable chef-client.timer
```


# Server

Dummy deployment for a [chef-server-core](https://downloads.chef.io/chef-server) package:

<https://docs.chef.io/install_server.html>

```bash
wget https://packages.chef.io/files/stable/chef-server/12.18.14/el/7/chef-server-core-12.18.14-1.el7.x86_64.rpm
yum install -y chef-server-core-12.18.14-1.el7.x86_64.rpm
# configure the chef server
chef-server-ctl reconfigure
## open the firewall
firewall-cmd --permanent --zone public --add-service http
firewall-cmd --permanent --zone public --add-service https
firewall-cmd --reload
```

RBAC (role-based access control) to restrict access to objects:

<https://docs.chef.io/server_orgs.html>

* **organization** - top-level entity, contains the default groups (admins, clients, users, etc.)
* **group** - define access to objects and tasks (users inherit group permissions)
* **user** - (non-administrator) manage data that is uploaded (may access web  UI)
* **client** - actor that has permission to access server, usually a client node

```bash
chef-server-ctl user-list
chef-server-ctl org-list
chef-server-ctl org-show <name>
chef-server-ctl org-create <name> "<desc>" [--association_user <admin> --filename /path/to/validator.pem]
chef-server-ctl org-delete <name>
chef-server-ctl org-user-add <name> <user> [--admin]
chef-server-ctl org-user-remove <name> <user>
```

Example of creating a organisation `devops` with an admin user `devops`:

```bash
su devops -c 'mkdir ~/.chef'
chef-server-ctl user-create devops dev ops dops@devops.test 'devops' --filename /home/devops/.chef/devops.pem
chef-server-ctl org-create devops 'devops people' --association_user devops --filename /etc/chef/devops-validator.pem
```

**server admins** create, read, update, and delete user accounts with `knife user` (`pivotal` (a superuser account))

```bash
chef-server-ctl grant-server-admin-permissions <user>
chef-server-ctl list-server-admins
chef-server-ctl remove-server-admin-permissions <user?
```


