# Download base image ubuntu
FROM ubuntu:18.04 AS builder

# Set Timezone
ENV TZ=Europe/Amsterdam

# Update Ubuntu Software repository
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -q -y git-core build-essential binutils gcc g++ cpp automake autoconf make libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip patch zlibc libc6 git-core openssl pkg-config cmake libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-regex-dev libpthread-stubs0-dev wget && \
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
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_GAME_SERVER=OFF && \
    make -j 4 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v realmd.conf.dist realmd.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/127.0.0.1;3306;mangos/database;3306;mangos/g' realmd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' realmd.conf

# Extract runtime files and cleanup
RUN rm -rfv /opt/src

# Download base image ubuntu
FROM ubuntu:18.04

# Install dependencies for running CMaNGOSd.
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -q -y \
    binutils \
    libboost-dev \
    libboost-program-options1.65.1 \
    libboost-regex1.65.1 \
    libboost-system1.65.1 \
    libboost-thread1.65.1 \
    libc6 \
    libcurl4 \
    libmysql++3v5 \
    libpthread-stubs0-dev \
    libssl1.1 \
    libtool \
    openssl \
    pkg-config \
    unrar-free \
    unzip \
    zlibc && \
    rm -rf /var/lib/apt/lists/*

# Copy over data
COPY --from=builder /opt/cmangos /opt/cmangos

# Set Timezone
ENV TZ=Europe/Amsterdam

# Volume configuration
VOLUME ["/opt/cmangos/etc"]

# Copy over init scripts and make them executable
COPY 00_init.sh /00_init.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /00_init.sh && chmod +x /wait-for-it.sh

# Prepare tini init
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
CMD ["/00_init.sh"]

# Expose ports
EXPOSE 3724