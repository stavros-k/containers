FROM alpine:3.24.4@sha256:93b41ef40b1677fce8fcc64ff4af09daddfacf5040afde618bc46c1e2d1cc7d4 AS tessdata

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

FROM apache/tika:4.2.0-full@sha256:4774eaac44f86cdf648ae7b5a367016eaf6f9052adec31e5cff07cff1a0c6e24

# Greek is missing from the languages upstream installs (eng ita fra spa deu jpn);
# osd drives orientation and script detection on skewed scans
COPY --from=tessdata /ell.traineddata /eng.traineddata /osd.traineddata /usr/share/tesseract-ocr/5/tessdata/

COPY ./config/tika-config.json /tika-config.json

# The base entrypoint appends these to the tika-server CLI
CMD ["-c", "/tika-config.json"]
