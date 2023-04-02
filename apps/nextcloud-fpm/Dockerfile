FROM docker.io/nextcloud:26.0.0-fpm@sha256:eae45cef8085a73b5c0508a40240ae981a2603596ba1032e25c048f379660e6e

ENV NEXTCLOUD_FPM_VERSION 26.0.0-fpm

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
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
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

RUN set -ex; \
    sed -i 's/exec "$@"//g' /entrypoint.sh; \
    cat /tmp/post-install.sh >> /entrypoint.sh

COPY --chmod=755 ./scripts/occ /usr/bin/occ
COPY --chmod=755 ./scripts/cron.sh /cron.sh
