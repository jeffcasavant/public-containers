FROM debian:bullseye AS download

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/zeratax/matrix-registration.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM python:3.7-slim-bullseye AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip setuptools wheel
RUN pip install pipx

COPY --from=download /app /app
COPY --from=download /version /version

WORKDIR /app

RUN pipx install .[postgres]
RUN pipx inject matrix-registration flask-limiter==2.0.0
RUN pipx inject matrix-registration requests

ENTRYPOINT ["/root/.local/bin/matrix-registration"]
CMD ["serve"]
