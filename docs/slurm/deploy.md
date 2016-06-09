
# Deployment

Official source code archive releases are available at:

<http://www.schedmd.com/#repos>

The official source code repository is on [SchedMD/slurm](https://github.com/SchedMD/slurm), and the primary communication channel to the developers is the [slurm-devel][slurmdevel] mailing list.

Since 2013/12 the version numbers use the format year.month (like Ubuntu). Last version with the old schema is 2.6.7, followed by a new biannual release cycle with version like 14.06 and 14.12. 

## Packages

### Debian

List available packages for all Debian releases with `rmadison` (from the _devscripts_ package):

    » date
    Thu Jun  9 12:34:04 CEST 2016
    » rmadison slurm-wlm
    slurm-wlm  | 14.03.9-5     | stable     | amd64, arm64, armel, armhf, i386, mips, mipsel, powerpc, ppc64el, s390x
    slurm-wlm  | 15.08.11-1    | testing    | arm64, armel, armhf, i386, mips, mipsel, powerpc, ppc64el, s390x
    slurm-wlm  | 15.08.11-1    | unstable   | arm64, armel, armhf, i386, mips, mips64el, mipsel, powerpc, ppc64el, s390x
    slurm-wlm  | 15.08.11-1+b1 | testing    | amd64
    slurm-wlm  | 15.08.11-1+b1 | unstable   | amd64

### CentOS

Build [Munge][munge] RPM packages:

    » yum groupinstall "Development Tools"
    » yum install rpm-build bzip2-devel openssl-devel zlib-devel
    […]
    » wget https://munge.googlecode.com/files/munge-0.5.11.tar.bz2
    […]
    » rpmbuild -tb --clean munge-0.5.11.tar.bz2
    […]
    » ls /root/rpmbuild/RPMS/x86_64/
    munge-0.5.11-1.el6.x86_64.rpm            munge-devel-0.5.11-1.el6.x86_64.rpm
    munge-debuginfo-0.5.11-1.el6.x86_64.rpm  munge-libs-0.5.11-1.el6.x86_64.rpm

Build Slurm RPM packages:

    » rpm -i /root/rpmbuild/RPMS/x86_64/munge-devel-0.5.11-1.el6.x86_64.rpm
    » yum install readline-devel perl-ExtUtils-MakeMaker pam-devel
    […]
    » rpmbuild -tb --clean slurm-14.11.2.tar.bz2
    […]
    » ls -1 /root/rpmbuild/RPMS/x86_64/slurm*
    /root/rpmbuild/RPMS/x86_64/slurm-14.11.2-1.el6.x86_64.rpm
    /root/rpmbuild/RPMS/x86_64/slurm-devel-14.11.2-1.el6.x86_64.rpm
    /root/rpmbuild/RPMS/x86_64/slurm-munge-14.11.2-1.el6.x86_64.rpm
    /root/rpmbuild/RPMS/x86_64/slurm-pam_slurm-14.11.2-1.el6.x86_64.rpm
    /root/rpmbuild/RPMS/x86_64/slurm-perlapi-14.11.2-1.el6.x86_64.rpm
    […]

## Source

### Munge

Build [Munge][munge] from source on Debian:

    » apt-get -y install ca-certificates bzip2 
    […]
    » wget https://munge.googlecode.com/files/munge-0.5.11.tar.bz2
    […]
    » tar -xvjf munge-0.5.11.tar.bz2
    […]
    » apt-get -y install build-essential libgcrypt11-dev libbz2-dev zlib1g-dev
    […]
    » ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
    […]
    » make && make install
    […]

Follow the steps above to…

- [Download][munge] Munge from the developers site.
- Extract the archive.
- Install dependencies.
- Configure, build and install Munge. 

Test Munge after the installation:

    » dd if=/dev/urandom bs=1 count=1024 >/etc/munge/munge.key
    » chmod -R 700 /etc/munge
    » munged -F
    munged: Notice: Running on "wheezy.devops.test" (127.0.1.1)
    munged: Info: PRNG seeded with 1024 bytes from "/dev/urandom"
    munged: Info: Updating supplementary group mapping every 3600 seconds
    munged: Info: Enabled supplementary group mtime check of "/etc/group"
    munged: Info: Removed existing socket "/var/run/munge/munge.socket.2"
    munged: Notice: Starting munge-0.5.11 daemon (pid 14839)
    munged: Info: Created 2 work threads
    munged: Info: Found 1 user with supplementary groups in 0.000 seconds
    […]
    » munge -n | unmunge
    STATUS:           Success (0)
    ENCODE_HOST:      wheezy.devops.test (127.0.1.1)
    ENCODE_TIME:      2013-12-17 15:52:46 +0100 (1387291966)
    DECODE_TIME:      2013-12-17 15:52:46 +0100 (1387291966)
    TTL:              300
    CIPHER:           aes128 (4)
    MAC:              sha1 (3)
    ZIP:              none (0)
    UID:              root (0)
    GID:              root (0)
    LENGTH:           0
    » remunge 
    2013-12-17 15:53:46 Spawning 1 thread for encoding
    2013-12-17 15:53:46 Processing credentials for 1 second
    2013-12-17 15:53:47 Processed 10786 credentials in 1.000s (10783 creds/sec)

Follow these steps…

- Create a MUNGE key in `/etc/munge/munge.key`.
- Start the daemon in foreground with `munged -F`.
- Create a credential with `munge -n` and decode it with `unmunge`.
- Run a performance test with `remunge`. 

Start Munge as a service:

    » useradd --system munge
    » chmod 755 /etc/munge/
    » chown munge:munge /etc/munge/munge.key
    » chmod 400 /etc/munge/munge.key
    » chown munge:munge /var/run/munge/ /var/lib/munge/
    » /etc/init.d/munge start
    » ps -fH -C munged
    UID        PID  PPID  C STIME TTY          TIME CMD
    munge    16618     1  0 16:46 ?        00:00:00 /usr/sbin/munged -F
    » munge -n
    MUNGE:AwQDAAD8XrjJ+QwcjDN[…]

Follow the steps above to…

- Create a munge system users account.
- Adjust the permissions and owner of the MUNGE key `/etc/munge/munge.key`.
- Adjust the owner of directories required by the service `/var/run/munge/` and `/var/lib/munge/`.
- Start the service with and test if it is working. 

### Slurm

    […]
    » wget http://www.schedmd.com/download/archive/slurm-2.6.3.tar.bz2
    […]
    » tar -xvjf slurm-2.6.3.tar.bz2
    […]
    » apt-get install -y python
    […]
    » ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
    […]
    » make && make install
    […]

Follow these steps…

- Download Slurm from the developers site.
- Extract the archive.
- Install dependencies. Configure, build and install SLURM. 

Test Slurm after installation:

    » useradd --system slurm
    » cp etc/slurm.conf.example /etc/slurm.conf
    […]
    » egrep '^ControlMachine|^NodeName|^PartitionName' /etc/slurm/slurm.conf
    ControlMachine=lxdev01
    NodeName=lxdev[02-04] Procs=1 State=UNKNOWN
    PartitionName=debug Nodes=lxdev[02-04] Default=YES MaxTime=INFINITE State=UP
    » slurmctld -D
    […]
    slurmctld: Running as primary controller
    […]
    » sinfo
    PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
    debug*       up   infinite      3    unk lxdev[02-04]

Follow these steps…

- Create a slurm user account.
- Copy the example configuration to `/etc/slurm.conf`.
- Adjust ControlMachine, NodeName, and PartitionName.
- Start the controller daemon in foreground `slurmctld -D`. Query the start from the controller with [sinfo][sinfo]. 

## Slurmctld

Install a cluster controller **slurmctld**:

    » apt install slurmctld
    […]
    » zcat /usr/share/doc/slurm-llnl/examples/slurm.conf.simple.gz > /etc/slurm-llnl/slurm.conf
    […]
    » cat /etc/slurm-llnl/slurm.conf | egrep '^ControlMachine|^NodeName|^PartitionName'
    ControlMachine=lxrm01
    NodeName=lxb[001-004] Procs=1 State=UNKNOWN
    PartitionName=debug Nodes=lxb[001-004] Default=YES MaxTime=INFINITE State=UP
    » create-munge-key
    Generating a pseudo-random key using /dev/urandom completed.
    » service munge start
    Starting MUNGE: munged.
    » service slurm-llnl start
    Starting slurm central management daemon: slurmctld.
    » scontrol show config
    […]
    » sinfo
    PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
    debug*       up   infinite      4    unk lxb[001-004]

- Install the _slurmctld_ package.
- Copy the example configuration to `/etc/slurm-llnl/slurm.conf`.
- Define the controller and execution nodes in the Slurm configuration.
- Execute create-munge-key to generate an authentication key.
- Start the `munge` and `slurmctld` service daemons. 

## Slurmdbd

Copy the default configuration for slurmdbd daemon.

    » apt install slurmdbd 
    » zcat /usr/share/doc/slurmdbd/examples/slurmdbd.conf.simple.gz > /etc/slurm-llnl/slurmdbd.conf


### Database Storage

Install the Slurm database front-end **slurmdbd** and a mysql server on the controller machine. 

```
» apt-get -y install mysql-server
```

Allow remote access to the database:

```
» sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
# or
» sed -i "s/^bind-address/#bind-address/" /etc/mysql/mysql.conf.d/mysqld.cnf
```

Restart the daemon:

```
» service mysql restart
```

Grant Slurm access to the database:

```
» grep -e '^user' -e '^password' /etc/mysql/debian.cnf
» mysql -u debian-sys-maint -p
mysql> grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01.devops.test' identified by '12345678' with grant option;
mysql> select User,Host from mysql.user where User = 'slurm';
[…]
mysql> quit
```




Adjust the following configuration options in [slurmdbd.conf][slurmdbdconf]:

    » egrep '^StorageLoc|^StoragePass' /etc/slurm-llnl/slurmdbd.conf 
    StorageLoc=slurm_acct_db
    StoragePass=12345678

Adjust the following configuration options in [slurm.conf][slurmconf]:

    » egrep '^AccountingStorageHost|^AccountingStorageType|^JobAcctGatherType' /etc/slurm-llnl/slurm.conf 
    AccountingStorageHost=lxrm01
    AccountingStorageType=accounting_storage/slurmdbd
    JobAcctGatherType=jobacct_gather/linux
    » scontrol reconfigure

### File Storage

The following configuration is only interesting for small deployments (testing).

Enable accounting and resource limits in [slurm.conf][slurmconf] on all nodes of the cluster to collect data into plain text files.

    » egrep '^JobAcctGatherType|^JobCompLoc|^JobCompType' /etc/slurm-llnl/slurm.conf
    JobAcctGatherType=jobacct_gather/linux
    JobCompLoc=/var/log/slurm-llnl/job_completions
    JobCompType=jobcomp/filetxt

The configuration above preservers basic job information (job name, user name, allocated nodes, start time, completion time, exit status). While the following configuration collects additional more detailed information:

    » egrep '^AccountingStorageType|^AccountingStorageLoc' /etc/slurm-llnl/slurm.conf 
    AccountingStorageLoc=/var/log/slurm-llnl/accounting
    AccountingStorageType=accounting_storage/filetxt

Note: The accounting file needs to be shared among nodes to be used by the [sacct][sacct] command.

If you are running with the accounting storage plug-in, use of the job completion plug-in is probably redundant. 


## Slurmd

Install **slurmd** on an execution node:

    » apt install slurmd
    […]
    » scp lxrm01:/etc/slurm-llnl/slurm.conf /etc/slurm-llnl/slurm.conf
    […]
    » scp -r lxrm01:/etc/munge/munge.key /etc/munge/
    […]
    » chown munge:munge /etc/munge/munge.key
    » service munge start
    Starting MUNGE: munged.
    » service slurm-llnl start
    Starting slurm compute node daemon: slurmd.
    » sinfo
    PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
    debug*       up   infinite      3  down* lxb[002-004]
    debug*       up   infinite      1   idle lxb001


- Install the _slurmd_ package.
- Copy the cluster configuration file `/etc/slurm-llnl/slurm.conf`.
- Copy the authentication key `/etc/munge/munge.key` and adjust its permissions.
- Start the `munge` and `slumrd` service daemons. 

## Tests

Make sure to understand how to build [development and test environments with virtual machine](../libvirt.md).

### Account Database

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
    » nodeset-loop "virsh-instance -O shadow debian64-8 {}.devops.test"
    » nodeset-loop "cd $VM_INSTANCE_PATH/{}.devops.test ; ssh-exec -s 'hostname {} ; hostname -f' ; cd -"

Deploy the Chef role [execution_node][execution_node.rb] to install _slurmd_

    » slurm-en() { for d in $VM_INSTANCE_PATH/lxb* ; do cd $d ; $@ ; cd - >/dev/null ; done }
    » slurm-en chef-remote cookbook sys
    » slurm-en chef-remote role $SCRIPTS/var/chef/roles/debian/slurm/execution_node.rb
    » slurm-en chef-remote -r "role[execution_node]" solo
    » slurm-en ssh-exec -s 'systemctl restart munge slurmd'


[slurmdevel]: https://groups.google.com/forum/#!forum/slurm-devel
[munge]: https://code.google.com/p/munge/
[slurmconf]: http://manpages.debian.org/slurm.conf
[slurmdbdconf]: http://manpages.debian.org/slurmdbd.conf
[sacct]: http://manpages.debian.org/sacct
[sinfo]: http://manpages.debian.org/sinfo

[account_database.rb]: ../../var/chef/roles/debian/jessie/account_database.rb
[cluster_controller.rb]: ../../var/chef/roles/debian/jessie/cluster_controller.rb
[slurm_basic]: ../../var/slurm/basic/
[execution_node.rb]: ../../var/chef/roles/debian/jessie/execution_node.rb
