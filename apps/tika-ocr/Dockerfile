FROM alpine:3.24.3@sha256:b3413572228e34bd1c9245f5565e6cd127005655e8a7899aef33d8e83255c9e6 AS tessdata

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

FROM apache/tika:4.1.0-full@sha256:d69fab827fa004a5e1db786e6d78da947a6cfeedbf595bc5c353ef99622bb2e2

# Greek is missing from the languages upstream installs (eng ita fra spa deu jpn);
# osd drives orientation and script detection on skewed scans
COPY --from=tessdata /ell.traineddata /eng.traineddata /osd.traineddata /usr/share/tesseract-ocr/5/tessdata/

COPY ./config/tika-config.json /tika-config.json

# The base entrypoint appends these to the tika-server CLI
CMD ["-c", "/tika-config.json"]
