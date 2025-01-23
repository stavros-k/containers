FROM node:23.6.1@sha256:3b73c4b366d490f76908dda253bb4516bbb3398948fd880d8682c5ef16427eca

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
