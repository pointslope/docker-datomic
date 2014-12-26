DOCKER_IMAGE=pointslope/datomic-pro-starter
DOCKER_TAG=0.9.5078

.PHONY: all clean info

all: Dockerfile
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

clean:
	docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG)

info:
	@echo "Docker image: $(DOCKER_IMAGE):$(DOCKER_TAG)"
