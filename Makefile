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
		go build -o $(REPO)-linux-amd64 -a -tags netgo -ldflags "-s -w" .

.phony: test
test: buildenv
	docker run \
		-v $(PWD):/go/src/github.com/$(OWNER)/$(REPO) \
		$(OWNER)/$(REPO).source \
		go get ./... && \
		go test ./...


###############################################################################
# release tasks
#
# `release` requires:
# - the checked out revision be a pushed tag (so the release is created)
# - the env variable GITHUB_TOKEN (for uploading the binary to github)
###############################################################################
ID_URL      = https://api.github.com/repos/$(OWNER)/$(REPO)/releases/tags/$(TAG)
ID          = $(shell curl -s -H "Authorization: token $(GITHUB_TOKEN)" $(ID_URL) | \
		python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")
RELEASE_URL = https://uploads.github.com/repos/$(OWNER)/$(REPO)/releases/$(ID)/assets

.phony: github-token
github-token:
ifndef GITHUB_TOKEN
	$(error $GITHUB_TOKEN not set)
endif

.phony: tag
tag:
	git describe --tags --exact-match HEAD

.phony: release
release: build test tag
	curl -s -XPOST \
		-H "Authorization: token $(GITHUB_TOKEN)" \
		-H "Content-Type: application/octet-stream" \
		$(RELEASE_URL)?name=$(REPO)-linux-amd64 \
		--data-binary @$(REPO)-linux-amd64
