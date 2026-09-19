FROM opencloudeu/web-extensions:arcade-3.0.0@sha256:edde27eff55251c846fb8fb1b3b7f0356d43ce34bb14cb55b03f910fc797785d AS arcade
FROM opencloudeu/web-extensions:bpmn-1.1.0@sha256:fccf8d578bc2da3cfcd6a1a6b09e8fe25625aff194f5b6dda8caf5d46502c140 AS bpmn
FROM opencloudeu/web-extensions:calculator-2.1.0@sha256:44fa52cd3984ffb5accea3e1364b5f81c48a6941dfe86117a6339e2b9614bf7e AS calculator
FROM opencloudeu/web-extensions:draw-io-2.2.0@sha256:d890d6e1bea09cdb7f9f31e7e4ea3c22d00d48fed71202be435571fcefd99878 AS draw-io
FROM opencloudeu/web-extensions:external-sites-2.1.0@sha256:c0a48cd3c26f63c11d80b4138da26aa86baf05ec35d0e897ffc479ad24b99a01 AS external-sites
FROM opencloudeu/web-extensions:importer-2.0.0@sha256:24cc8e17da6790368ac0f3c8b32f28f29858ccc3b7effd174f9c9fda932949e8 AS importer
FROM opencloudeu/web-extensions:json-viewer-2.1.0@sha256:fe43f1bb92d62c283ea6ed4a8b8d069f8ff4cfcaa75acbdec08fd9c256705df4 AS json-viewer
FROM opencloudeu/web-extensions:maps-3.1.0@sha256:e0d8d8166266ff7fb0ba5dbba4800d086314a04d8e02eb65ca6524c9c421c124 AS maps
FROM opencloudeu/web-extensions:pastebin-2.1.0@sha256:e7d5686be8d581f48b3b4c0c3f468bec10dbaadeb935a00ac23a3644456455f0 AS pastebin
FROM opencloudeu/web-extensions:progress-bars-2.1.0@sha256:53933b5dbbae03b75e9cc78d775b8b8fd1d6bc651b73dfffcd66df120ef1c951 AS progress-bars
FROM opencloudeu/web-extensions:unzip-2.2.0@sha256:9dda5058dcd7f036342a80583a19b6a5d7af1d42cc1c4a678f38d5d8c3e30cb4 AS unzip

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

COPY --from=arcade /web/apps/arcade /apps/arcade
COPY --from=bpmn /web/apps/bpmn /apps/bpmn
COPY --from=calculator /web/apps/calculator /apps/calculator
COPY --from=draw-io /web/apps/draw-io /apps/draw-io
COPY --from=external-sites /web/apps/external-sites /apps/external-sites
COPY --from=importer /web/apps/importer /apps/importer
COPY --from=json-viewer /web/apps/json-viewer /apps/json-viewer
COPY --from=maps /web/apps/maps /apps/maps
COPY --from=pastebin /web/apps/pastebin /apps/pastebin
COPY --from=progress-bars /web/apps/progress-bars /apps/progress-bars
COPY --from=unzip /web/apps/unzip /apps/unzip
COPY --chmod=755 ./scripts/sync.sh /sync.sh

ENTRYPOINT ["/sync.sh"]
