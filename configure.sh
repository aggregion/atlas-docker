#!/bin/sh

CONF_DIR=${ATLAS_HOME:=/opt/atlas}/conf
TEMPLATE_FILE=${CONF_DIR}/atlas-application.properties.template
PROPS_FILE=${CONF_DIR}/atlas-application.properties

export CASSANDRA_HOST=${CASSANDRA_HOST:=cassandra}
export export CASSANDRA_PORT=${CASSANDRA_PORT:=9160}
export ZOOKEEPER_HOST=${ZOOKEEPER_HOST:=zoo1,zoo2,zoo3}
export SOLR_HOST=${SOLR_HOST:=solr}
export SOLR_PORT=${SOLR_PORT:=8983}
export KAFKA_HOST=${KAFKA_HOST:=kafka}

envsubst < ${TEMPLATE_FILE} > ${PROPS_FILE}
