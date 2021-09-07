# Download base image ubuntu 18.04
FROM mariadb:10.5-bionic

# Set Timezone
ENV TZ=Europe/Amsterdam \
    CORE_COMMIT_HASH=${CORE_COMMIT_HASH} \
    DB_COMMIT_HASH=${DB_COMMIT_HASH} \

# Install Software
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y git && \
    rm -rf /var/lib/apt/lists/*
