# Nextcloud Configuration

## Environment Variables

### General

| Variable                      | Description                            |  App(s)  |     Config Key(s)      |  Default   |   Example   |
| ----------------------------- | -------------------------------------- | :------: | :--------------------: | :--------: | :---------: |
| `NX_RUN_OPTIMIZE`             | Runs optimize/repair/migration scripts |          |                        |   `true`   |   `false`   |
| `NX_MAINTENANCE_WINDOW_START` | Sets the maintenance window start      |          |                        |   `100`    |     `1`     |
| `NX_DEFAULT_PHONE_REGION`     | Default phone region                   | `system` | `default_phone_region` |    `GR`    |    `US`     |
| `NX_SHARED_FOLDER_NAME`       | Name of shared folder                  | `system` |  `share_folder_name`   |    `/`     |  `Shared`   |
| `NX_MAX_CHUNK_SIZE`           | Maximum chunk size                     | `files`  |    `max_chunk_size`    | `10485760` | `104857600` |

### Logging

| Variable             | Description     |  App(s)  |  Config Key(s)  |              Default               |        Example        |
| -------------------- | --------------- | :------: | :-------------: | :--------------------------------: | :-------------------: |
| `NX_LOG_LEVEL`       | Log level       | `system` |   `loglevel`    |                `2`                 |          `0`          |
| `NX_LOG_FILE`        | Log file        | `system` |    `logfile`    | `/var/www/html/data/nextcloud.log` | `/logs/nextcloud.log` |
| `NX_LOG_FILE_AUDIT`  | Audit log file  | `system` | `logfile_file`  |   `/var/www/html/data/audit.log`   |   `/logs/audit.log`   |
| `NX_LOG_DATE_FORMAT` | Log date format | `system` | `logdateformat` |           `d/m/Y H:i:s`            |    `D d/m/Y H:i:s`    |
| `NX_LOG_TIMEZONE`    | Log timezone    | `system` |  `logtimezone`  |               `$TZ`                |    `Europe/Athens`    |

### URLs

| Variable                | Description                             |  App(s)  |    Config Key(s)    | Default |                  Example                   |
| ----------------------- | --------------------------------------- | :------: | :-----------------: | :-----: | :----------------------------------------: |
| `NX_TRUSTED_DOMAINS`    | Space Separated list of Trusted domains | `system` |  `trusted_domains`  |  `""`   |       `localhost cloud.example.com`        |
| `NX_TRUSTED_PROXIES`    | Space Separated list of Trusted proxies | `system` |  `trusted_proxies`  |  `""`   | `10.0.0.0/8 172.16.0.0./12 192.168.0.0/16` |
| `NX_OVERWRITE_HOST`     | Overwrite host                          | `system` |   `overwritehost`   |  `""`   |            `cloud.example.com`             |
| `NX_OVERWRITE_CLI_URL`  | Overwrite CLI URL                       | `system` | `overwrite.cli.url` |  `""`   |        `https://cloud.example.com`         |
| `NX_OVERWRITE_PROTOCOL` | Overwrite protocol                      | `system` | `overwriteprotocol` |  `""`   |                  `https`                   |

### Notify Push

| Variable                  | Description                         |    App(s)     |      Config Key(s)       | Default |             Example              |
| ------------------------- | ----------------------------------- | :-----------: | :----------------------: | :-----: | :------------------------------: |
| `NX_NOTIFY_PUSH`          | Enable Nextcloud Push Notifications | `notify_push` | See `NX_NOTIFY_PUSH_URL` | `true`  |             `false`              |
| `NX_NOTIFY_PUSH_ENDPOINT` | Nextcloud Push Notifications URL    | `notify_push` |     `base_endpoint`      |  `""`   | `https://cloud.example.com/push` |

### Expiration/Retention

| Variable                  | Description                      |   App(s)   |          Config Key(s)          | Default | Example |
| ------------------------- | -------------------------------- | :--------: | :-----------------------------: | :-----: | :-----: |
| `NX_ACTIVITY_EXPIRE_DAYS` | Expire days for activity app     | `activity` |     `activity_expire_days`      |  `365`  |  `90`   |
| `NX_TRASH_RETENTION`      | Retention time for deleted files |  `system`  | `trashbin_retention_obligation` | `auto`  | `30,60` |
| `NX_VERSION_RETENTION`    | Retention time for old versions  |  `system`  | `versions_retention_obligation` | `auto`  | `30,60` |

### Redis

| Variable        | Description    |  App(s)  |  Config Key(s)   | Default |    Example    |
| --------------- | -------------- | :------: | :--------------: | :-----: | :-----------: |
| `NX_REDIS`      | Enable Redis   |          |                  | `true`  |    `false`    |
| `NX_REDIS_HOST` | Redis Host     | `system` |   `redis:host`   |  `""`   | `redis.local` |
| `NX_REDIS_PASS` | Redis Password | `system` | `redis:password` |  `""`   |  `my-secret`  |
| `NX_REDIS_PORT` | Redis Port     | `system` |   `redis:port`   | `6379`  |    `1234`     |

