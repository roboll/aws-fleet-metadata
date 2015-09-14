all: build

VER := $(shell git describe --tags)

.phony: build
build:
	docker build -t roboll/aws-fleet-metadata:latest .

.phony: tag
tag: build
	docker tag roboll/aws-fleet-metadata roboll/aws-fleet-metadata:$(VER)

.phony: release
release: tag
	docker push roboll/aws-fleet-metadata:$(VER)
	docker push roboll/aws-fleet-metadata:latest
