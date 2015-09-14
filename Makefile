all: build

OWNER := roboll
REPO  := aws-fleet-metadata
TAG   := $(shell git describe --tags)

.phony: buildenv
buildenv:
	docker build -t $(REPO).source .

.phony: build
build: buildenv
	docker run \
		-v $(PWD):/go/src/github.com/$(OWNER)/$(REPO) \
		$(OWNER)/$(REPO).source \
		go get ./... && \
		CGO_ENABLED=0 GOOS=linux \
		go build -o $(REPO)-linux-amd64 -a -tags netgo -ldflags -w .

.phony: test
test: buildenv
	docker run \
		-v $(PWD):/go/src/github.com/$(OWNER)/$(REPO) \
		$(OWNER)/$(REPO).source \
		go get ./... && \
		go test ./...

.phony: tag
tag:
	git describe --tags --exact-match HEAD

ID_URL      = https://api.github.com/repos/$(OWNER)/$(REPO)/releases/tags/$(TAG)
ID          = $(shell curl -s -H \
	       "Authorization: token 313a5b35219b60d58fbe8bf77d8d2e9cdf2ccdfd" \
	       $(ID_URL) | python -c \
	       "import json,sys;obj=json.load(sys.stdin);print obj['id'];")
RELEASE_URL = https://uploads.github.com/repos/$(OWNER)/$(REPO)/releases/$(ID)/assets

.phony: release
release: build test tag
	echo $(ID_URL)
	echo $(ID)
	echo $(RELEASE_URL)
	$(shell echo 'curl -s -XPOST \
		-H "Authorization: token 313a5b35219b60d58fbe8bf77d8d2e9cdf2ccdfd" \
		-H "Content-Type: application/octet-stream" \
		$(RELEASE_URL)?name=$(REPO)-linux-amd64 \
		--data-binary @$(REPO)-linux-amd64')
