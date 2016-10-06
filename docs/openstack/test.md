
Use Stretch, however if Jessie is required: 

```bash
echo "export DEBIAN_FRONTEND=noninteractive" >> ~/.bashrc && source ~/.bashrc
                                                              # non-interactive package deployment by default
echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
                                                              # add backports repository
echo -e "Package: *\nPin: release a=jessie-backports\nPin-Priority: 600" > /etc/apt/preferences.d/backport.pref
                                                              # backports with high priority
apt update && apt -y upgrade                                  
```

Preconditions:

```bash
apt -y install mysql-server python-pymysql rabbitmq-server memcached python-memcache augeas-tools
echo "export CONTROLLER_IPADDRESS=$(ip route get 1 | head -1 | cut -d' ' -f8)" >> ~/.bashrc && source ~/.bashrc
# replace with /etc/mysql/conf.d/openstack.cnf for jessie
cat > /etc/mysql/mysql.conf.d/openstack.cnf <<EOF
[mysqld]
bind-address = $CONTROLLER_IPADDRESS
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
systemctl restart mysql && systemctl status mysql
echo "export RABBITMQ_PASS=$(openssl rand -hex 10)" >> ~/.bashrc && source ~/.bashrc
rabbitmqctl add_user openstack $RABBITMQ_PASS               # create an openstack user
rabbitmqctl set_permissions openstack ".*" ".*" ".*"        # grant write/read access
augtool -sb set /files/etc/memcached.conf/l $CONTROLLER_IPADDRESS
systemctl restart memcached && systemctl status memcached   # configure Memcached and restart
```

### Identity Service

```bash
apt -y install keystone apache2 libapache2-mod-wsgi
echo "export KEYSTONE_DBPASS=$(openssl rand -hex 10)" >> ~/.bashrc && source ~/.bashrc
alias mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
mysql -e "CREATE DATABASE keystone;"                        # create a new database for Keystone
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';"
augtool -sb set /files/etc/keystone/keystone.conf/database/connection "mysql+pymysql://keystone:$KEYSTONE_DBPASS@$CONTROLLER_IPADDRESS/keystone"
augtool -sb set /files/etc/keystone/keystone.conf/token/provider fernet
su -s /bin/sh -c "keystone-manage db_sync" keystone         # populate the Identity service database
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
                                                            # initialize keys
a2ensite wsgi-keystone && systemctl restart apache2         # enable the apache configuration for keystone
```

Configuration:

```bash
export OS_TOKEN=$(augtool print /files/etc/keystone/keystone.conf/DEFAULT/admin_token | tr -d ' "' | cut -d= -f2)
export OS_URL=http://$CONTROLLER_IPADDRESS:35357/v3
export OS_IDENTITY_API_VERSION=3
openstack service create --name keystone --description "OpenStack Identity" identity  # create a service entity
# create admin, internal, and public API endpoints
openstack endpoint create --region RegionOne identity public http://$CONTROLLER_IPADDRESS:5000/v3
openstack endpoint create --region RegionOne identity internal http://$CONTROLLER_IPADDRESS:5000/v3
openstack endpoint create --region RegionOne identity admin http://$CONTROLLER_IPADDRESS:35357/v3
# create a domain, projects, users, and roles
openstack domain create --description "Default Domain" default
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --password-prompt admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password-prompt demo
openstack role create user
openstack role add --project demo --user demo user
```

Verify operation by requesting authentication tokens

```bash
openstack --os-auth-url $OS_URL --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin token issue
openstack --os-auth-url $OS_URL --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo token issue
# write the user environments to files
cat > ~/admin-openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_AUTH_URL=$OS_URL
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
cat > ~/demo-openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=demo
export OS_AUTH_URL=$OS_URL
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
source ~/admin-openrc ; openstack token issue
```


### Image Service

Prerequisites:

```bash
echo "export GLANCE_DBPASS=$(openssl rand -hex 10)" >> ~/.bashrc && source ~/.bashrc
mysql -e 'CREATE DATABASE glance;'
mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';"
source admin-openrc
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://$CONTROLLER_IPADDRESS:9292
openstack endpoint create --region RegionOne image internal http://$CONTROLLER_IPADDRESS:9292
openstack endpoint create --region RegionOne image admin http://$CONTROLLER_IPADDRESS:9292
```

Deployment:

```bash
apt -y install glance                                      
function agset { augtool -t 'PythonPaste incl /etc/glance/glance*.conf' -sb set /files/etc/glance/$@ ; }
                                                        # handy function to write the configuration with Augeas
agset glance-api.conf/database/connection "mysql+pymysql://glance:$GLANCE_DBPASS@$CONTROLLER_IPADDRESS/glance"
                                                        # configure database access
agset glance-api.conf/keystone_authtoken/auth_uri http://$CONTROLLER_IPADDRESS:5000
agset glance-api.conf/keystone_authtoken/auth_url http://$CONTROLLER_IPADDRESS:35357
agset glance-api.conf/keystone_authtoken/memcached_server $CONTROLLER_IPADDRESS:11211
                                                        # configure Identity service access
agset glance-api.conf/keystone_authtoken/auth_type password
agset glance-api.conf/keystone_authtoken/project_domain_name default
agset glance-api.conf/keystone_authtoken/user_domain_name default
agset glance-api.conf/keystone_authtoken/project_name service
agset glance-api.conf/keystone_authtoken/username glance
agset glance-api.conf/keystone_authtoken/password glance
agset glance-api.conf/paste_deploy/flavor keystone      
agset glance-api.conf/glance_store/stores file,http     # configure the local file system store and location of image files
agset glance-api.conf/glance_store/default_store file
agset glance-api.conf/glance_store/filesystem_store_datadir /var/lib/glance/images/
agset glance-registry.conf/database/connection mysql+pymysql://glance:$GLANCE_DBPASS@$CONTROLLER_IPADDRESS/glance
                                                        # configure the registry
agset glance-registry.conf/keystone_authtoken/auth_uri http://$CONTROLLER_IPADDRESS:5000
agset glance-registry.conf/keystone_authtoken/auth_url http://$CONTROLLER_IPADDRESS:35357
agset glance-registry.conf/keystone_authtoken/memcached_server $CONTROLLER_IPADDRESS:11211
                                                        # configure Identity service access
agset glance-registry.conf/keystone_authtoken/auth_type password
agset glance-registry.conf/keystone_authtoken/project_domain_name default
agset glance-registry.conf/keystone_authtoken/user_domain_name default
agset glance-registry.conf/keystone_authtoken/project_name service
agset glance-registry.conf/keystone_authtoken/username glance
agset glance-registry.conf/keystone_authtoken/password glance
agset glance-registry.conf/paste_deploy/flavor keystone      
```

[1]: http://docs.openstack.org/draft/install-guide-debian/
