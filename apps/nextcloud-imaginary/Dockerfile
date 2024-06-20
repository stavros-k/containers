# https://github.com/nextcloud/all-in-one/tree/main/Containers/imaginary
FROM golang:1.21.5-alpine3.17@sha256:92cb87af996ec6befc85f0aec27e12ead2fab396695fa8a7abff79e021e58195 as go
RUN set -ex; \
    apk add --no-cache \
        vips-jxl \
        vips-dev \
        vips-heif \
        build-base \
        vips-magick \
        vips-poppler; \
    go install github.com/h2non/imaginary@6cd9edd1d3fb151eb773c14552886e4fc8e50138

FROM alpine:3.20.1@sha256:ff5265e55d2f71d89d17ee63a634e37686637d2e2c8e76e57837e010c8666904
RUN set -ex; \
    apk add --no-cache \
        vips \
        curl \
        tzdata \
        vips-jxl \
        vips-heif \
        vips-magick \
        vips-poppler \
        ca-certificates

COPY --from=go /go/bin/imaginary /usr/local/bin/imaginary

USER nobody

# https://github.com/h2non/imaginary#memory-issues
ENV MALLOC_ARENA_MAX=2

ENTRYPOINT ["imaginary", "-p", "${PORT:-9000}"]
