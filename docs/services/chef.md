


# Chef

* Framework for defining **infrastructure as code** 
  - Programmatically provision & configure components
  - Treated like any other code base (stored in version control)
  - Reconstruct service from code, data backup, and compute resources
* Written in Ruby (DSL), open source (Apache License 2.0) 
  - Provides a **domain-specific language** (DSL) to specify **policies** (desired state of a system)
  - Policy describes the desired state (statically or dynamically defined)
  - **Extensible** (cookbooks, recipes, etc)
  -  RESTful API (key-based auth with signed headers)
* **Idempotent** (chef-client), pulls conf. policy from Chef server
  - Configuration code ensures all nodes comply with policy (determined by run-list)
  - **Declarative** interface describes desired state of compute resources

Fundamental building blocks:

* **Resources** describe desired state of system component, i.e. packages, services, users, cf. [Resources Reference](https://docs.chef.io/resource_reference.html)
* A **recipe** is a collection of resources 
  - Configure a single system component
  - Order matters (resources applied in order)
* A **cookbook** is a group(/package) of recipes with a common configuration domain
  - Distribution unit (synced with the server)
  - Versioned, re-usable
  - Includes templates, (meta-)data
* A **role** is a configuration applied to multiple nodes
* Data bags store global variables (secrets)
* [Environments](https://docs.chef.io/environments.html) map a workflow (i.e. production, staging, testing) within an organisation


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

Install [chef package](https://downloads.chef.io/chef) including [chef-client](https://docs.chef.io/ctl_chef_client.html):

```bash
## Debian Stretch (using the Jessie package)
wget https://packages.chef.io/files/stable/chef/14.7.17/debian/9/chef_14.7.17-1_amd64.deb
dpkg -i chef_14.7.17-1_amd64.deb
## CentOS 7
wget https://packages.chef.io/files/stable/chef/14.7.17/el/7/chef-14.7.17-1.el7.x86_64.rpm
yum install -y chef-14.7.17-1.el7.x86_64.rpm
```

**`chef-client`** (on managed nodes):

* Runs `ohai` & builds node attributes
* Connects to the server (registers & syncs cookbooks, etc.)
* Compiles resources (libs, attr., recipes)
* Converges (resources & providers)
* Saves node & runs handlers

[Run list](https://docs.chef.io/run_lists.html), ordered collection of policies

* Obtained from the Chef server
* Used to ensure node compliance

### Configuration

Customize the [client.rb](https://docs.chef.io/config_rb_client.html) configuration file:

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


## Server

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

Manage services:

```bash
chef-server-ctl service-list
chef-server-ctl hup|int|kill|once|restart|start|stop|tail|term [<service>]
```

List of services:

* bifrost - authorize requests to the Chef server
* bookshelf - stores cookbooks (and all associated objects)
* nginx - HTTP API Chef server
* opscode-erchef - service that is used to handle Chef server API requests
* opscode-expander - process data pulled from the rabbitmq, to be indexed by the opscode-solr4 service
* opscode-solr4 - service is used to create the search indexes used for searching objects
* postgresql - database to store node, object, and user data
* rabbitmq - message queue that is used by the Chef server to get search data to Apache Solr
* redis-lb - key-value store used in conjunction with Nginx to route requests and populate request data

Other Chef server implementations:

* [goiardi](https://github.com/ctdk/goiardi)
* [chef-zero](https://github.com/chef/chef-zero)

### RBAC (role-based access control) 

<https://docs.chef.io/server_orgs.html>

* **organization** - top-level entity, contains the default groups (admins, clients, users, etc.)
* **group** - define access to objects and tasks (users inherit group permissions)
* **user** - (non-administrator) manage data that is uploaded (may access web  UI)
* **client** - actor that has permission to access server, usually a client node

```bash
chef-server-ctl user-list
chef-server-ctl user-create <user> <name> <name> <email> <password> -f /path/to/user.pem
chef-server-ctl list-user-keys <user> --verbose
chef-server-ctl delete-user-key <user> <key>
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

# References

CINC, free distribution of Chef  
<https://cinc.sh/>
