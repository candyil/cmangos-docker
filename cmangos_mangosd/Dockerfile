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
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_LOGIN_SERVER=OFF && \
    make -j 2 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v mangosd.conf.dist mangosd.conf && cp -v /opt/src/cmangos/src/game/AuctionHouseBot/ahbot.conf.dist.in ahbot.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/127.0.0.1;3306;mangos/database;3306;mangos/g' mangosd.conf && \
    sed -i 's/LogsDir \= ""/LogsDir \= "\/opt\/cmangos\/logs"/g' mangosd.conf && \
    sed -i 's/DataDir \= "."/DataDir = "\/opt\/cmangos"/g' mangosd.conf && \
    sed -i 's/Console\.Enable \= 1/Console\.Enable \= 0/g' mangosd.conf

# Copy the runtime files
COPY cmangos-data.tar.gz /opt/cmangos

# Extract runtime files and cleanup
RUN cd /opt/cmangos && tar -xvzf cmangos-data.tar.gz && rm -vf cmangos-data.tar.gz && rm -rfv /opt/src

# Volume configuration
VOLUME ["/opt/cmangos/etc", "/opt/cmangos/logs"]

# Configure Services and Port
COPY start.sh /start.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /start.sh && chmod +x /wait-for-it.sh
CMD ["/wait-for-it.sh", "database:3306", "-t", "600", "-s", "--", "/start.sh"]

EXPOSE 8085
