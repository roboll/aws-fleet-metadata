all: build

.phony: build
build:
	docker build -t roboll/aws-fleet-metadata .

release:
	docker push roboll/aws-fleet-metadata
