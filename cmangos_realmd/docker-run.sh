#/bin/sh
# This is just for documentation and example usage. I will link this all together in the docker-compose eventually.
sudo docker run --detach --name cmangos_realmd --network cmangos-net --mount "type=volume,source=cmangos_realmd_etc,destination=/opt/cmangos/etc,readonly=false" --publish 3724:3724 --restart unless-stopped cmangos_realmd:0.1
