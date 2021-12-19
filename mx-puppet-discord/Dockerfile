FROM debian:bullseye AS download

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/matrix-discord/mx-puppet-discord.git
RUN git clone $REPO /app

##

FROM node:14-bullseye AS install

COPY --from=download /app /app

WORKDIR /app

RUN npm install

##

FROM node:14-bullseye-slim AS final

COPY --from=install /app /app

WORKDIR /app

ENTRYPOINT ["npm", "run"]
CMD ["start"]
