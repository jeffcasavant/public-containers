FROM alpine as build

RUN apk add --update-cache \
    curl \
    unzip \
    && rm -rf /var/cache/apk/*

COPY version /version

WORKDIR /tmp

RUN curl -L https://github.com/ronoaldo/minetools/releases/download/$(cat /version)/contentdb-linux-amd64.zip > contentdb.zip

RUN unzip /tmp/contentdb.zip

FROM alpine AS final

COPY --from=build /tmp/dist/contentdb /usr/local/bin
