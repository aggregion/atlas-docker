FROM openjdk:8

ARG VERSION=3.0.0-SNAPSHOT

ENV ATLAS_INSTALL=/opt/install/apache-atlas-${VERSION}
ENV ATLAS_CONF_INSTALL=${ATLAS_INSTALL}/conf
ENV ATLAS_BIN_INSTALL=${ATLAS_INSTALL}/bin
ENV ATLAS_HOME=/opt/apache-atlas-${VERSION}
ENV ATLAS_CONF=/opt/apache-atlas-${VERSION}/conf
ENV ATLAS_BIN=/opt/apache-atlas-${VERSION}/bin
ENV MANAGE_LOCAL_SOLR=false
ENV MANAGE_LOCAL_HBASE=false

# Install python
RUN apt-get update
RUN apt-get install -y python2.7 netcat gettext-base supervisor lsof expect
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Create atlas user
RUN groupadd -r -g 47144 atlas && useradd -r -u 47145 -g atlas atlas

# Add files
ADD apache-atlas-${VERSION}-bin.tar.gz /opt
ADD apache-atlas-${VERSION}-atlas-index-repair.zip /tmp
RUN cd /tmp && unzip apache-atlas-${VERSION}-atlas-index-repair.zip
RUN cp /tmp/atlas-index-repair/repair_index.py "${ATLAS_BIN}/"
RUN mkdir -p "${ATLAS_HOME}/libext"
RUN cp /tmp/atlas-index-repair/atlas-index-repair-tool-${VERSION}.jar "${ATLAS_HOME}/libext/"
RUN rm -rf /tmp/atlas-index-repair
RUN rm -rf /tmp/apache-atlas-${VERSION}-atlas-index-repair.zip

ADD solr-config /opt/solr-config

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh

ADD truststore-password.exp /truststore-password.exp
RUN chmod +x /truststore-password.exp

ADD atlas-application.properties.template /opt/apache-atlas-${VERSION}/conf/atlas-application.properties.template
ADD models/9000-Aggregion/ /opt/apache-atlas-${VERSION}/models/9000-Aggregion/

EXPOSE 21000

WORKDIR ${ATLAS_HOME}

CMD ["/entrypoint.sh"]
