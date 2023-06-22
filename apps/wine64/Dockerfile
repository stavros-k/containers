FROM node:18.16.1@sha256:19892542dd80e33aec50a51619ab36db0921de240c6a4ff6024d801f84881293

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

# Install dependencies
RUN apt update && \
    apt install --install-recommends -y \
        nano \
        python3-pip \
        winehq-stable

# Install pre-commit
RUN pip3 install pre-commit

RUN mkdir -p /.cache
RUN chown -R 1000:1000 /.cache

USER 1000

# Run for ever
ENTRYPOINT "cat"
