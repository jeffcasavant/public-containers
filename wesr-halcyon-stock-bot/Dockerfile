FROM debian:bullseye AS download

MAINTAINER jeff@casavant.org

RUN apt-get update
RUN apt-get -y install git

ARG REPO=https://github.com/WesR/Halcyon-stock-bot.git
RUN git clone $REPO /app

WORKDIR /app

COPY version /version
RUN git checkout $(cat /version)

##

FROM jeffcasavant/wesr-halcyon AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip setuptools wheel
RUN pip install -U "halcyon>=1.1.1"

COPY --from=download /app /app

WORKDIR /app

ENTRYPOINT ["python3"]
CMD ["bot.py"]
