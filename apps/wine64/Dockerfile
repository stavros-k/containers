FROM node:20.3.0@sha256:fc738db1cbb81214be1719436605e9d7d84746e5eaf0629762aeba114aa0c28d

# Install dependencies
RUN apt update && \
    apt install -y \
        nano \
        wine64

USER 1000

ENTRYPOINT "cat"
