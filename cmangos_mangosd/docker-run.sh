#/bin/sh
# This is just for documentation and example usage. I will link this all together in the docker-compose eventually.
sudo docker run --detach --name cmangos_mangosd --network cmangos-net --mount "type=volume,source=cmangos_mangosd_logs,destination=/opt/cmangos/logs,readonly=false" --mount "type=volume,source=cmangos_mangosd_etc,destination=/opt/cmangos/etc,readonly=false" --publish 8085:8085 --restart unless-stopped cmangos_realmd:0.1
