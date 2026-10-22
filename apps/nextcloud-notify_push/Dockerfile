FROM alpine:3.24.3@sha256:b3413572228e34bd1c9245f5565e6cd127005655e8a7899aef33d8e83255c9e6

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

# renovate: datasource=github-releases depName=nextcloud/notify_push
ENV NOTIFY_PUSH_VERSION=1.4.2

RUN set -ex; \
	arch="x86_64"; \
	triplet="unknown-linux-musl"; \
	\
	wget -q -O /usr/local/bin/notify_push "https://github.com/nextcloud/notify_push/releases/download/v${NOTIFY_PUSH_VERSION}/notify_push-$arch-$triplet"; \
	\
	chmod +x /usr/local/bin/notify_push; \
	notify_push --version

USER nobody

COPY --chmod=775 ./scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
