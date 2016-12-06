→ [RRDtool](https://oss.oetiker.ch/rrdtool/)

* **DS** data-Source
* **CF** consolidation function – `AVERAGE`,`MIN`,`MAX`,`LAST`
* **RRA** round robin archives

↴ [rrd2csv](../bin/rrd2csv)

```bash
rrdinfo $rrdfile                                  # print RRD header information
rrdinfo $rrdfile | grep ^ds | sed 's/.*\[\(.*\)\].*/\1/g' | sort | uniq
                                                  # list data-sources in file alphabetically
rrdtool tune $rrdfile -r <old>:<new>              # change data-source name
date -d '2016/11/01T00:00:01' +%s                 # convert date to epoch
rrdtool xport --json -s $start -e $end DEF:name=$rrdfile:$DS:$CF XPORT:name
                                                  # export to JSON
rrdtool fetch $rrdfile -s $start -e $end $CF | ruby -pe 'gsub(/^\d*:/,"#{Time.at($&.to_i)} =")'
                                                  # print vlaue with readable time format
```
