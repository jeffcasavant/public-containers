FROM debian:bullseye AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/chatbot-smooth/whisper-matrix-plugin.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM python:3.10-slim-bullseye AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=download /app /app

WORKDIR /app

RUN python -m venv venv
RUN ./venv/bin/pip install -U pip setuptools wheel
RUN ./venv/bin/pip install -r requirements.txt

ENTRYPOINT ["/app/venv/bin/python"]
CMD ["transcriptorbot.py"]
