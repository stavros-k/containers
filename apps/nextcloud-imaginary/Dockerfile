# https://github.com/nextcloud/all-in-one/tree/main/Containers/imaginary
FROM golang:1.20.5-alpine3.17@sha256:5b56b276431ae41eb150f1728f9e621fdd6720acce0b0ff8500aeb057cd2e57e as go
RUN set -ex; \
    apk add --no-cache \
        vips-jxl \
        vips-dev \
        vips-heif \
        build-base \
        vips-magick \
        vips-poppler; \
    go install github.com/h2non/imaginary@b632dae8cc321452c3f85bcae79c580b1ae1ed84

FROM alpine:3.18.2@sha256:5246eec74dffc9a5f6608c4e7c81bd33455ecc64f558bf49eb334c4f05e47eee
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
