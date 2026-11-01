# Build redlib from source, tracking the `main` branch (see version) of the
# Nachtalb fork (REPO below).
#
# Why a custom build instead of quay.io/redlib/redlib:latest? The official
# prebuilt image went stale and shipped a broken OAuth build
# (redlib-org/redlib#551). Why the fork? Reddit started answering upstream's
# anonymous JSON requests with 403s, and the fork's fallbacks still load pages
# (redlib-org/redlib#446). Its maintainer is working on merging it upstream;
# once that lands, point REPO back at redlib-org/redlib. This mirrors the
# upstream Dockerfile.ubuntu, adapted to this repo's clone-and-checkout-
# `version` convention.

FROM rust:slim-trixie AS builder

MAINTAINER jeff@casavant.org

RUN apt-get update \
    && apt-get -y install git build-essential cmake perl pkg-config libclang-dev \
    && rm -rf /var/lib/apt/lists/*

ARG REPO=https://github.com/Nachtalb/redlib.git
WORKDIR /redlib

# Full clone (not shallow): redlib's build.rs derives the version string from
# git history, so the .git dir must be present and complete at build time.
COPY version /version
RUN git clone "$REPO" . \
    && git checkout "$(cat /version)"

RUN cargo build --release --locked --bin redlib \
    && echo "finished building redlib!"

##

FROM ubuntu:resolute AS release

# wget backs the HEALTHCHECK below.
RUN apt-get update \
    && apt-get -y install wget \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /redlib/target/release/redlib /usr/local/bin/redlib

RUN useradd \
    --no-create-home \
    --password "!" \
    --comment "user for running redlib" \
    redlib
USER redlib

EXPOSE 8080

HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider -q http://localhost:8080/settings || exit 1

CMD ["redlib"]
