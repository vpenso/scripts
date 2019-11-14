# Yum-Cron

Keep repository metadata up to date, and check for, download, and apply updates

Enable the service:

```bash
>>> yum install -y yum-cron      # install the package
# start/enable the service
>>> systemctl start yum-cron.service && systemctl enable yum-cron.service
# configuration files
>>> find /etc/yum/* -name '*cron*'
/etc/yum/yum-cron.conf
/etc/yum/yum-cron-hourly.conf
# cronjobs executing yum-cron
>>> find /etc/cron* -name '*yum*'
/etc/cron.daily/0yum-daily.cron
/etc/cron.hourly/0yum-hourly.cron
```

Configure `download_updates` and `apply_updates` to **enable the package updates**:

* CentOS does not support `yum --security update` therefore the `update_cmd = default` is required
* Install new **GPG keys** by packages automatically with `assumeyes = True`

```bash
>>> grep -e ^update_cmd -e ^download -e ^apply /etc/yum/*cron*.conf
/etc/yum/yum-cron.conf:update_cmd = default
/etc/yum/yum-cron.conf:download_updates = yes
/etc/yum/yum-cron.conf:apply_updates = no
/etc/yum/yum-cron-hourly.conf:update_cmd = default
/etc/yum/yum-cron-hourly.conf:download_updates = yes
/etc/yum/yum-cron-hourly.conf:apply_updates = yes
>>> grep ^assume /etc/yum/*cron*
/etc/yum/yum-cron-hourly.conf:assumeyes = True
```

Trouble shooting:

```bash
# check if the cronjobs are executed...
>>> grep yum /var/log/cron
# execute yum-cron with a configuration file...
>>> /usr/sbin/yum-cron /etc/yum/yum-cron-hourly.conf
```
