FROM python:3.7-slim-bullseye AS final

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip setuptools wheel
RUN pip install pipx

COPY version /version

RUN pipx install matrix-registration[postgres]==$(cat /version)

RUN pipx inject matrix-registration flask-limiter==2.0.0

ENTRYPOINT ["/root/.local/bin/matrix-registration"]
CMD ["serve"]
