build:
	docker build -t aggregion/atlas .

push:
	docker push aggregion/atlas

all:
	make build
	make push
