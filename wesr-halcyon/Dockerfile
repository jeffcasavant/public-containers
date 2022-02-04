FROM python:3.10-slim-bullseye AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip setuptools wheel
RUN pip install -U halcyon

ENTRYPOINT ["python3", "-m", "halcyon"]
