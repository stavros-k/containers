FROM node:18.16.0

# Install dependencies
RUN apt update && \
    apt install -y \
        nano \
        wine64

USER 1000

ENTRYPOINT "cat"
