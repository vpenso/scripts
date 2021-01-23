#!/bin/bash 

pid=`pgrep wf-recorder`
status=$?

if [ $status != 0 ] 
then 
  wf-recorder --audio --file /tmp/wf-recorder_$(date +%Y%m%dT%H%M).mp4
else 
  pkill --signal SIGINT wf-recorder
fi
