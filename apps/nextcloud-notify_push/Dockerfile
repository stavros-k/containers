FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

# https://github.com/nextcloud/notify_push/releases
ENV NOTIFY_PUSH_VERSION 0.7.0

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
