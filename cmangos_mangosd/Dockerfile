# Download base image ubuntu
FROM ubuntu:18.04 AS builder

# Set Timezone
ENV TZ Europe/Amsterdam

# Update Ubuntu Software repository
RUN apt update

# Install nginx, php-fpm and supervisord from ubuntu repository
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -q -y git-core build-essential binutils gcc g++ cpp automake autoconf make libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip patch zlibc libc6 openssl pkg-config cmake libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-regex-dev libpthread-stubs0-dev wget && \
    rm -rf /var/lib/apt/lists/*

# Prepare new cmake
RUN cd /tmp && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2-Linux-x86_64.tar.gz && \
    tar -xvzf cmake-3.16.2-Linux-x86_64.tar.gz && \
    mv /tmp/cmake-3.16.2-Linux-x86_64 /opt/cmake && \
    ln -s /opt/cmake/bin/* /usr/local/bin/ && \
    rm -f /tmp/cmake-3.16.2-Linux-x86_64.tar.gz

# Prepare Sources
RUN mkdir -p /opt/src && \
    git clone https://github.com/cmangos/mangos-wotlk.git /opt/src/cmangos

# Build Software
RUN mkdir -p /opt/cmangos/logs /opt/src/cmangos/build && \
    cd /opt/src/cmangos/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_LOGIN_SERVER=OFF -DBUILD_PLAYERBOT=OFF -DBUILD_AHBOT=OFF  && \
    make -j 2 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v mangosd.conf.dist mangosd.conf && cp -v /opt/src/cmangos/src/game/AuctionHouseBot/ahbot.conf.dist.in ahbot.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/LogsDir \= ""/LogsDir \= "\/opt\/cmangos\/logs"/g' mangosd.conf && \
    sed -i 's/DataDir \= "."/DataDir \= "\/opt\/cmangos-data"/g' mangosd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' mangosd.conf && \
    sed -i 's/Console\.Enable \= 1/Console\.Enable \= 0/g' mangosd.conf

# Download base image ubuntu
FROM ubuntu:18.04

# Set Timezone
ENV TZ Europe/Amsterdam

# Update Ubuntu Software repository
RUN apt update

# Install nginx, php-fpm and supervisord from ubuntu repository
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -q -y binutils libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip zlibc libc6 openssl pkg-config libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-regex-dev libpthread-stubs0-dev wget && \
    rm -rf /var/lib/apt/lists/*

# Copy over data
COPY --from=builder /opt/cmangos /opt/cmangos

# Volume configuration
VOLUME ["/opt/cmangos/etc"]

# Env Variables
## Databases
ENV CHARACTERS_DB wotlkcharacters
ENV MANGOSD_DB wotlkmangos
ENV REALMD_DB wotlkrealmd

## World Credentials
ENV DB_USER mangos
ENV DB_PASS mangos

## Realmd Credentials
ENV REALMD_USER mangos
ENV REALMD_PASS mangos

## Database Servers
ENV DB_SERVER database
ENV REALMD_SERVER database

# Configure Services and Port
COPY 00_init.sh /00_init.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /00_init.sh && chmod +x /wait-for-it.sh
CMD ["/00_init.sh"]

EXPOSE 3443 7878 8085