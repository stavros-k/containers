FROM node:22.0.0@sha256:cbd62dc7ba7e50d01520f2c0a8d9853ec872187fa806ed61d0f87081c220386d

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
