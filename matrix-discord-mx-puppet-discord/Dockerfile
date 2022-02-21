FROM debian:bullseye AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/matrix-discord/mx-puppet-discord.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM node:14-bullseye AS install

COPY --from=download /app /app

WORKDIR /app

RUN apt-get update
RUN apt-get -y install jq

RUN cat package.json | jq 'del(.dependencies."better-discord.js")' > package.json.tmp && mv package.json.tmp package.json
RUN rm package-lock.json

RUN npm install
RUN npm install "https://github.com/Sorunome/better-discord.js.git"

##

FROM node:14-bullseye-slim AS final

ENV NODE_ENV=production

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=install /app /app

WORKDIR /app

ENTRYPOINT ["npm", "run"]
CMD ["start"]
