
# Deployment & Configuration

## Account Database

Create a virtual machine to host the database server called **lxdb01.devops.test**

    » virsh-instance -O shadow debian64-8 lxdb01.devops.test
    » cd $VM_INSTANCE_PATH/lxdb01.devops.test
    » ssh-exec -s 'hostname lxdb01 ; hostname -f'

Deploy role [account_database][2], to install a MySQL database. 

    » chef-remote cookbook sys 
    » chef-remote role $SCRIPTS/var/chef/roles/debian/jessie/account_database.rb
    » chef-remote -r "role[account_database]" solo

Grant the `slurm` user access to the database

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

    » virsh-instance -O shadow debian64-8 lxrm01.devops.test
    » cd $VM_INSTANCE_PATH/lxrm01.devops.test
    » ssh-exec -s 'hostname lxrm01 ; hostname -f'

Deploy role [cluster_controller][3], to install slurmctld, and slurmdbd

    » chef-remote cookbook sys 
    » chef-remote role $SCRIPTS/var/chef/roles/debian/jessie/cluster_controller.rb
    » chef-remote -r "role[cluster_controller]" solo
    » ssh-exec -r 'systemctl restart munge nfs-kernel-server ; exportfs -r && exportfs'

Deploy a basic Slurm configuration from [slurm/basis][4]

    » ssh-sync -r $SCRIPTS/var/slurm/basic/ :/etc/slurm-llnl
    » ssh-exec -r 'systemctl restart slurmdbd slurmctld'
    » ssh-exec -r sinfo

## Execution Nodes

Create a couple a virtual machines for the execution nodes called **lxb00[1,4].devops.test**

    » NODES lxb00[1-4] 
    » nodeset-loop "virsh-instance -O shadow debian64-8 {}.devops.test"
    » nodeset-loop "cd $VM_INSTANCE_PATH/{}.devops.test ; ssh-exec -s 'hostname {} ; hostname -f' ; cd -"

Deploy the Chef role [execution_node][5] to install _slurmd_

    » lxb-loop() { for d in $VM_INSTANCE_PATH/lxb* ; do cd $d ; $@ ; cd - >/dev/null ; done }
    » lxb-loop chef-remote cookbook sys
    » lxb-loop chef-remote role $SCRIPTS/var/chef/roles/debian/jessie/execution_node.rb
    » lxb-loop chef-remote -r "role[execution_node]" solo
    » lxb-loop ssh-exec -s 'systemctl restart munge slurmd'


[1]: ../libvirt.md
[2]: ../../var/chef/roles/debian/jessie/account_database.rb
[3]: ../../var/chef/roles/debian/jessie/cluster_controller.rb
[4]: ../../var/slurm/basic/
[5]: ../../var/chef/roles/debian/jessie/execution_node.rb
[6]: http://slurm.schedmd.com/documentation.html
