#/bin/sh
# This is just for documentation and example usage. I will link this all together in the docker-compose eventually.
sudo docker run --detach \
  --name cmangos_mangosd \
  --network cmangos-net \
  --mount "type=volume,source=cmangos_mangosd_logs_2,destination=/opt/cmangos/logs,readonly=false" \
  --mount "type=volume,source=cmangos_mangosd_etc_2,destination=/opt/cmangos/etc,readonly=false" \
  --publish 8085:8085 \
  --env CHARACTERS_DB=wotlkcharacters \
  --env MANGOSD_DB=wotlkmangos \
  --env REALMD_DB=wotlkrealmd \
  --env DB_USER=mangos \
  --env DB_PASS=mangos \
  --env REALMD_USER=mangos \
  --env REALMD_PASS=mangos \
  --env DB_SERVER=database \
  --env REALMD_SERVER=database \
  --restart unless-stopped \
 cmangos_mangosd:0.2
