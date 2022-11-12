#!/bin/bash

/configure.sh


sleep 36000

#"${SOLR_BIN}"/solr start -force &&
#python2.7 "$ATLAS_BIN"/atlas_start.py && tail --pid=$(cat $ATLAS_HOME/logs/atlas.pid) -f /dev/null

#"${SOLR_BIN}"/solr stop -force


# curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=vertex_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true
# curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=fulltext_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true
# curl "http://$SOLR_ADDR/solr/admin/collections?action=CREATE&name=edge_index&numShards=1&replicationFactor=1&collection.configName=atlas" || true
