#!/bin/sh

CONF_DIR=${ATLAS_HOME:=/opt/atlas}/conf
TEMPLATE_FILE=${CONF_DIR}/atlas-application.properties.template
PROPS_FILE=${CONF_DIR}/atlas-application.properties

export CASSANDRA_HOST=${CASSANDRA_HOST:=cassandra}
export CASSANDRA_PORT=${CASSANDRA_PORT:=9160}
export ZOOKEEPER_HOST=${ZOOKEEPER_HOST:=zoo1,zoo2,zoo3}
export SOLR_HOST=${SOLR_HOST:=solr}
export SOLR_PORT=${SOLR_PORT:=8983}
export KAFKA_HOST=${KAFKA_HOST:=kafka}

envsubst < ${TEMPLATE_FILE} > ${PROPS_FILE}

ln -s /usr/bin/python2.7 /usr/bin/python
encryptedPwd=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_ADMIN_LOGIN} -p ${ATLAS_USER_ADMIN_PASSWORD} -s)
encryptedPwdDST=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_DST_LOGIN} -p ${ATLAS_USER_DST_PASSWORD} -s)
encryptedPwdDSCI=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_DSCI_LOGIN} -p ${ATLAS_USER_DSCI_PASSWORD} -s)

echo "${ATLAS_USER_ADMIN_LOGIN}=ADMIN::${encryptedPwd}" > ${ATLAS_HOME}/conf/users-credentials.properties
echo "${ATLAS_USER_DST_LOGIN}=DATA_STEWARD::${encryptedPwdDST}" >> ${ATLAS_HOME}/conf/users-credentials.properties
echo "${ATLAS_USER_DSCI_LOGIN}=DATA_SCIENTIST::${encryptedPwdDSCI}" >> ${ATLAS_HOME}/conf/users-credentials.properties
