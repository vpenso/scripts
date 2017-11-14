
# Deployment

Official source code archive releases are available at:

<http://www.schedmd.com/#repos>

The official source code repository is on [SchedMD/slurm](https://github.com/SchedMD/slurm), and the primary communication channel to the developers is the [slurm-devel][slurmdevel] mailing list.

Since 2013/12 the version numbers use the format year.month (like Ubuntu). Last version with the old schema is 2.6.7, followed by a new biannual release cycle with version like 14.06 and 14.12. 

## Packages

### Debian

Official Debian package:

<http://packages.debian.org/slurm-wlm>

Package versions for Debian Jessie and Stretch: 

```bash
>>> date && rmadison slurm-wlm
Tue Nov 14 12:10:35 CET 2017
slurm-wlm  | 14.03.9-5        | oldstable                  | amd64, arm64, armel, armhf, i386, mips, mipsel, powerpc, ppc64el, s390x
slurm-wlm  | 14.03.9-5+deb8u1 | oldstable-proposed-updates | amd64, arm64, armel, armhf, i386, mips, mipsel, powerpc, ppc64el, s390x
slurm-wlm  | 16.05.9-1        | stable                     | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
slurm-wlm  | 16.05.9-1+deb9u1 | proposed-updates           | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
slurm-wlm  | 17.02.7-1        | testing                    | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
slurm-wlm  | 17.02.9-1        | unstable                   | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, powerpc, ppc64el, s390x
```

Proximity of SLURM upstream releases to the release of a Debian package to **testing**:

```bash
## release dates of major SLURM versions as package to Debian **testing**:
>>> cat *_changelog | grep -e ^slurm -e ' -- ' | paste - - | cut -d' ' -f1,2,11-13 L
slurm-llnl (17.02.1.2-1) 08 Mar 2017
slurm-llnl (16.05.0-1) 14 Jun 2016
slurm-llnl (15.08.0-1) 24 Sep 2015
slurm-llnl (14.11.6-1) 20 May 2015
slurm-llnl (14.03.8-1) 08 Sep 2014
## compared to upstream source
>>> git clone https://github.com/SchedMD/slurm.git && cd slurm
>>> git log --tags --simplify-by-decoration --pretty="format:%ci %d" | grep tag
2017-03-02 15:22:45 -0700  (tag: slurm-17-02-1-1)
2016-05-31 14:42:39 -0700  (tag: slurm-16-05-0-1)
2015-08-31 16:55:04 -0700  (tag: slurm-15-08-0-1)
2015-04-23 15:50:47 -0700  (tag: slurm-14-11-6-1)
2014-09-17 13:19:57 -0700  (tag: slurm-14-03-8-1)
```

An example of Debian following a minor release of SLURM 16.05

```bash
>>> git log --tags --simplify-by-decoration --pretty="format:%ci %d" | grep tag | grep slurm-16-05
2017-10-31 18:30:01 -0600  (tag: slurm-16-05-11-1)
2017-03-02 17:42:11 -0700  (tag: slurm-16-05-10-2)
2017-03-02 15:17:50 -0700  (tag: slurm-16-05-10-1)
2017-01-31 12:56:34 -0700  (tag: slurm-16-05-9-1)
2017-01-04 14:11:51 -0700  (tag: slurm-16-05-8-1)
2016-12-08 15:35:21 -0700  (tag: slurm-16-05-7-1)
2016-10-27 14:33:09 -0600  (tag: slurm-16-05-6-1)
2016-09-29 13:03:13 -0600  (tag: slurm-16-05-5-1)
2016-08-12 06:30:15 -0600  (tag: slurm-16-05-4-1)
2016-07-26 14:04:46 -0700  (tag: slurm-16-05-3-1)
2016-07-06 16:51:37 -0700  (tag: slurm-16-05-2-1)
2016-06-29 15:45:09 -0700  (tag: slurm-16-05-1-1)
2016-05-31 14:42:39 -0700  (tag: slurm-16-05-0-1)
2016-05-13 08:49:56 -0700  (tag: slurm-16-05-0-0rc2)
2016-05-03 15:33:43 -0700  (tag: slurm-16-05-0-0rc1)
2016-03-29 15:06:49 -0700  (tag: slurm-16-05-0-0pre2)
2016-02-18 15:30:03 -0800  (tag: slurm-16-05-0-0pre1)
>>> cat *_changelog | grep -e ^slurm -e ' -- ' | paste - - | cut -d' ' -f1,2,11-13 | grep 16.05
slurm-llnl (16.05.9-1) 03 Feb 2017
slurm-llnl (16.05.8-1) 07 Jan 2017
slurm-llnl (16.05.7-2) 30 Dec 2016
slurm-llnl (16.05.7-1) 14 Dec 2016
slurm-llnl (16.05.6-1) 28 Oct 2016
slurm-llnl (16.05.5-1) 30 Sep 2016
slurm-llnl (16.05.4-1) 26 Sep 2016
slurm-llnl (16.05.2-1) 29 Jul 2016
slurm-llnl (16.05.0-1) 14 Jun 2016
```



### CentOS

Latest Munge release: <https://github.com/dun/munge/releases>

```bash
# install the tool chain
>>> yum groupinstall "Development Tools"
>>> yum -y install rpm-build bzip2-devel openssl-devel zlib-devel wget
# download the latest verison of Munge
>>> wget https://github.com/dun/munge/releases/download/munge-0.5.12/munge-0.5.12.tar.xz
# build the packages
>>> rpmbuild -tb --clean munge-0.5.12.tar.xz
>>> ls ~/rpmbuild/RPMS/x86_64/*
/root/rpmbuild/RPMS/x86_64/munge-0.5.12-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/munge-debuginfo-0.5.12-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/munge-devel-0.5.12-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/munge-libs-0.5.12-1.el7.centos.x86_64.rpm
```

Latest Slurm release: <https://www.schedmd.com/downloads.php>

```bash
# install dependencies
>>> yum -y install readline-devel perl-ExtUtils-MakeMaker pam-devel mysql-devel
>>> rpm -i /root/rpmbuild/RPMS/x86_64/munge*.rpm  # install munge including the development package
# download the latest version of slurm
>>> wget https://www.schedmd.com/downloads/latest/slurm-17.02.7.tar.bz2
# build the Slurm packages
>>> rpmbuild -tb --clean slurm-17.02.7.tar.bz2
>>> ls -1 /root/rpmbuild/RPMS/x86_64/slurm*
/root/rpmbuild/RPMS/x86_64/slurm-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-contribs-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-devel-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-munge-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-openlava-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-pam_slurm-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-perlapi-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-plugins-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-slurmdbd-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-sql-17.02.7-1.el7.centos.x86_64.rpm
/root/rpmbuild/RPMS/x86_64/slurm-torque-17.02.7-1.el7.centos.x86_64.rpm
# publish packages on a local repository
>>> cp ~/rpmbuild/RPMS/x86_64/*.rpm /var/www/html/repo/
>>> createrepo --update /var/www/html/repo/
```

## Source Code

### Munge

Build [Munge][munge] from a [release version](https://github.com/dun/munge/releases)

```bash
wget https://github.com/dun/munge/releases/download/munge-0.5.12/munge-0.5.12.tar.xz
                                                   # download the source code
tar xf munge-0.5.12.tar.xz                         # extract the archive
apt-get -y install ca-certificates bzip2 build-essential libgcrypt11-dev libbz2-dev zlib1g-dev
                                                   # install dependencies 
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
                                                   # configure for system deployment
make && make install                               # complie and install
```

```bash
dd if=/dev/urandom bs=1 count=1024 >/etc/munge/munge.key
                                                  # create a secret
chmod -R 700 /etc/munge                           # adjust permissions for the config
munged -F                                         # start munged in foreground
munge -n | unmunge                                # create a credentail, and decode
remunge                                           # run perfomance test
```

**Service**

```bash
useradd --system munge                            # create a system user
chmod 755 /etc/munge/                             # create configuration directory
chown munge:munge /etc/munge/munge.key /var/run/munge/ /var/lib/munge/ /var/log/munge/
                                                  # adjust ownership of service files
chmod 400 /etc/munge/munge.key                    # adjust permissions of the secret
systemctl start munge                             # start the service
systemctl status munge                            # show service state
journalctl -u munge                               # print log messages
munge -n                                          # test by creating a credential 
/usr/lib/systemd/system/munge.service             # unit configuration
systemctl cat munge                               # print the unit file
systemctl list-dependencies --after munge         # show unit dependencies 
```

Multiple versions in `/opt/munge/<version>`, adjust unit file `munge.service`:

```bash
Environment="LD_LIBRARY_PATH=/opt/munge/0.5.12/lib"
ExecStart=/opt/munge/0.5.12/sbin/munged
```
```bash
./configure --prefix=/opt/munge/0.5.12/ --sysconfdir=/etc --localstatedir=/var --mandir=/share 
                                                  # configure for /opt deployment
ln -s /opt/munge/0.5.12/lib/systemd/system/munge.service /lib/systemd/system/munge.service
                                                  # link to the version specific unit file
echo "PATH=$PATH:/opt/munge/0.5.12/bin:/opt/munge/0.5.12/sbin" > /etc/profile.d/munge.sh
                                                  # set environment on login
systemctl start munge                             # start the service
su - -c 'munge -n'                                # check it is working
```


### Slurm

Build [Slurm](https://github.com/SchedMD/slurm) from a [release version](https://github.com/SchedMD/slurm/releases)

```bash
wget https://github.com/SchedMD/slurm/archive/slurm-16-05-3-1.tar.gz
                                                  # download the source code
tar xf slurm-16-05-3-1.tar.gz                     # extract the archive
apt install python                                # install dependencies
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
                                                  # configure for a system installation
make && make install                              # compile install
```

```bash
>>> useradd --system slurm                            # create a system user
>>> cp etc/slurm.conf.example /etc/slurm.conf         # create a minimal configuration
>>> egrep '^ControlMachine|^NodeName|^PartitionName' /etc/slurm/slurm.conf
ControlMachine=lxdev01
NodeName=lxdev[02-04] Procs=1 State=UNKNOWN
PartitionName=debug Nodes=lxdev[02-04] Default=YES MaxTime=INFINITE State=UP
>>> slurmctld -D                                      # start the control daemon
>>> sinfo                                             # pinrt state
```

# Configuration

Cf. [config.md](config.md) 

## Slurmctld

Deployment and configuration of the cluster controller:

```bash
## install on CentOS
>>> yum install -y slurm
>>> cp /etc/slurm/slurm.conf.example /etc/slurm/slurm.conf
>>> firewall-cmd --permanent --zone=public --add-port=6817/udp
>>> firewall-cmd --permanent --zone=public --add-port=6817/tcp
>>> firewall-cmd --permanent --zone=public --add-port=6818/tcp
>>> firewall-cmd --permanent --zone=public --add-port=6818/tcp
>>> firewall-cmd --permanent --zone=public --add-port=7321/tcp
>>> firewall-cmd --permanent --zone=public --add-port=7321/tcp
>>> firewall-cmd --reload
>>> groupadd slurm && useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -g slurm -s /bin/bash slurm
>>> mkdir -m 755 -p /var/spool/slurm/ctld && chown slurm:slurm /var/spool/slurm/ctld
## install on Debian
>>> apt install slurmctld
>>> zcat /usr/share/doc/slurm-llnl/examples/slurm.conf.simple.gz > /etc/slurm-llnl/slurm.conf
```
```bash
## configure the controller
>>> egrep '^ControlMachine|^NodeName|^PartitionName' /etc/slurm*/slurm.conf
ControlMachine=lxrm01
NodeName=lxb[001-004] Procs=1 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
## create a Munge shared authentication key
>>> dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
## start Munge
>>> systemctl enable munge && systemctl start munge
## start the slurm controller
>>> systemctl enable slurmctld && systemctl start slurmctld
>>> scontrol show config
>>> sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up   infinite      4    unk lxb[001-004]
```

## Slurmdbd


```bash
## install on CentOS
>>> yum -y install slurm-slurmdbd slurm-munge
>>> mkdir -m 755 /var/log/slurm && chown slurm:slurm /var/log/slurm
>>> cp /etc/slurm/slurmdbd.conf.example /etc/slurm/slurmdbd.conf
# ... configure ...
## install on Debian
>>> apt install slurmdbd 
>>> zcat /usr/share/doc/slurmdbd/examples/slurmdbd.conf.simple.gz > /etc/slurm-llnl/slurmdbd.conf
# ... configure ...
## start the service
>>> systemctl enable slurmdbd && systemctl start slurmdbd
```

### File Storage

The following configuration is only interesting for small deployments (testing).

Enable accounting and resource limits in [slurm.conf][slurmconf] on all nodes of the cluster to collect data into plain text files.

```bash
>>> egrep '^JobAcctGatherType|^JobCompLoc|^JobCompType' /etc/slurm-llnl/slurm.conf
JobAcctGatherType=jobacct_gather/linux
JobCompLoc=/var/log/slurm-llnl/job_completions
JobCompType=jobcomp/filetxt
```

The configuration above preservers basic job information (job name, user name, allocated nodes, start time, completion time, exit status). While the following configuration collects additional more detailed information:

```bash
>>> egrep '^AccountingStorageType|^AccountingStorageLoc' /etc/slurm-llnl/slurm.conf 
AccountingStorageLoc=/var/log/slurm-llnl/accounting
AccountingStorageType=accounting_storage/filetxt
```

Note: The accounting file needs to be shared among nodes to be used by the [sacct][sacct] command.

If you are running with the accounting storage plug-in, use of the job completion plug-in is probably redundant. 

### Database Storage

Install MySQL on Debian:

```bash
» apt-get -y install mysql-server
## Allow remote access to the database:
>>> sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
# or
>>> sed -i "s/^bind-address/#bind-address/" /etc/mysql/mysql.conf.d/mysqld.cnf
## login for configuration
>>> grep -e '^user' -e '^password' /etc/mysql/debian.cnf
>>> mysql -u debian-sys-maint -p
## ...configure...
>>> service mysql restart # restart the daemon
```

Install MariaDB from the [upstream repository](https://downloads.mariadb.org/mariadb/repositories/#mirror=hs-esslingen&distro=CentOS&distro_release=centos7-amd64--centos7&version=10.2) on CentOS 7:

```bash
>>> cat /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
>>> yum -y install MariaDB-server MariaDB-client
## allow remote access
>>> sed -i "s/^#bind-address/bind-address/" /etc/my.cnf.d/server.cnf
>>> firewall-cmd --add-port=3306/tcp # open the firewall
>>> systemctl enable mariadb && systemctl start mariadb
## login for configuration
>>> mysql
# ...configure...
```

Grant Slurm access to the database:

```sql
mysql> grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01' identified by '12345678' with grant option;
mysql> grant all on slurm_acct_db.* TO 'slurm'@'lxrm01.devops.test' identified by '12345678' with grant option;
mysql> select User,Host from mysql.user where User = 'slurm';
[…]
mysql> quit
```

Configure Slurm services to use the database:

```bash
>>> grep ^Storage /etc/slurm*/slurmdbd.conf | sort
StorageHost=lxdb01.devops.test
StorageLoc=slurm_acct_db
StoragePass=12345678
StorageType=accounting_storage/mysql
StorageUser=slurm
```
```bash
>>> egrep '^ClusterName|^AccountingStorageHost|^AccountingStorageType|^JobAcctGatherType' /etc/slurm*/slurm.conf
ClusterName=virgo
JobAcctGatherType=jobacct_gather/linux
AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageHost=lxrm01
>>> sacctmgr -i add cluster virgo
>>> systemctl restart slurmctld
```


## Slurmd

```bash
## install on Debian
>>> apt install slurmd
>>> scp lxrm01:/etc/slurm-llnl/slurm.conf /etc/slurm-llnl/slurm.conf
## install on CentOS
>>> yum install -y slurm slurm-munge
>>> groupadd slurm && useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -g slurm -s /bin/bash slurm
>>> mkdir -m 755 -p /var/spool/slurm/d && chown slurm:slurm /var/spool/slurm/d
>>> scp lxrm01:/etc/slurm/slurm.conf /etc/slurm/
## configure Munge
>>> scp -r lxrm01:/etc/munge/munge.key /etc/munge/ && chown munge:munge /etc/munge/munge.key
>>> systemctl enable munge && systemctl start munge
>>> systemctl enable slurmd && systemctl start slurmd
```

[slurmdevel]: https://groups.google.com/forum/#!forum/slurm-devel
[munge]: https://dun.github.io/munge/ 
[slurmconf]: http://manpages.debian.org/slurm.conf
[slurmdbdconf]: http://manpages.debian.org/slurmdbd.conf
[sacct]: http://manpages.debian.org/sacct
[sinfo]: http://manpages.debian.org/sinfo

