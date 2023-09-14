FROM node:18.17.1@sha256:933bcfad91e9052a02bc29eb5aa29033e542afac4174f9524b79066d97b23c24

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN curl -fsSL https://bun.sh/install | bash

# Install dependencies
RUN apt update && \
    apt install --install-recommends -y \
        nano \
        pre-commit \
        winehq-stable && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:node_modules/.bin:~/.bun/bin"

RUN mkdir -p /.cache
RUN chown -R 1000:1000 /.cache

USER 1000

# Run for ever
ENTRYPOINT "cat"
