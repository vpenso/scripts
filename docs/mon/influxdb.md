

Installation

```bash
apt -y install curl apt-transport-https
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian jessie stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
apt update && apt install influxdb
```

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

### InfluxQL

Statements:

```
show databases                     # display all existing databases
create database <db-name>          # create a database
use <db-name>                      # select database for all future requests
inset <line-protocol>              # insert a single time-series datapoint
select ["<tag-key>",...,]"<field-key>",["<field-key>",..] from "<measurement-name>"
                                   # query from a database
```


