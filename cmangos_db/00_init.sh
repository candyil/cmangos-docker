#!/bin/sh
# Fetch Packages needed
echo "Starting Initialization of CMaNGOS DB..."
mysql -uroot -pmangos -e "create database wotlkcharacters;"
mysql -uroot -pmangos -e "create database wotlkmangos;"
mysql -uroot -pmangos -e "create database wotlkrealmd;"
mysql -uroot -pmangos -e "create user 'mangos'@'%' identified by 'mangos';"
mysql -uroot -pmangos -e "grant all privileges on wotlkcharacters.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on wotlkmangos.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on wotlkrealmd.* to 'mangos'@'%';"
git clone https://github.com/cmangos/mangos-wotlk.git /tmp/cmangos
if [ "$CORE_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to Core Commit: ${CORE_COMMIT_HASH}\n"
  cd /tmp/cmangos
  git checkout ${CORE_COMMIT_HASH}
fi
git clone https://github.com/cmangos/wotlk-db /tmp/db
if [ "$DB_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to DB Commit: ${DB_COMMIT_HASH}\n"
  cd /tmp/db
  git checkout ${DB_COMMIT_HASH}
fi
mysql -uroot -pmangos wotlkcharacters < /tmp/cmangos/sql/base/characters.sql
mysql -uroot -pmangos wotlkrealmd < /tmp/cmangos/sql/base/realmd.sql
cp -v /docker-entrypoint-initdb.d/InstallFullDB.config /tmp/db/InstallFullDB.config
cd /tmp/db
./InstallFullDB.sh
cd /
rm -rf /tmp/db
rm -rf /tmp/cmangos
