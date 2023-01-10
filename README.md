# Apache Atlas 3.0.0 Docker image

## Make

* make build - build an image
* make push - push image to Docker Hub
* make all - build & publish

## Run

```shell
docker run
  -v /atlas-application.properties:/opt/atlas/conf/atlas-application.properties
  -e SOLR_HOST=solr
  -e SOLR_PORT=8983
  -p 21000:21000
  aggregion/atlas
```

## Environment variables

```shell
CASSANDRA_HOST=${CASSANDRA_HOST:=cassandra}
CASSANDRA_PORT=${CASSANDRA_PORT:=9160}
ZOOKEEPER_HOST=${ZOOKEEPER_HOST:=zoo1,zoo2,zoo3}
SOLR_HOST=${SOLR_HOST:=solr}
SOLR_PORT=${SOLR_PORT:=8983}
KAFKA_HOST=${KAFKA_HOST:=kafka}
```


## ToDo

- [x] Add environment variables support for ZooKeeper, HBase, Kafka, etc.
- [ ] Add more docs
