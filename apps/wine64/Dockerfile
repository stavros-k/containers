FROM node:23.7.0@sha256:0bcc32c2d59aa8bf416a43be9672a59fa1b9f0f0fbdb6fe069d67e7be2f98e9e

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
