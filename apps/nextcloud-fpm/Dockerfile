FROM nextcloud:28.0.4-fpm@sha256:38ffb1b0d3958af3f2fb78df5977a1c23e0a24aca4fc288b71e8ee4b63257904

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
        libfcgi-bin \
        heif-gdk-pixbuf \
        imagemagick-common \
        libmagickcore-6.q16-6-extra \
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

# See https://github.com/nextcloud/docker/issues/763
RUN set -ex; \
    \
    touch /usr/local/etc/php/conf.d/redis-session.ini; \
    touch /usr/local/etc/php-fpm.d/zz-tune.conf; \
    chmod 777 /usr/local/etc/php/conf.d/redis-session.ini; \
    chmod 777 /usr/local/etc/php-fpm.d/zz-tune.conf

# Copy post-install script to a temp location so we can append it to the entrypoint.sh
COPY --chmod=755 ./scripts/post-install.sh /tmp/post-install.sh
# Copy the configure-scripts that will be sourced by the post-install
COPY --chmod=755 ./configure-scripts /configure-scripts

# Copy the healthcheck
COPY --chmod=755 ./scripts/healthcheck.sh /healthcheck.sh

RUN set -ex; \
    sed -i 's/exec "$@"//g' /entrypoint.sh; \
    cat /tmp/post-install.sh >> /entrypoint.sh

COPY --chmod=755 ./scripts/occ /usr/bin/occ
COPY --chmod=755 ./scripts/cron.sh /cron.sh
