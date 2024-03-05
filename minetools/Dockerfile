FROM debian:bookworm-slim as download

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY version /version

WORKDIR /tmp

RUN curl -L https://github.com/ronoaldo/minetools/releases/download/$(cat /version)/contentdb-linux-amd64.zip > contentdb.zip

RUN unzip /tmp/contentdb.zip

###

FROM debian:bookworm-slim AS final

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=download /tmp/dist/contentdb /usr/local/bin

RUN chmod +x /usr/local/bin/contentdb

WORKDIR /

ENTRYPOINT ["/usr/local/bin/contentdb"]
