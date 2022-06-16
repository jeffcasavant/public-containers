FROM debian:bullseye AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://gitlab.com/mx-puppet/discord/mx-puppet-discord.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM node:14-bullseye AS install

COPY --from=download /app /app

WORKDIR /app

RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts

RUN npm install

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
