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
  - Graphite [Whisper](http://graphite.readthedocs.io/en/latest/whisper.html)
  - [InfluxDB](https://github.com/influxdata/influxdb)
  - [KairosDB](https://github.com/kairosdb/kairosdb)
  - [OpenTSDB](https://github.com/OpenTSDB)
  - [Prometheus](https://prometheus.io/)
  - [Druid](http://druid.io/)
  - [DalmatinerDB](https://dalmatiner.io/)
  - [SiriDB](https://github.com/transceptor-technology/siridb-server) 

## Time Series Visualisation

* List of Tools:
  - [RRDGraph](https://oss.oetiker.ch/rrdtool/doc/rrdgraph.en.html)
  - [Graphite](https://github.com/graphite-project)
  - [Grafana](https://grafana.com/)
  - [MetricsGraphics.js](https://www.metricsgraphicsjs.org/)
  - [Kibana](https://www.elastic.co/products/kibana) Timelion