### Database

| Variable               | Description                |  App(s)  | Config Key(s) | Default |     Example     |
| ---------------------- | -------------------------- | :------: | :-----------: | :-----: | :-------------: |
| `NX_POSTGRES_HOST`     | Postgres Database Host     | `system` |   `dbhost`    |  `""`   | `192.168.1.100` |
| `NX_POSTGRES_NAME`     | Postgres Database Name     | `system` |   `dbname`    |  `""`   |   `nextcloud`   |
| `NX_POSTGRES_USER`     | Postgres Database User     | `system` |   `dbuser`    |  `""`   |   `nextcloud`   |
| `NX_POSTGRES_PASSWORD` | Postgres Database Password | `system` | `dbpassword`  |  `""`   |   `my-secret`   |
| `NX_POSTGRES_PORT`     | Postgres Database Port     | `system` |   `dbport`    | `5432`  |     `5555`      |

### Previews

| Variable                        | Description                                                                             |            App(s)             |                                           Config Key(s)                                            |  Default  |    Example     |
| ------------------------------- | --------------------------------------------------------------------------------------- | :---------------------------: | :------------------------------------------------------------------------------------------------: | :-------: | :------------: |
| `NX_PREVIEWS`                   | Enable Previews (Forced enabled if Imaginary is enabled)                                | `system` / `previewgenerator` | `system:enable_previews`, `system:enablePreviewProviders` and see `NX_PREVIEW_`, `NX_JPEG_QUALITY` |  `true`   |    `false`     |
| `NX_IMAGINARY`                  | Enable Imaginary                                                                        |           `system`            |                                      `preview_imaginary_url`                                       |  `true`   |    `false`     |
| `NX_PREVIEW_PROVIDERS`          | Space Separated list of Preview providers (Imaginary is added automatically if enabled) |           `system`            |                                     `enabledPreviewProviders`                                      |   `""`    | `JPEG PNG BPM` |
| `NX_PREVIEW_MAX_X`              | Maximum width of preview image                                                          |           `system`            |                                          `preview_max_x`                                           |  `2048`   |     `1024`     |
| `NX_PREVIEW_MAX_Y`              | Maximum height of preview image                                                         |           `system`            |                                          `preview_max_y`                                           |  `2048`   |     `1024`     |
| `NX_PREVIEW_MAX_MEMORY`         | Maximum memory for preview image                                                        |           `system`            |                                        `preview_max_memory`                                        |  `1024`   |     `512`      |
| `NX_PREVIEW_MAX_FILESIZE_IMAGE` | Maximum file size for image previews                                                    |           `system`            |                                    `preview_max_filesize_image`                                    |   `50`    |      `25`      |
| `NX_JPEG_QUALITY`               | JPEG Quality for previews                                                               | `system` / `previewgenerator` |                           `system:jpeg_quality` / `preview:jpeg_quality`                           |   `60`    |      `80`      |
| `NX_PREVIEW_HEIGHT_SIZES`       | Preview height sizes                                                                    |      `previewgenerator`       |                                           `heightSizes`                                            |   `256`   |     `512`      |
| `NX_PREVIEW_WIDTH_SIZES`        | Preview width sizes                                                                     |      `previewgenerator`       |                                            `widthSizes`                                            | `256 384` |   `512 1024`   |
| `NX_PREVIEW_SQUARE_SIZES`       | Preview square sizes                                                                    |      `previewgenerator`       |                                           `squareSizes`                                            | `32 256`  |    `64 512`    |

### ClamAV

| Variable                      | Description              |      App(s)       |     Config Key(s)      |  Default   |    Example     |
| ----------------------------- | ------------------------ | :---------------: | :--------------------: | :--------: | :------------: |
| `NX_CLAMAV`                   | Enable ClamAV            |                   |                        |  `false`   |     `true`     |
| `NX_CLAMAV_HOST`              | ClamAV Host              | `files_antivirus` |       `av_host`        |    `""`    | `clamav.local` |
| `NX_CLAMAV_PORT`              | ClamAV Port              | `files_antivirus` |       `av_port`        |    `""`    |     `3310`     |
| `NX_CLAMAV_STREAM_MAX_LENGTH` | ClamAV Stream Max Length | `files_antivirus` | `av_stream_max_length` | `26214400` |   `1048576`    |
| `NX_CLAMAV_MAX_FILE_SIZE`     | ClamAV Max File Size     | `files_antivirus` |   `av_max_file_size`   |    `-1`    |   `1048576`    |
| `NX_CLAMAV_INFECTED_ACTION`   | ClamAV Infected Action   | `files_antivirus` |  `av_infected_action`  | `only_log` |    `delete`    |

