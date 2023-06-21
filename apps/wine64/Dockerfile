FROM node:18.16.1@sha256:ad4e66ea59ae0d718be416296f606a3aebaaa616ce81f9f3e8286c391257bb52

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
