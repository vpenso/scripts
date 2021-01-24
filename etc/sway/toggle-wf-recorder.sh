#!/bin/bash 

pid=`pgrep wf-recorder`
status=$?
if [ $status != 0 ] 
then 

        date=$(date +%Y%m%dT%H%M)
        file=/tmp/wf-recorder_$date.mp4
        log=/tmp/wf-recorder_$date.log
        if [[ $1 == "area" ]]
        then
                wf-recorder \
                        --audio \
                        --geometry "$(slurp)" \
                        --file $file \
                        2>&1 > $log
        else
                wf-recorder \
                        --audio \
                        --file $file \
                        2>&1 > $log
        fi
else 
        pkill --signal SIGINT wf-recorder
fi
