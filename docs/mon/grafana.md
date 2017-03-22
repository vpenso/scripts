# Grafana

[Grafana](https://github.com/grafana/grafana) is an open source dashboard to present monitoring metrics.

## Usage

```bash
curl https://packagecloud.io/gpg.key | sudo apt-key add -
echo "deb https://packagecloud.io/grafana/stable/debian/ jessie main" > /etc/apt/sources.list.d/grafana.list
apt update && apt-get install -y apt-transport-https grafana
systemctl start grafana-server
```

Defaults HTTP port 3000, default user and password is `admin`.

Configuration, services and interfaces:

```bash
/var/log/grafana/                             # log files 
/var/lib/grafana/grafana.db                   # database
```
