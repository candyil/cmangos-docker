# Download base image ubuntu
FROM ubuntu:20.04

# Set Timezone
ENV TZ Europe/Amsterdam

# Update Ubuntu Software repository
RUN apt update

# Update Ubuntu Software repository
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -q -y \
      autoconf \
      automake \
      binutils \
      build-essential \
      cmake \
      cpp \
      g++ \
      gcc \
      git-core \
      libboost-dev \
      libboost-filesystem-dev \
      libboost-program-options-dev \
      libboost-regex-dev \
      libboost-system-dev \
      libboost-thread-dev \
      libc6 \
      libcurl4-openssl-dev \
      libmysql++-dev \
      libpthread-stubs0-dev \
      libssl-dev \
      libtool \
      make \
      openssl \
      patch \
      pkg-config \
      unrar-free \
      unzip \
      wget \
      zlibc && \
    rm -rf /var/lib/apt/lists/*

# Prepare new cmake
RUN cd /tmp && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-linux-x86_64.tar.gz && \
    tar -xvzf cmake-3.21.3-linux-x86_64.tar.gz && \
    mv /tmp/cmake-3.21.3-linux-x86_64 /opt/cmake && \
    ln -s /opt/cmake/bin/* /usr/local/bin/ && \
    rm -f /tmp/cmake-3.21.3-linux-x86_64.tar.gz

COPY build_script.sh /build.sh
RUN chmod 0755 /build.sh