

Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

# Deployment

## Account Database

Create a virtual machine to host the database server called **lxdb01.devops.test**

    » virsh-instance -O shadow debian64-9 lxdb01.devops.test
    » cd $VM_INSTANCE_PATH/lxdb01.devops.test
    » ssh-exec -s 'hostname lxdb01 ; hostname -f'

Deploy role [account_database][account_database.rb], to install a MySQL database. 

    » chef-remote cookbook sys 
    » chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/account_database.rb
    » chef-remote -r "role[account_database]" solo

Grant the `slurm` user access to the database

    » ssh-exec -r 'sed -i "s/^bind-address/#bind-address/" /etc/mysql/mysql.conf.d/mysqld.cnf'
    » ssh-exec -r "grep -e '^user' -e '^password' /etc/mysql/debian.cnf"
    » ssh-exec -r "mysql -u debian-sys-maint -p"
    mysql> grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by '12345678' with grant option;
    mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01' identified by '12345678' with grant option;
    mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01.devops.test' identified by '12345678' with grant option;
    mysql> select User,Host from mysql.user where User = 'slurm';
    […]
    mysql> quit
    » ssh-exec -r 'systemctl restart mysql'

## Cluster Controller

Create a virtual machine to host the Slurm cluster controller called **lxrm01.devops.test** 

    » virsh-instance -O shadow debian64-9 lxrm01.devops.test
    » slurm-cc() { cd $VM_INSTANCE_PATH/lxrm01.devops.test ; ssh-exec -s $@ ; cd - >/dev/null }
    » slurm-cc 'hostname lxrm01 ; hostname -f'

Deploy role [cluster_controller][cluster_controller.rb], to install slurmctld, and slurmdbd

    » cd $VM_INSTANCE_PATH/lxrm01.devops.test
    » chef-remote cookbook sys 
    » chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/cluster_controller.rb
    » chef-remote -r "role[cluster_controller]" solo

Deploy a basic Slurm configuration from [slurm/basis][slurm_basic]

    » slurm-cc -r 'systemctl restart munge nfs-kernel-server ; exportfs -r && exportfs'
    » ssh-sync -r $SCRIPTS/var/slurm/basic/ :/etc/slurm-llnl
    » slurm-cc 'systemctl restart slurmdbd'

Configure the accounting, and allow job execution with the `devops` user:

    » slurm-cc 'sacctmgr -i add cluster vega --immediate'
    » slurm-cc 'sacctmgr add account hpc description=hpc organization=hpc --immediate'
    » slurm-cc 'sacctmgr create user name=devops account=hpc defaultaccount=hpc --immediate'

Start the controller:

    » slurm-cc 'systemctl restart slurmctld'
    » slurm-cc sinfo

## Execution Nodes

Create a couple a virtual machines for the execution nodes called **lxb00[1,4].devops.test**

    » NODES lxb00[1-4] 
    » nodeset-loop "virsh-instance -O shadow debian64-9 {}.devops.test"
    » nodeset-loop "cd $VM_INSTANCE_PATH/{}.devops.test ; ssh-exec -s 'hostname {} ; hostname -f' ; cd -"

Deploy the Chef role [execution_node][execution_node.rb] to install _slurmd_

    » slurm-en() { for d in $VM_INSTANCE_PATH/lxb* ; do cd $d ; $@ ; cd - >/dev/null ; done }
    » slurm-en-exec() { slurm-en ssh-exec -s $@ }
    » slurm-en chef-remote cookbook sys
    » slurm-en chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/execution_node.rb
    » slurm-en chef-remote -r "role[execution_node]" solo
    » slurm-en ssh-exec -s 'systemctl restart munge slurmd'

# Configuration

Slurm has the capability to simulate resources on execution nodes for testing:

* Set `FastSchedule=2` in order to emulate nodes with more resources then physically available by defining them with NodeName.
* Set `ReturnToService=1` to prevent nodes from been set to state down due to limitations like "low memory". This can help to emulate non existed memory resources on test nodes. 

# Tests

Make sure `stress` is installed on all execution nodes, and copy the job helper script [slurm-stress][slurm_stress] into the home directory of the devops user:

    » slurm-en-exec 'apt install stress'
    » cd $VM_INSTANCE_PATH/lxrm01.devops.test && ssh-sync $SCRIPTS/bin/slurm-stress : && ssh-exec

Execute jobs:

    » sbatch -D /tmp slurm-stress 60s 1 256
    […]
    » sbatch -n 64 --mem-per-cpu=4096 slurm-stree 300s 64 4G
    […]


[slurm_basic]: ../../var/slurm/basic/slurm.conf
[slurm_stress]: ../../bin/slurm-stress
[account_database.rb]: ../../var/chef/roles/debian/jessie/account_database.rb
[cluster_controller.rb]: ../../var/chef/roles/debian/jessie/cluster_controller.rb
[execution_node.rb]: ../../var/chef/roles/debian/jessie/execution_node.rb
