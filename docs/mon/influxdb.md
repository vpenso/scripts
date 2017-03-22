# InfluxDB

[InfluxDB](https://github.com/influxdata/influxdb) is an open source **time-series database**

- Used to record operations and application performance metrics
- Implementation in Go, without external dependencies 
- SQL like language to querying a data structure composed of measurements, series, and points (indexed by their time)

### Data Structure 

Organized in time series with zero to many **points** consisting of:

* `time`: a **time-stamp** (in RFC3339 UTC)
* `measurement`: acts as a container for tags, fields, its **name** is the description of the data associated
  - `fields`: At least one key-value pair representing the measurement **data** (not indexed)
  - `tags` (optional): Zero to many key-value pairs containing **meta-data** (indexed)

A collection (multiple) field key-value pairs make up a **field set**.

Similar a **tag set** is the collection of all tags from a measurement.

Points are written using a **line protocol** with following format:

```
<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]
```

## Usage

```bash
apt -y install curl apt-transport-https
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian jessie stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
apt update && apt install influxdb
```

Configuration, services and interfaces:

```bash
/etc/influxdb/influxdb.conf        # local configuration
influxd config                     # view configuration
influx                             # start interactive shell
influx -precision rfc3339
influx -execute '<influxql>'       # execute query without database specification
influx -database <db-name> ...     # select a database to query
       -format=json -pretty        # select output format
       -format=csv
```

### InfluxQL

Managing databases:

```bash
show databases                     # display all existing databases
create database <db-name>          # create a database
use <db-name>                      # select database for all future requests
```

Working with a database

```
show measurements
show series                        
show tag keys
show field keys
inset <line-protocol>              # insert a single time-series datapoint
select ["<tag-key>",...,]"<field-key>",["<field-key>",..] from "<measurement-name>"
                                   # query from a database
show retention policies
```

Management & metrics:

```bash
show queries                       # query id, text, database, duration
kill query <qid>                   # stop currently running query
show stats                         # performance statistics
show diagnostics                   # build information, uptime, hostname, 
                                   # server configuration, memory usage, 
                                   # and Go runtime diagnostics
```

### HTTP API

Managing databases:

```bash
export INFLUXDB_URL=http://localhost:8086/query
# get the list of databases, and parse the output with `jq`
curl -s -XPOST $INFLUXDB_URL --data-urlencode "q=show databases"  | jq '.results[].series[].values[][0]'
# create a new database
curl -i -XPOST $INFLUXDB_URL --data-urlencode "q=create database nyx"
```

Working with a database

```bash
# target a specific database
export INFLUXDB_URL=http://localhost:8086/write?db=<db-name>
curl -i -XPOST $INFLUXDB_URL --data-binary 
```

