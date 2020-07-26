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
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_LOGIN_SERVER=OFF -DBUILD_AHBOT=ON && \
    make -j 4 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v mangosd.conf.dist mangosd.conf && cp -v /opt/src/cmangos/src/game/AuctionHouseBot/ahbot.conf.dist.in ahbot.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/LogsDir \= ""/LogsDir \= "\/opt\/cmangos\/logs"/g' mangosd.conf && \
    sed -i 's/DataDir \= "."/DataDir \= "\/opt\/cmangos"/g' mangosd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' mangosd.conf && \
    sed -i 's/Console\.Enable \= 1/Console\.Enable \= 0/g' mangosd.conf

# Copy the runtime files
COPY cmangos-data.tar.gz /opt/cmangos

# Extract runtime files and cleanup
RUN cd /opt/cmangos && tar -xvzf cmangos-data.tar.gz && rm -vf cmangos-data.tar.gz && rm -rfv /opt/src

# Volume configuration
VOLUME ["/opt/cmangos/etc", "/opt/cmangos/logs"]

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
