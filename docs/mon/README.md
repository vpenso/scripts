### Time Series

* Used to monitor things happening over time...
* Series of **chronologically** ordered data points
  - Variables of interest are measured at a **discrete time** point
  - The measurement is repeated with a given **time interval**
* Time series **analysis** methods extract meaningful information from time series data

### Time Series Database

* TSDB (Time Series Database)
  - Data storage optimized to handle time series data (values indexed by time)
  - Interfaces to efficiently create, enumerate, update and destroy various time series
  - Support for basic calculations that work on time series
  - Mechanisms for data retention/aggregation of historical data
* List of databases:
  - [RRDtool](https://github.com/oetiker/rrdtool-1.x)
  - [Graphite](https://github.com/graphite-project)
  - [InfluxDB](https://github.com/influxdata/influxdb)
  - [KairosDB](https://github.com/kairosdb/kairosdb)
  - [OpenTSDB](https://github.com/OpenTSDB)
  - [Prometheus](https://prometheus.io/)
  - [Druid](http://druid.io/)
