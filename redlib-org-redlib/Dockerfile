# Build redlib from source, tracking the `main` branch (see version).
#
# Why a custom build instead of quay.io/redlib/redlib:latest? The official
# prebuilt image went stale (~15 commits behind) and is built with an unset
# TARGET arg that produces an incomplete binary, breaking Reddit OAuth so the
# app never serves a page. See redlib-org/redlib#551. The latest tagged release
# (v0.36.0, Mar 2025) predates the OAuth fix, which lives only in post-release
# `main` commits, so we track `main` and rebuild nightly. This mirrors the
# upstream Dockerfile.ubuntu (the known-good build), adapted to this repo's
# clone-and-checkout-`version` convention.

FROM rust:slim-bookworm AS builder

MAINTAINER jeff@casavant.org

RUN apt-get update \
    && apt-get -y install git build-essential cmake libclang-dev \
    && rm -rf /var/lib/apt/lists/*

ARG REPO=https://github.com/redlib-org/redlib.git
WORKDIR /redlib

# Full clone (not shallow): redlib's build.rs derives the version string from
# git history, so the .git dir must be present and complete at build time.
COPY version /version
RUN git clone "$REPO" . \
    && git checkout "$(cat /version)"

RUN cargo build --release --locked --bin redlib \
    && echo "finished building redlib!"

##

FROM ubuntu:noble AS release

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
