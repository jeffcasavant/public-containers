FROM debian:bullseye AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/maubot/maubot.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM node:24 AS frontend-builder

COPY --from=download /app/maubot/management/frontend /frontend
RUN cd /frontend && yarn --prod && yarn build

FROM alpine:3.22

RUN apk add --no-cache \
        python3 py3-pip py3-setuptools py3-wheel \
        ca-certificates \
        su-exec \
        llvm-dev \
        yq \
        py3-aiohttp \
        py3-sqlalchemy \
        py3-attrs \
        py3-bcrypt \
        py3-cffi \
        py3-ruamel.yaml \
        py3-jinja2 \
        py3-click \
        py3-packaging \
        py3-markdown \
        py3-alembic \
#        py3-cssselect \
        py3-commonmark \
        py3-pygments \
        py3-tz \
#        py3-tzlocal \
        py3-regex \
        py3-wcwidth \
        # encryption
        py3-cffi \
        py3-olm \
        py3-pycryptodome \
        py3-unpaddedbase64 \
        py3-future \
        # plugin deps
        py3-opencv \
        py3-pillow \
        py3-magic \
        py3-feedparser \
        py3-dateutil \
        py3-lxml
#        py3-gitlab
#        py3-semver@edge
# TODO remove pillow, magic, feedparser, lxml, gitlab and semver when maubot supports installing dependencies


COPY --from=download /app/requirements.txt /opt/maubot/requirements.txt
COPY --from=download /app/optional-requirements.txt /opt/maubot/optional-requirements.txt
WORKDIR /opt/maubot
RUN apk add --virtual .build-deps python3-dev build-base git
RUN pip3 install --break-system-packages -r requirements.txt -r optional-requirements.txt
RUN pip3 install dateparser langdetect python-gitlab pyquery semver tzlocal cssselect ics nltk textblob
RUN apk del .build-deps
# TODO also remove dateparser, langdetect and pyquery when maubot supports installing dependencies

RUN mkdir -p /usr/share/nltk_data
RUN python3 -c 'import nltk; nltk.download("punkt"); nltk.download("punkt_tab"); nltk.download("averaged_perceptron_tagger_eng")'

COPY --from=download /app /opt/maubot
RUN cp maubot/example-config.yaml .
COPY --from=download /app/docker/mbc.sh /usr/local/bin/mbc
COPY --from=frontend-builder /frontend/build /opt/maubot/frontend
ENV UID=1337 GID=1337 XDG_CONFIG_HOME=/data
VOLUME /data

CMD ["/opt/maubot/docker/run.sh"]
