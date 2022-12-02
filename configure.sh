#!/bin/sh

CONF_DIR=/Users/dmitrysomov/projects/aggregion/backend/atlas-docker
TEMPLATE_FILE=${CONF_DIR}/atlas-application.properties.template
PROPS_FILE=${CONF_DIR}/atlas-application.properties
KEYLOAK_JSON_FILE=${CONF_DIR}/keycloak.json

export CASSANDRA_HOST=${CASSANDRA_HOST:=cassandra}
export CASSANDRA_PORT=${CASSANDRA_PORT:=9042}
export ZOOKEEPER_HOST=${ZOOKEEPER_HOST:=zoo1,zoo2,zoo3}
export SOLR_HOST=${SOLR_HOST:=localhost}
export SOLR_PORT=${SOLR_PORT:=8983}
export KAFKA_HOST=${KAFKA_HOST:=kafka}
export SOLR_ZOOKEEPER_HOST=${SOLR_ZOOKEEPER_HOST:=$ZOOKEEPER_HOST/solr}

export FILE_ENABLE_AUTH=${FILE_ENABLE_AUTH:=true}

export KEYCLOAK_ENABLE_AUTH=${KEYCLOAK_ENABLE_AUTH:=false}
export KEYCLOAK_REALM=${KEYCLOAK_REALM:=aggregion}
export KEYCLOAK_RESOURCE=${KEYCLOAK_RESOURCE:=atlas} # client id
export KEYCLOAK_CREDENTIALS_SECRET=${KEYCLOAK_CREDENTIALS_SECRET:=atlasclientsecret}
export KEYCLOAK_SSL_REQUIRED=${KEYCLOAK_SSL_REQUIRED:=external}
export KEYCLOAK_AUTH_SERVER_URL=${KEYCLOAK_AUTH_SERVER_URL:=https://keycloak.aggregion.com/}
# you can get keycloak.json from Keycloak Admin Console:
# Clients -> Client Details -> Action -> Download adapter config -> Format option: "Keycloak OIDC JSON"
export KEYCLOAK_JSON="
{
  \"realm\": \"$KEYCLOAK_REALM\",
  \"auth-server-url\": \"$KEYCLOAK_AUTH_SERVER_URL\",
  \"ssl-required\": \"$KEYCLOAK_SSL_REQUIRED\",
  \"resource\": \"$KEYCLOAK_RESOURCE\",
  \"credentials\": {
    \"secret\": \"$KEYCLOAK_CREDENTIALS_SECRET\"
  },
  \"confidential-port\": 0
}
"

if [ "$KEYCLOAK_ENABLE_AUTH" = "true" ]; then
  echo "$KEYCLOAK_JSON" > $KEYLOAK_JSON_FILE
  export KEYCLOAK_AUTH="
######## Keycloak properties #########
atlas.authentication.method.keycloak=true
atlas.authentication.method.keycloak.file=keycloak.json
"
fi

envsubst < ${TEMPLATE_FILE} > ${PROPS_FILE}

ln -s /usr/bin/python2.7 /usr/bin/python
encryptedPwd=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_ADMIN_LOGIN} -p ${ATLAS_USER_ADMIN_PASSWORD} -s)
encryptedPwdDST=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_DST_LOGIN} -p ${ATLAS_USER_DST_PASSWORD} -s)
encryptedPwdDSCI=$(${ATLAS_HOME}/bin/cputil.py -g -u ${ATLAS_USER_DSCI_LOGIN} -p ${ATLAS_USER_DSCI_PASSWORD} -s)

echo "${ATLAS_USER_ADMIN_LOGIN}=ADMIN::${encryptedPwd}" > ${ATLAS_HOME}/conf/users-credentials.properties
echo "${ATLAS_USER_DST_LOGIN}=DATA_STEWARD::${encryptedPwdDST}" >> ${ATLAS_HOME}/conf/users-credentials.properties
echo "${ATLAS_USER_DSCI_LOGIN}=DATA_SCIENTIST::${encryptedPwdDSCI}" >> ${ATLAS_HOME}/conf/users-credentials.properties
