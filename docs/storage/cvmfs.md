# CernVM-FS

> The [CernVM-File System][cf] (CernVM-FS) provides a scalable, reliable and
> low-maintenance software distribution service.

* Read-only file system to deliver scientific software to client nodes
* Uses standard HTTP protocol, enabling a variety of web caches
* Files and directories are hosted on **standard web servers**
* Ensures data authenticity/integrity over untrusted connections
* Optimized for small files that are frequently opened/read as a whole

Clients mount a virtual file system to `/cvmfs/$repo.$domain`

* POSIX read-only file system in user space (FUSE module)
* Loads data on demand as soon as directories/files accessed

Create/update a CernVM-FS repository on a **Release Manager Machine**:

* Mounts a CernVM-FS repository in read/write mode
* Software updates installed to a writable scratch area
* Changed in scratch merged into the CernVM-FS repository
* Merge/publish are atomic operations controlled by the user

## Packages

Client/server [binary packages][bp] available for following Platforms:

* Ubuntu {12,16,16,18}.04
* Debian 8,9,10 
* RHEL 6,7,8
* Fedora 29,30
* SLES 11,12 

Package repositories with [YUM][yr] and [APT][ap]

[cf]: https://cvmfs.readthedocs.io/en/2.4/index.html
[bp]: https://cernvm.cern.ch/portal/filesystem/downloads
[yr]: https://cvmrepo.web.cern.ch/cvmrepo/yum/
[ap]: https://cvmrepo.web.cern.ch/cvmrepo/apt/

```bash
## add the EPEL package source
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -i epel-release-latest-7.noarch.rpm
## add the CVMFS package source
yum install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
```
```bash
apt install -y lsb-release wget
## add the CVMFS package source
wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
apt-get update
```

## Clients

Install a CVMFS client

```bash
# RHEL/Centos
yum install -y cvmfs cvmfs-config-default
# Ubuntu/Debian
apt install -y  cvmfs cvmfs-config-default
# run the CVMFS setup program
cvmfs_config setup
# configure FUSE (if requiered)
grep ^user_allow /etc/fuse.conf ||
        echo "user_allow_other" >> /etc/fuse.conf
# check if CVMFS is known to autofs master
grep -r cvmfs /etc/auto.master* 
```

→ [CernVM-FS Client Configuration](https://cvmfs.readthedocs.io/en/2.4/cpt-configure.html)  
→ [CernVM-FS Client Parameters](https://cvmfs.readthedocs.io/en/2.4/apx-parameters.html#apxsct-clientparameters)  
→ [CernVM-FS Configuration Examples](http://cernvm.cern.ch/portal/cvmfs/examples)

Configuration directory structure:

```bash
/etc/cvmfs/default.conf        # client configuration
/etc/cvmfs/default.d/*.conf    # packagre specific configurations
/etc/cvmfs/default.local       # local client configuration (overwrites *.conf)
/etc/cvmfs/domain.d/*.conf     # domain specific configuration
/etc/cvmfs/config.d/*.conf     # repository specific configuration
/etc/cvmfs/keys/**/*.pub       # domain-specific sub directories with public keys 
```

**Enable a CernVM-FS repository**:

```bash
cat > /etc/cvmfs/default.local <<EOF
CVMFS_REPOSITORIES=alice.cern.ch,alice-ocdb.cern.ch
CVMFS_HTTP_PROXY="DIRECT"
EOF
## check configuration
cvmfs_config probe
# mount a CVMFS file-system
systemctl restart autofs
# check
ls /cvmfs/alice.cern.ch
```

Debugging:

```bash
cvmfs_config chksetup                  
cvmfs_config showconfig $repo       # print repo. specific configuration
```

# Repositories

Install the required packages

```bash
# RHEL/Centos
yum install -y cvmfs cvmfs-server
# install Apache
yum -y install httpd && systemctl enable httpd && systemctl start httpd
firewall-cmd --permanent --add-service=http && firewall-cmd --reload
# Ubuntu/Debian
apt install -y cvmfs cvmfs-server
```


## Create a Repository

Use the `cvmfs_server` command create a new repository:

→  [Creating a Repository](https://cvmfs.readthedocs.io/en/2.4/cpt-repo.html)  
→  [Repository Creation and Updating](https://cvmfs.readthedocs.io/en/2.4/cpt-repo.html#sct-repocreation)  

```bash
repo=${repo:-bits.devops.test}
cvmfs_server mkfs $repo
```


* Mounts the repository under `/cvmfs/$repo` (read/write access)
* Repository **names resembles a DNS scheme** (by convention)
  - Globally unique name that indicates where/who the publishing of content
  - Names include `[A-Za-z0-9]-_.` (max 60 characters)

### Keys

**Create backups of signing key files in /etc/cvmfs/keys**

Repositories uses two sets of keys:

```bash
/etc/cvmfs/keys/$repo.key          # Repository key
/etc/cvmfs/keys/$repo.pub          # Distributed to clients, verifies authenticity
/etc/cvmfs/keys/$repo.master.ke    # Signs the repository key
```

* Signatures are only good for 30 days by default
* Run `cvmfs_server resign` again before they expire
* Convenient to share the master key between all repositories in a domain
* Keep the master key especially safe from being stolen
* Supports the ability to store the master key in a smartcard (Yubikey)

### Configuration 

```bash
/etc/cvmfs/repositories.d/$repo/server.conf  # Server configuration file
/etc/cvmfs/repositories.d/$repo/client.conf  # Client configuration file
/srv/cvmfs/$repo                             # Repository storage location
/srv/cvmfs/$repo/.cvmfspublished             # Manifest file of the repository
/srv/cvmfs/$repo/.cvmfswhitelist             # Trusted repository certificates
/srv/cvmfs/$repo/data                        # Content Addressable Storage (CAS)
```

→  [Repository Configuration Directory](https://cvmfs.readthedocs.io/en/2.4/apx-serverinfra.html#repository-configuration-directory)  

Internal state of the repository:

```bash
/var/spool/cvmfs/$repo              # Server spool area
/var/spool/cvmfs/$repo/cache        # Client cache
/var/spool/cvmfs/$repo/rdonly       # Client mount point
/var/spool/cvmfs/$repo/scratch      # Writable union file system
```

→  [Server Spool Area of a Repository](https://cvmfs.readthedocs.io/en/2.4/apx-serverinfra.html#server-spool-area-of-a-repository-stratum0)

## Content Publishing

```bash
cvmfs_server transaction $repo
# install content
echo "foobar" > /cvmfs/$repo/foobar && rm /cvmfs/$repo/new_repository
cvmfs_server publish $repo
```

→  [Publishing a new Repository Revision](https://cvmfs.readthedocs.io/en/2.4/cpt-repo.html#publishing-a-new-repository-revision)
