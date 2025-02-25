FROM nextcloud:30.0.6-fpm@sha256:eb0c7249db7a03d0a18dddb3d33722030892a4da6fd97cd88002c3317cb0bec6

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

# # Copy post-install script to a temp location so we can append it to the entrypoint.sh
# COPY --chmod=755 ./scripts/post-install.sh /tmp/post-install.sh

# RUN set -ex; \
#     sed -i 's/exec "$@"//g' /entrypoint.sh; \
#     cat /tmp/post-install.sh >> /entrypoint.sh

COPY --chmod=755 ./scripts/occ /usr/bin/occ
COPY --chmod=755 ./scripts/cron.sh /cron.sh
