FROM node:23.3.0@sha256:a2fea8b0b74b6e828caa6d83f4b2a0dcb2eb1ff90f30205c32f7bd36ddf976c4

ARG PRE_COMMIT_VERSION=4.0.1

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN npm install -g npm
RUN npm -v && node -v
RUN which npm && which node

RUN apt update
RUN apt install --install-recommends -y nano winehq-stable
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

RUN curl https://github.com/pre-commit/pre-commit/releases/download/v${PRE_COMMIT_VERSION}/pre-commit-${PRE_COMMIT_VERSION}.pyz -o /usr/local/bin/pre-commit
RUN chmod +x /usr/local/bin/pre-commit
RUN pre-commit --version

ENV PATH="${PATH}:node_modules/.bin"

RUN mkdir -p /.cache
RUN chown -R 1000:1000 /.cache

USER 1000

# Run for ever
ENTRYPOINT ["cat"]
