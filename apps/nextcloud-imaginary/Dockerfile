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
    go install github.com/h2non/imaginary@1d4e251cfcd58ea66f8361f8721d7b8cc85002a3

FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099
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
