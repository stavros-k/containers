FROM alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

# https://github.com/nextcloud/notify_push/releases
ENV NOTIFY_PUSH_VERSION 0.6.12

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
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
