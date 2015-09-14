FROM golang

ADD . /go/src/github.com/roboll/aws-fleet-metadata

WORKDIR /go/src/github.com/roboll/aws-fleet-metadata

CMD go get ./... && \
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' .
