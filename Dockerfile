###############################################################################
# image: roboll/aws-fleet-metadata
#
# Expose aws tags as fleet metadata.
###############################################################################
FROM alpine:3.1

MAINTAINER rob boll <rob@kitkit.io>

RUN apk -U add python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

ADD ./bin/jq-linux64-1.5 /bin/jq
ADD ./bin/get-aws-metadata /bin/get-aws-metadata

CMD [ '/bin/get-aws-metadata' ]
