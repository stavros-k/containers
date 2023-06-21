FROM node:18.16.0@sha256:4a55308cc855cba1a925d19ae4e45838741dad2fd7bb8949a93b2a0f2ae339e3

# Install dependencies
RUN apt update && \
    apt install -y \
        nano \
        wine64

USER 1000

# Run for ever
ENTRYPOINT "cat"
