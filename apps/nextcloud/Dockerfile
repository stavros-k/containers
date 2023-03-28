FROM docker.io/nextcloud:26.0.0-fpm@sha256:eae45cef8085a73b5c0508a40240ae981a2603596ba1032e25c048f379660e6e

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        nano \
        jq \
        imagemagick-common \
        ffmpeg \
        libmagickcore-6.q16-6-extra \
        libmagickcore-dev \
        libde265-0 \
        heif-gdk-pixbuf \
        libheif1 \
        procps \
        smbclient \
    ; \

    # Below installs / php installs / ldd are borrowed from Nextcloud examples.
    savedAptMark="$(apt-mark showmanual)"; \

    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libkrb5-dev \
        libsmbclient-dev \
    ; \

    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bz2 \
        imap \
    ; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \

    # Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \

    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

# See https://github.com/nextcloud/docker/issues/763
RUN set -ex; \
    \
    touch /usr/local/etc/php/conf.d/redis-session.ini; \
    chmod 777 /usr/local/etc/php/conf.d/redis-session.ini

# Copy all scripts in the entrypoint.d/
COPY --chmod=755 ./scritps/ /entrypoint.d/

# Remove the exec "$@" from the original entrypoint
# and move it in the entrypoint.d/ with 00- prefix.
RUN set -ex; \
    sed -i 's/exec "$@"//g' /entrypoint.sh; \
    mv /entrypoint.sh /scripts/00-original-entrypoint.sh

# Copy the "new" entrypoint as the normal entrypoint.sh
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh
