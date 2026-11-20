# Build the Beeper GroupMe bridge (mautrix-go bridgev2) from source, tracking
# the git ref in `version`. Upstream publishes images only to a private Beeper
# registry. The build and runtime stages follow upstream's own Dockerfile,
# adapted to this repo's clone-and-checkout-`version` convention.

FROM golang:1.27-alpine3.23 AS builder

MAINTAINER jeff@casavant.org

RUN apk add --no-cache git ca-certificates build-base olm-dev

ARG REPO=https://github.com/beeper/groupme.git
WORKDIR /build

COPY version /version
RUN git clone "$REPO" . \
    && git checkout "$(cat /version)"

# build.sh stamps the binary with COMMIT_HASH; set it from the checkout.
RUN COMMIT_HASH="$(git rev-parse HEAD)" ./build.sh

##

FROM alpine:3.23

ENV UID=1337 \
    GID=1337

RUN apk add --no-cache su-exec ca-certificates olm bash jq yq-go curl

COPY --from=builder /build/mautrix-groupme /usr/bin/mautrix-groupme
COPY --from=builder /build/docker-run.sh /docker-run.sh
VOLUME /data
WORKDIR /data

CMD ["/docker-run.sh"]
