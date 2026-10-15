FROM debian:trixie-slim AS download

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY version /version

WORKDIR /tmp

RUN curl -L https://github.com/ronoaldo/minetools/releases/download/$(cat /version)/minetools_linux_amd64.zip > contentdb.zip

RUN unzip /tmp/contentdb.zip

###

FROM debian:trixie-slim AS final

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=download /tmp/contentdb /usr/local/bin

RUN chmod +x /usr/local/bin/contentdb

WORKDIR /

ENTRYPOINT ["/usr/local/bin/contentdb"]
