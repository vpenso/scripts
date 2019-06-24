# Cern CentOS 7

Cern CentOS [01] is a customized distribution that is built on top of the CentOS

* Fully compatible with CentOS therefore with the [Red Hat] Enterprise Linux
* Includes **security, enhancement and bugfix errata** [03]

Available for mirroring at <http://linuxsoft.cern.ch/>

List or package repositories used by default:

```bash
>>> yum repolist enabled --verbose | grep baseurl | cut -d: -f2- | sort
 http://linuxsoft.cern.ch/cern/centos/7/cern/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/extras/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/
 http://linuxsoft.cern.ch/cern/centos/7/updates/x86_64/
 http://linuxsoft.cern.ch/elrepo/elrepo/el7/x86_64/
 http://linuxsoft.cern.ch/epel/7/x86_64/
```

## Security Updates

Install security updates [03]:

```bash
# check for security related package updates
>>> yum --security check-updates
...
25 package(s) needed for security, out of 73 available
...
# install all security updates
>>> yum --security update
# enable automatic system updates [02]
>>> systemctl enable yum-autoupdate

```

# Mirror

`rsync` the the CERN CentOS Mirror

```bash
mkdir -p /var/www/html/cern/centos/7
rsync --verbose \
      --archive \
      --compress \
      --delete \
      rsync://linuxsoft.cern.ch/cc7/os \
      rsync://linuxsoft.cern.ch/cc7/updates \
      rsync://linuxsoft.cern.ch/cc7/extras \
      rsync://linuxsoft.cern.ch/cc7/cern \
      /var/www/html/cern/centos/7
```

Using a systemd unit:

```bash
# file containing the URI to download the package mirror from
mkdir /etc/systemd/system/rsync-cern-centos-mirror.service.d
cat > /etc/systemd/system/rsync-cern-centos-mirror.service.d/endpoint.conf <<EOF
[Service]
Environment="OS=rsync://linuxsoft.cern.ch/cc7/os"
Environment="UPDATES=rsync://linuxsoft.cern.ch/cc7/updates"
Environment="EXTRAS=rsync://linuxsoft.cern.ch/cc7/extras"
Environment="CERN=rsync://linuxsoft.cern.ch/cc7/cern"
EOF
# service unit to rync with the URIs defined above
cat > /etc/systemd/system/rsync-cern-centos-mirror.service <<EOF
[Unit]
Description=Rsync CERN CentOS Mirror

[Service]
ExecStartPre=-/usr/bin/mkdir -p /var/www/html/cern/centos/7
ExecStart=/usr/bin/rsync \
  --verbose \
  --archive \
  --compress \
  --delete \
  \${OS} \
  \${UPDATES} \
  \${EXTRAS} \
  \${CERN} \
  /var/www/html/cern/centos/7
Type=oneshot
EOF
# load the configuration
systemctl daemon-reload
# start rsync
systemctl start rsync-cern-centos-mirror
# follow the rsync log...
journalctl -f -u rsync-cern-centos-mirror
```

Periodically execute the service above:

```bash
cat > /etc/systemd/system/rsync-cern-centos-mirror.timer <<EOF
[Unit]
Description=Periodically Rsync CERN CentOS Mirror

[Timer]
OnStartupSec=300s
OnUnitInactiveSec=2h

[Install]
WantedBy=multi-user.target
EOF
# enable and start the timer unit
systemctl daemon-reload
systemctl enable --now rsync-cern-centos-mirror.timer
```

# References

[01] CERN CentOS  
<https://linux.web.cern.ch/linux/centos.shtml>

[02] Cern CentOS - Software Management  
<http://linux.web.cern.ch/linux/scientific5/docs/softwaremgmt.shtml#sysconfenable>

[03] System Updates for CERN CentOS 7  
<http://linux.web.cern.ch/linux/updates/updates-cc7.shtml>
