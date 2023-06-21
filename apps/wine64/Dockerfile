FROM node:18.16.1@sha256:5b5077523afa3111b6f84abe928c351c43f572b43eff25295d8f3d886d557a1a

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

# Install dependencies
RUN apt update && \
    apt install --install-recommends -y \
        nano \
        winehq-stable

USER 1000

# Run for ever
ENTRYPOINT "cat"
