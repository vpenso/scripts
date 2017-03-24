# Telegraf

[Telegraf](https://github.com/influxdata/telegraf) is used for collecting, processing, aggregating, and writing metrics.

### Installation

```bash
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.2.1_amd64.deb
dpkg -i telegraf_1.2.1_amd64.deb
### adjust the local configuration 
systemctl enable telegraf
systemctl start telegraf
```

### Configuration

Cf. [Telegraf Configuration](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md)

```bash
/etc/telegraf/telegraf.conf         # local configuration
/etc/telegraf/telegraf.d/           # additional custom configuration
# debug the local configuration
telegraf -debug -config /etc/telegraf/telegraf.conf -config-directory /etc/telegraf/telegraf.d/
```

Files in `/etc/telegraf/telegraf.d/` require to  matching `*.conf`.

At least on output target is required:

```ini
[[outputs.influxdb]]
  urls = ["http://lxdev01.devops.test:8086"]
  database = "telegraf"
```
