FROM node:20.12.1@sha256:d1b84e4aa4b90f6bb9640d87bd5e45ed4f79f782fb00ee7c62e72dfcedfa2f62

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
