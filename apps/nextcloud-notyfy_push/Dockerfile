FROM alpine:3.17.3

RUN apk add --no-cache ca-certificates

# https://github.com/nextcloud/notify_push/releases
ENV NOTIFY_PUSH_VERSION 0.6.2

RUN set -ex; \
	\
	arch="aarch64"; \
	triplet="unknown-linux-musl"; \
	\
	wget --output-document --progress=dot:giga /usr/local/bin/notify_push "https://github.com/nextcloud/notify_push/releases/download/v${NOTIFY_PUSH_VERSION}/notify_push-$arch-$triplet"; \
	\
	chmod +x /usr/local/bin/notify_push; \
	notify_push --version

USER nobody

EXPOSE 7867

CMD ["notify_push"]
