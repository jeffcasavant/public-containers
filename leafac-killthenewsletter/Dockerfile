FROM debian:trixie AS download

MAINTAINER jeff@casavant.org

RUN apt-get update && apt-get install -y wget

COPY version /version

WORKDIR /app

RUN wget https://github.com/leafac/kill-the-newsletter/releases/download/$(cat /version)/kill-the-newsletter--ubuntu--$(cat /version).tar.gz -O ktn.tgz
RUN tar -xf ktn.tgz

##

# The release bundles its own Node.js and Caddy.
FROM debian:trixie-slim AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install libatomic1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=download /app/kill-the-newsletter /app/kill-the-newsletter

WORKDIR /app

CMD ["./kill-the-newsletter/kill-the-newsletter", "/configuration.mjs"]
