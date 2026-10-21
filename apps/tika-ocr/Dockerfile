FROM alpine:3.24.3@sha256:1b7232cda4ca3dc20b5d1247bdc9bfb631f2661d15d323bdd6fccc035ed1a9e7 AS tessdata

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

# renovate: datasource=github-tags depName=tesseract-ocr/tessdata_best
ENV TESSDATA_VERSION=4.1.0

# Upstream installs Ubuntu's `fast` models; `best` is slower but noticeably
# more accurate, which matters for accented Greek
RUN set -ex; \
	base="https://github.com/tesseract-ocr/tessdata_best/raw/${TESSDATA_VERSION}"; \
	\
	curl -fsSLo /ell.traineddata "$base/ell.traineddata"; \
	curl -fsSLo /eng.traineddata "$base/eng.traineddata"; \
	curl -fsSLo /osd.traineddata "$base/osd.traineddata"; \
	\
	ls -l /ell.traineddata /eng.traineddata /osd.traineddata

FROM apache/tika:4.1.0-full@sha256:ab9cc988828c594d32d6409e1850d1c8d83152ea793ef5fe0e7862ac0f9e5891

# Greek is missing from the languages upstream installs (eng ita fra spa deu jpn);
# osd drives orientation and script detection on skewed scans
COPY --from=tessdata /ell.traineddata /eng.traineddata /osd.traineddata /usr/share/tesseract-ocr/5/tessdata/

COPY ./config/tika-config.json /tika-config.json

# The base entrypoint appends these to the tika-server CLI
CMD ["-c", "/tika-config.json"]
