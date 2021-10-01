# Apache Atlas 3.0.0 Docker image 

## Make

* make build - build an image
* make push - push image to Docker Hub
* make all - build & publish

## Run

### Run master node 

```shell
docker run 
  -v /atlas-application.properties:/opt/atlas/conf/atlas-application.properties
  -e SOLR_HOST=solr
  -e SOLR_PORT=8983
  -p 21000:21000
  aggregion/atlas
```


## ToDo

- [ ] Add environment variables support for ZooKeeper, HBase, Kafka, etc.
- [ ] Add more docs
