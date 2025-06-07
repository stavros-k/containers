FROM nextcloud:31.0.5-fpm@sha256:8423d66227934466abc95904d2b542cb4fea6fc6065dfa51d27cb180a36f430c

# hadolint ignore=DL3008
# hadolint ignore=DL4006
# hadolint ignore=SC2086
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        jq \
        nano \
        procps \
        ffmpeg \
        libheif1 \
        smbclient \
        libde265-0 \
        libreoffice\
        libfcgi-bin \
        heif-gdk-pixbuf \
        imagemagick-common \
    ; \
    \
    # This command returns the list of manually installed packages
    savedAptMark="$(apt-mark showmanual)"; \
    \
    # Install the build dependencies
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libkrb5-dev \
        libc-client-dev \
        libsmbclient-dev \
        libmagickcore-dev \
    ; \
    \
    # Configure the IMAP extension to use Kerberos authentication and SSL.
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    # Install the PHP extensions
    docker-php-ext-install \
        # Bzip2 Compression Algorithm
        bz2 \
        imap \
    ; \
    # Install smbclient from PECL
    pecl install smbclient; \
    # Enable smbclient extension
    docker-php-ext-enable smbclient; \
    \
    # Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    # Set the packages that were manually installed back to "manual"
    apt-mark manual $savedAptMark; \
    \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    # Remove build dependencies and packages that are no longer needed
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    # Remove the apt cache
    rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=aptible/supercronic
ENV SUPERCRONIC_VERSION=v0.2.33
ENV SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64"
RUN curl -fsSL "${SUPERCRONIC_URL}" -o /usr/local/bin/supercronic && \
    chmod +x /usr/local/bin/supercronic

# renovate: datasource=github-releases depName=mikefarah/yq
ENV YQ_VERSION=v4.45.4
ENV YQ_URL="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"
RUN curl -fsSL "${YQ_URL}" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# See https://github.com/nextcloud/docker/issues/763
RUN set -ex; \
    \
    touch /usr/local/etc/php/conf.d/redis-session.ini; \
    chmod 777 /usr/local/etc/php/conf.d/redis-session.ini

# Copy the configure-scripts that will be sourced by the post-install
COPY --chmod=755 ./configure-scripts /configure-scripts

# Copy the healthcheck
COPY --chmod=755 ./scripts/healthcheck.sh /healthcheck.sh

# Copy post-install script to the `before-starting` hooks dir so nextcloud will run those automatically.
COPY --chmod=755 ./scripts/post-install.sh /docker-entrypoint-hooks.d/before-starting/10-post-install.sh
# Wrapper for nextcloud occ
COPY --chmod=755 ./scripts/occ /usr/bin/occ

# Wrapper for nextcloud cron.php
COPY --chmod=755 ./scripts/php-cron /php-cron

# Cron daemon
COPY --chmod=755 ./scripts/cron.sh /cron.sh
