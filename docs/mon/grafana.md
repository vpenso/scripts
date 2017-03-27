# Grafana

[Grafana](https://github.com/grafana/grafana) is an open source dashboard to present monitoring metrics.

- Multiple time series data storage solutions (e.g. InfluxDB, Promehteus, OpenTSDB) can be used in combination by connecting them as **data sources**. 
- **Organizations** provide a method for multi-tenancy, and group users, data-sources, and the interfaces into distinct entities.
- **Users** have accounts with different levels of privileges, and can authenticate with internal and external (LDAP, OAuth, GitHub, Google) methods.
- **Dashboards** are build by users to visualize monitoring data in a customized way. Dashboard are a combination of panels showing graphs, tables and other data based on configurable queries on the data sources.
- The basic visualization block are **panels**. They provide a **query editor** to source the data, and various styling and formating options to model the data visualization.
- The dashboard layouts use **rows** as logical dividers to arrange panels on the view horizontally and vertically.

## Usage

```bash
curl https://packagecloud.io/gpg.key | sudo apt-key add -
echo "deb https://packagecloud.io/grafana/stable/debian/ jessie main" > /etc/apt/sources.list.d/grafana.list
apt update && apt-get install -y apt-transport-https grafana
systemctl start grafana-server
```

Defaults to HTTP port `3000`, with default user/password `admin`.

Configuration, services and interfaces:

```bash
/etc/grafana/grafana.ini                      # local configuration
/var/log/grafana/                             # log files 
/var/lib/grafana/grafana.db                   # database
/usr/share/grafana                            # root directory
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3000
                                              # redirect HTTP port 80
```

Cf. [Configuration Guide](http://docs.grafana.org/installation/configuration/)

```bash
grafana-cli plugins list-remote               # list vailable plugins
grafana-cli plugins install <plugin-name>
systemctl restart grafana-server              # restart after installing plugins
grafana-cli plugins ls                        # list installed plugins
grafana-cli plugins update-all
grafana-cli plugins remove <plugin-name>
```

**Import** dashboard from the [Official & community built dashboards](https://grafana.com/dashboards)
