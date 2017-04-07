# Prometheus

[Prometheus](https://prometheus.io/docs/introduction/overview/) is an open-source systems monitoring and alerting toolkit

* Build in **time-series database** to store operation and service metrics
* Monitoring metrics collected by pulling of HTTP from a central server
* Targets configuration read from **service discovery** (or local configuration)
* A **push gateway** acts as a metric cache if entities require to push information

## Data Model

Multi-dimensional data model with metrics and labels 

* Metric names must match regex `[a-zA-Z_:][a-zA-Z0-9_:]*`: Identifies a time series, specifies a measured feature 
* **Labels** are key-value pairs used by the query language for filtering and aggregation
  - Label **name** must match regex `[a-zA-Z_][a-zA-Z0-9_]*`
  - Label **value** may contain any Unicode character

Notation (cf. [metric and label naming](https://prometheus.io/docs/practices/naming/)):

```
<metric name>{<label name>=<label value>, ...}
```

## Query Language

[PromQL](https://prometheus.io/docs/querying/basics/) (non-SQL) designed to read and compute metrics:

Vector selectors:

```bash
<metric_name>                                    # select all time series for metric name
{__name__=~"<metic_name_regex>"}                 # use a regex to match for metric names
<metric_name>{<label_name>=<label_value>, ...}   # filter for label=value, supports = != =~ !~ regex
<metric_name>{...}[<range>]                      # integer time range selector with suffix s,m,h,d,w,y
<metric_name>{...} offset [<range>]              # ^^ relative to the current query evaluation time
```

Aggregation operators (cf. [functions](https://prometheus.io/docs/querying/functions/)):

```bash
<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)] [keep_common]

sum (calculate sum over dimensions)
min (select minimum over dimensions)
max (select maximum over dimensions)
avg (calculate the average over dimensions)
stddev (calculate population standard deviation over dimensions)
stdvar (calculate population standard variance over dimensions)
count (count number of elements in the vector)
count_values (count number of elements with the same value)
bottomk (smallest k elements by sample value)
topk (largest k elements by sample value)
quantile (calculate φ-quantile (0 ≤ φ ≤ 1) over dimensions)
```



## Usage

```bash
echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
apt update && apt install -y -t jessie-backports prometheus  # install the package from backports
systemctl start prometheus && systemctl status prometheus
```


After start the web-interface should be available at **port 9090**:

| Endpoint | Description             |
|----------|-------------------------|
| /graph   | Expression browser      |
| /metrics | Metrics from Prometheus | 

Configuration, services and interfaces:

```bash
/etc/prometheus/prometheus.yml       # local configuration
```

Install the [prometheus-node-exporter](https://github.com/prometheus/node_exporter) package on nodes to be monitored. After start the interface is available at **port 9100**:

```bash
/etc/default/prometheus-node-exporter   # local configuration
prometheus-node-exporter                # start exporter with default configuration
source /etc/default/prometheus-node-exporter ; prometheus-node-exporter $ARGS
                                        # start with local configuration
systemctl start prometheus-node-exporter && systemctl status prometheus-node-exporter
                                        # start as systemd unit
```

Grafana [supports](https://prometheus.io/docs/visualization/grafana/) Prometheus as data-source, and a dashboard [plugin](https://grafana.com/dashboards/1860) is available for the metrics published by the node exporter.
