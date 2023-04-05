# From https://github.com/h2non/imaginary/blob/master/Dockerfile
FROM nextcloud/imaginary:20230401@sha256:91d3ef54422870569e5e047027915cc61c6ff154fb7203c11ce4ed2f0f58dc06
# https://github.com/nextcloud/all-in-one/blob/main/Containers/imaginary/Dockerfile

USER root

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
    ; \
    echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list.d/bookworm.list; \
    apt-get update; \
    apt-get install -t bookworm -y --no-install-recommends \
        libheif1 \
        libde265-0 \
        libx265-199 \
        libvips \
    ; \
    rm /etc/apt/sources.list.d/bookworm.list; \
    rm -rf /var/lib/apt/lists/*

USER nobody

# https://github.com/h2non/imaginary#memory-issues
ENV MALLOC_ARENA_MAX=2

ENTRYPOINT ["/usr/local/bin/imaginary"]
