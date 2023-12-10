FROM debian:bookworm AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/leafac/kill-the-newsletter.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM node:21-bookworm AS install

COPY --from=download /app /app

WORKDIR /app

RUN npm install

##

FROM node:21-bookworm-slim AS final

ENV NODE_ENV=production

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=install /app /app

WORKDIR /app

CMD ["./kill-the-newsletter", "/configuration.js"]
