FROM debian:bookworm AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get install -y wget

COPY version /version

WORKDIR /app

RUN wget https://github.com/leafac/kill-the-newsletter/releases/download/$(cat /version)/kill-the-newsletter--linux--$(cat /version).tgz -O ktn.tgz
RUN tar -xf ktn.tgz

##

FROM node:21-bookworm-slim AS final

ENV NODE_ENV=production

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=download /app /app

WORKDIR /app

CMD ["./kill-the-newsletter", "/configuration.js"]
