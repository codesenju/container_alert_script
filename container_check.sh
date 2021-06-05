#!/bin/bash
j=0
file=/tmp/ifh_check.container
cfile=/opt/docker/.ifh_container_alerts/bin/containers.txt
query="healthy"
#state="down"
if [ -f $cfile ]; then
  for cont in $(cat $cfile); do
    state=$(docker ps -a --filter "name=$cont" --format {{.Status}})
    echo  "$(date +'%d-%m-%Y*%T') $cont is $state"
    if [[ "$state" != *"$query"* ]]; then
      let j++
      echo "$(date +'%d-%m-%Y*%T') $cont is $state" >> $file
    fi
  done
else
#  echo 'No containers.txt file' >> $file
   echo "$(date +'%d-%m-%Y*%T') No $cfile file present!"
fi
#echo "$j"
if [[ $j -gt 0 ]]; then
 echo "$(date +'%d-%m-%Y*%T') $j container(s) down!" >> $file
else
  echo "$(date +'%d-%m-%Y*%T') Clearing $file file!"
  > $file
fi