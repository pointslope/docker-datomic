DOCKER_IMAGE=simplevalue/datomic-pro-template
DOCKER_TAG?=0.1.0

.PHONY: all clean info

all: Dockerfile
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

clean:
	docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG)

info:
	@echo "Docker image: $(DOCKER_IMAGE):$(DOCKER_TAG)"

push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

