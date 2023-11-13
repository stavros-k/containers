FROM node:20.9.0@sha256:5f21943fe97b24ae1740da6d7b9c56ac43fe3495acb47c1b232b0a352b02a25c

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN npm install -g npm
RUN npm -v && node -v
RUN which npm && which node


# Install dependencies
RUN apt update && \
    apt install --install-recommends -y \
        nano \
        pre-commit \
        qrencode \
        winehq-stable && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:node_modules/.bin"

RUN mkdir -p /.cache
RUN chown -R 1000:1000 /.cache

USER 1000

# Run for ever
ENTRYPOINT "cat"