### Collabora

| Variable                    | Description                                 |     App(s)      |   Config Key(s)   | Default |             Example             |
| --------------------------- | ------------------------------------------- | :-------------: | :---------------: | :-----: | :-----------------------------: |
| `NX_COLLABORA`              | Enable Collabora                            |                 |                   | `false` |             `true`              |
| `NX_COLLABORA_INTERNAL_URL` | Collabora Internal URL                      | `richdocuments` |    `wopi_url`     |  `""`   |     `http://collabora:9980`     |
| `NX_COLLABORA_URL`          | Collabora URL                               | `richdocuments` | `public_wopi_url` |  `""`   | `https://collabora.example.com` |
| `NX_COLLABORA_ALLOWLIST`    | Collabora WOPI Allow List (Comma Separated) | `richdocuments` | `wopi_allowlist`  |  `""`   |   `172.16.0.0/12,10.0.0.0/12`   |

### Onlyoffice

| Variable                   | Description           |    App(s)    |    Config Key(s)    | Default |             Example              |
| -------------------------- | --------------------- | :----------: | :-----------------: | :-----: | :------------------------------: |
| `NX_ONLYOFFICE`            | Enable OnlyOffice     |              |                     | `false` |              `true`              |
| `NX_ONLYOFFICE_URL`        | OnlyOffice URL        | `onlyoffice` | `DocumentServerUrl` |  `""`   | `https://onlyoffice.example.com` |
| `NX_ONLYOFFICE_JWT`        | OnlyOffice JWT        | `onlyoffice` |    `jwt_secret`     |  `""`   |  `random_string_of_characters`   |
| `NX_ONLYOFFICE_JWT_HEADER` | OnlyOffice JWT Header | `onlyoffice` |    `jwt_header`     |  `""`   |         `Authorization`          |

### Talk

| Variable                    | Description            |  App(s)  |    Config Key(s)    | Default |                                      Example                                      |
| --------------------------- | ---------------------- | :------: | :-----------------: | :-----: | :-------------------------------------------------------------------------------: |
| `NX_TALK`                   | Enable Talk            |          |                     | `false` |                                      `true`                                       |
| `NX_TALK_STUN_SERVERS`      | Talk STUN servers      | `spreed` |   `stun_servers`    |  `""`   |                              `stun1:3478 stun2:3478`                              |
| `NX_TALK_TURN_SERVERS`      | Talk TURN servers      | `spreed` |   `turn_servers`    |  `""`   |                      `turn1,1234,secret turn2,1234,secret2`                       |
| `NX_TALK_SIGNALING_SERVERS` | Talk Signaling servers | `spreed` | `signaling_servers` |  `""`   | `signal.example.com,true signal2.example.com,false` (true/false for verification) |
| `NX_TALK_SIGNALING_SECRET`  | Talk Signaling secret  | `spreed` | `signaling_secret`  |  `""`   |                                   `some_secret`                                   |

> Visit Nextcloud official documentation for more information about each `Config key`
>
> Also see [config example](https://github.com/nextcloud/server/blob/master/config/config.sample.php)

Recommended additions for nextcloud optimizations

> Partial docker-compose file

```yaml
services:
  nextcloud:
    image: ...
    ...
    environment:
      NX_REDIS: true
      NX_REDIS_HOST: redis
      NX_REDIS_PORT: 6379
      NX_REDIS_PASS: REPLACE_ME
      # Do NOT set REDIS_HOST, REDIS_HOST_PORT and REDIS_HOST_PASSWORD
    configs:
      - source: php-tune
        target: /usr/local/etc/php-fpm.d/zz-tune.conf
      - source: redis-session
        target: /usr/local/etc/php/conf.d/redis-session.ini
      - source: opcache-recommended
        target: /usr/local/etc/php/conf.d/opcache-recommended.ini

configs:
  php-tune:
    content: |
      [www]
      pm.max_children = 180
      pm.start_servers = 18
      pm.min_spare_servers = 12
      pm.max_spare_servers = 30
  redis-session:
    content: |
      session.save_handler = redis
      session.save_path = "tcp://redis:6379?auth=REPLACE_ME"
      redis.session.locking_enabled = 1
      redis.session.lock_retries = -1
      redis.session.lock_wait_time = 10000
  opcache-recommended:
    content: |
      opcache.enable=1
      opcache.enable_cli=1
      opcache.save_comments=1
      opcache.jit=1255
      opcache.interned_strings_buffer=32
      opcache.max_accelerated_files=10000
      opcache.memory_consumption=128
      opcache.revalidate_freq=60
      opcache.jit_buffer_size=128M
```
