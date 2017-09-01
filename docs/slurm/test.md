
Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

Slurm has the capability to simulate resources on execution nodes for testing:

* Set `FastSchedule=2` in order to emulate nodes with more resources then physically available by defining them with NodeName.
* Set `ReturnToService=1` to prevent nodes from been set to state down due to limitations like "low memory". This can help to emulate non existed memory resources on test nodes. 

**Slurm configuration files are located in [var/slurm/][slurm_basic].**

# Deployment

Local CentOS mirror and [package repository](../rpm.md) server:

* The following example uses the [chef-base](https://github.com/vpenso/chef-base) cookbook.
* Build the server using the Chef roles [yum_mirror](https://github.com/vpenso/chef-base/blob/master/test/roles/yum_mirror.rb) and [yum_repo](https://github.com/vpenso/chef-base/blob/master/test/roles/yum_repo.rb)
* Build and the Slurm RPM packages to upload them to the local package repository (cf. [slurm/deploy](deploy.md), [rpm](../rpm.md))

```bash
>>> vi sh centos7 lxrepo01 && vm cd lxrepo01
>>> chef-remote cookbook base
>>> chef-remote role ~/projects/chef/cookbooks/base/test/roles/yum_mirror.rb
>>> chef-remote role ~/projects/chef/cookbooks/base/test/roles/yum_repo.rb
>>> chef-remote -r "role[yum_repo]" solo
>>> ssh-exec -r  # login to the node
# Download all required RPM packages to the local repository
>>> scp lxdev01:/root/rpmbuild/RPMS/x86_64/* /var/www/html/repo
>>> createrepo --update /var/www/html/repo/
```

Start all required virtual machine instances (cf. [clush](../clush.md)):

```bash
>>> NODES lxrm01,lxdb01,lxb[001-004]
>>> nodeset-loop "virsh-instance remove {}" # clean up if requried
## for CentOS nodes
>>> nodeset-loop "virsh-instance shadow centos7 {}"
## for Debian nodes
>>> nodeset-loop "virsh-instance shadow debian9 {}"
nodeset-loop "virsh-instance exec {} 'echo {} > /etc/hostname ; hostname {} ; hostname -f'"
## basic node setup...
>>> vm l        
 Id    Name                           State
----------------------------------------------------
 4     lxrepo01.devops.test           running
 6     lxb001.devops.test             running
 7     lxb002.devops.test             running
 8     lxb003.devops.test             running
 9     lxb004.devops.test             running
 10    lxdb01.devops.test             running
 11    lxrm01.devops.test             running
```

## Account Database

Install and configure a MySQL/MariaDB server:

```bash
>>> vm cd lxdb01
>>> chef-remote cookbook base
```

On Debian 8/9 with use the Chef role [chef/roles/debian/slurm/mariadb.rb](../../var/chef/roles/debian/slurm/mariadb.rb):

```bash
>>> chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/mariadb.rb
```

On CentOS 7 use the chef role [chef-base/test/roles/mariadb.rb](https://github.com/vpenso/chef-base/blob/master/test/roles/mariadb.rb)

```bash
>>> ln -s ~/projects/chef/cookbooks/base/test/roles roles
```

Run Chef

```bash
>>> chef-remote -r "role[mariadb]" solo
```

Prepare the database for Slurm (cf. [deploy.md](deploy.md))

```bash
>>> ssh-exec -r 'mysql -u root'
# ..configure ...
mysql> grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01.devops.test' identified by '12345678' with grant option;
mysql> quit
```

## Cluster Controller


Debian Stretch, Chef role [chef/roles/debian/slurm/slurmctld.rb](../../var/chef/roles/debian/slurm/slurmctld.rb)

```bash
>>> ln -s $SCRIPTS/var/chef/roles/debian/slurm roles
>>> chef-remote cookbook base
>>> chef-remote -r "role[slurmctld]" solo
## ...configure...
>>> virsh-instance exec lxrm01 'systemctl restart munge nfs-kernel-server ; exportfs -r && exportfs'
```

CentOS 7, Chef role [chef-base/blob/master/test/roles/slurmctld.rb](https://github.com/vpenso/chef-base/blob/master/test/roles/slurmctld.rb):

```bash
>>> ln -s ~/projects/chef/cookbooks/base/test/roles roles
>>> chef-remote cookbook base
>>> chef-remote -r "role[slurmctld]" solo
```

Deploy a basic Slurm configuration:

* [slurm.conf](../../var/slurm/slurm.conf)
* [slurmdbd.conf](../../var/slurm/slurmdbd.conf)

```bash
>>> virsh-instance sync lxrm01 $SCRIPTS/var/slurm/ :/etc/slurm
>>> virsh-instance exec lxrm01 'systemctl start slurmdbd'
>>> virsh-instance exec lxrm01 'systemctl start slurmctld && sinfo'
```

Manage the account DB configuration: 

```bash
# load the account configuration
>>> virsh-instance sync lxrm01 $SCRIPTS/var/slurm/accounts.conf :/tmp/
>>> virsh-instance exec lxrm01 'sacctmgr --immediate load /tmp/accounts.conf'
# dump the account configuration
>>> virsh-instance exec lxrm01 'sacctmgr dump vega file=/tmp/accounts.conf'
>>> virsh-instance sync lxrm01 :/tmp/accounts.conf $SCRIPTS/var/slurm/
```

## Execution Nodes

Deploy the Chef role [execution_node][execution_node.rb] to install _slurmd_

```bash
slurm-en() { for n in $(nodeset -e $NODES) ; do cd $VM_INSTANCE_PATH/$n ; $@ ; cd - >/dev/null ; done }
slurm-en-exec() { slurm-en ssh-exec -r $@ }
slurm-en chef-remote cookbook sys
slurm-en chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/execution_node.rb
slurm-en chef-remote -r "role[execution_node]" solo
slurm-en-exec 'systemctl reboot'
```

CentOS 7, [base][base] Chef cookbook, role [slurmd.rb](https://github.com/vpenso/chef-base/blob/master/test/roles/slurmd.rb):

```bash
>>> ln -s ~/projects/chef/cookbooks/base/test/roles roles
>>> chef-remote cookbook base
>>> chef-remote -r "role[slurmd]" solo
```

# Tests

Copy the job helper script [slurm-stress][slurm_stress] into the home directory of a user:

```bash
>>> cd $VM_INSTANCE_PATH/lxrm01.devops.test 
>>> ssh-sync -r $SCRIPTS/bin/slurm-* :/network/spock && ssh-exec -r 'chown spock /network/spock/slurm*'
>>> ssh-exec -r 'su spock -c bash'
[…]
```

Execute jobs:

```bash
>>> cd /network/devops
>>> sbatch slurm-stress 60s 1 128M
[…]
>>> sbatch -n 64 --mem-per-cpu=4096 slurm-stress 300s 64 4G
[…]
```


[sys]: https://github.com/GSI-HPC/sys-chef-cookbook
[base]: https://github.com/vpenso/chef-base
[slurm_stress]: ../../bin/slurm-stress
[execution_node.rb]: ../../var/chef/roles/debian/slurm/execution_node.rb
