# Download base image ubuntu 18.04
FROM mariadb:latest

# Update Ubuntu Software repository
RUN apt update

# Install nginx, php-fpm and supervisord from ubuntu repository
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -q -y git && \
    rm -rf /var/lib/apt/lists/*
