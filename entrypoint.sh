#!/bin/bash

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi

      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in "${SERVICE_PRECONDITION[@]}"
do
    wait_for_it ${i}
done

export SOLR_HOST=${SOLR_HOST:=solr}
export SOLR_PORT=${SOLR_PORT:=8983}
export SOLR_ADDR=$SOLR_HOST:$SOLR_PORT


curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=vertex_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true
curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=fulltext_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true
curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=edge_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true



python2.7 $ATLAS_BIN/atlas_start.py && tail --pid=$(cat $ATLAS_HOME/logs/atlas.pid) -f /dev/null
