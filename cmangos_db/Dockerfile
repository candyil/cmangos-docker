# Download base image ubuntu 18.04
FROM mariadb:bionic

# Install Software
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -q -y git && \
    rm -rf /var/lib/apt/lists/*
