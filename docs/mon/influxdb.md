# InfluxDB

[InfluxDB](https://github.com/influxdata/influxdb) is an open source **time-series database**

- Used to record operations and application performance metrics
- Implementation in Go, without external dependencies 
- SQL like language to querying a data structure composed of measurements, series, and points (indexed by their time)
- Down-samples data following retention policies
- Line protocol to store data through HTTP, TCP or UDP

InfluxDB is a **schemaless database**. You can add new measurements, tags, and fields at any time.

### Data Structure 

Organized in time series with zero to many **points** consisting of:

* `time`: a **time-stamp** (in RFC3339 UTC)
* `measurement`: is a **name** and acts as a container for tags, fields,
  - `fields`: At least one key-value pair representing the measurement **data** (not indexed)
  - `tags` (optional): Zero to many key-value pairs containing **meta-data** (indexed)

A collection (multiple) field key-value pairs make up a **field set**.

Similar a **tag set** is the collection of all tags from a measurement.

A **series** is a collection of data that shares retention policy, measurement, and a tag set.

### Line Protocol

Points are written using a line protocol with following format:

```
<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]
```

Cf. [Line Protocol Reference](https://docs.influxdata.com/influxdb/v1.2/write_protocols/line_protocol_reference/)

### Storage Format

The storage engine uses **TSM** (Time Structured Merge tree) files:

- Read-only files mapped to memory
- Contain sorted, compressed time series data
- Optimized to write data in time ascending order
- Periodic compaction to optimize storage layout for read 

Data is organized into **shards**:

- Contain specific sets of time series for a given time period
- Determine the representation of data in files on storage

**Shard groups** is a container for one or more shards:

- Have a defined retention policy
- Have a defined replication factor 



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
/var/lib/influxdb/data             # data storage location (TSM files)
/var/lib/influxdb/wal              # write log storage location
~/.influx_history                  # user command history
influxd config                     # view configuration
influx                             # start interactive shell
influx -precision rfc3339
influx -execute '<influxql>'       # execute query without database specification
influx -database <db-name> ...     # select a database to query
       -format=json -pretty        # select output format
       -format=csv
# export all data
influx_inspect export -waldir $INFLUXDB_WAL -datadir $INFLUXDB_DATA -out /tmp/influxdb.txt
influx_inspect dumptsm <tsm-file>  # show time range and statistics
```

### InfluxQL

Managing databases:

```bash
show databases                     # display all existing databases
create database <db-name>          # create a database
use <db-name>                      # select database for all future requests
drop database <db-name             # remove a database
```

Working with a database

```
show measurements
drop measurement <measurement_name> # drops all data and series in the measurement  
show series                        
show tag keys
show field keys
inset <line-protocol>               # insert a single time-series datapoint
select ["<tag-key>",...,]"<field-key>",["<field-key>",..] from "<measurement-name>"
                                    # query from a database
show retention policies
```

Management & metrics:

```bash
show shards                        # list shards, shard-groups, and associated retention policies
drop shard <shard_id_number>       # deletes a shard
show queries                       # query id, text, database, duration
kill query <qid>                   # stop currently running query
show retention policies            # list of retention policies
show retention policies on <db-name>
show stats                         # performance statistics
show diagnostics                   # build information, uptime, hostname, 
                                   # server configuration, memory usage, 
                                   # and Go runtime diagnostics
```

### HTTP API

Managing databases:

- Send a **POST** request to the `/query` endpoint
- Set the `q=<statement>` URL parameter 

```bash
export INFLUXDB_URL=http://localhost:8086/query
# get the list of databases, and parse the output with `jq`
curl -s -XPOST $INFLUXDB_URL --data-urlencode "q=show databases"  | jq '.results[].series[].values[][0]'
# create a new database
curl -i -XPOST $INFLUXDB_URL --data-urlencode "q=create database nyx"
```

Writing data, cf. [API Reference](https://docs.influxdata.com/influxdb/v1.2/tools/api/#write)

- Send a **POST** requests to the `/write` endpoint
- Specify an existing database in the `db` query parameter(, optionally a retention policy with `rp`)
- The body contains the time-series data using the **line-protocol**, or points to a properly-formatted file

```bash
# target a specific database
export INFLUXDB_URL=http://localhost:8086/write?db=<db-name>
curl -i -XPOST $INFLUXDB_URL --data-binary '<line-protocol>'
                             --data-binary @<path_to_file>
```

