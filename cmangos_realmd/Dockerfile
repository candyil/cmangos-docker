# Download base image ubuntu 18.04
FROM ubuntu:18.04

# Update Ubuntu Software repository
RUN apt update

# Install nginx, php-fpm and supervisord from ubuntu repository
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -q -y git-core build-essential binutils gcc g++ cpp automake autoconf make libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip patch zlibc libc6 git-core openssl pkg-config cmake libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-regex-dev && \
    rm -rf /var/lib/apt/lists/*

# Prepare Sources
RUN mkdir -p /opt/src && \
    git clone https://github.com/cmangos/mangos-wotlk.git /opt/src/cmangos

# Build Software
RUN mkdir -p /opt/cmangos/logs /opt/src/cmangos/build && \
    cd /opt/src/cmangos/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_GAME_SERVER=OFF && \
    make -j 4 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v realmd.conf.dist realmd.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/127.0.0.1;3306;mangos/database;3306;mangos/g' realmd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' realmd.conf

# Extract runtime files and cleanup
RUN rm -rfv /opt/src

# Volume configuration
VOLUME ["/opt/cmangos/etc"]

# Configure Services and Port
COPY 00_init.sh /00_init.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /00_init.sh && chmod +x /wait-for-it.sh
CMD ["/00_init.sh"]

EXPOSE 3724
