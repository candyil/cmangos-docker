#!/bin/sh
# Fetch Packages needed
echo "Starting Initialization of CMaNGOS DB..."

# Prepare Databases
mysql -uroot -pmangos -e "create database wotlkcharacters;"
mysql -uroot -pmangos -e "create database wotlklogs;"
mysql -uroot -pmangos -e "create database wotlkmangos;"
mysql -uroot -pmangos -e "create database wotlkrealmd;"
mysql -uroot -pmangos -e "create user 'mangos'@'%' identified by 'mangos';"
mysql -uroot -pmangos -e "grant all privileges on wotlkcharacters.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on wotlklogs.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on wotlkmangos.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on wotlkrealmd.* to 'mangos'@'%';"

# Clone core code
echo "Core Version: ${ENV_CORE_COMMIT_HASH}"
git clone https://github.com/cmangos/mangos-wotlk.git /tmp/cmangos
if [ "$ENV_CORE_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to Core Commit: ${ENV_CORE_COMMIT_HASH}\n"
  cd /tmp/cmangos
  git checkout ${ENV_CORE_COMMIT_HASH}
fi

# Clone db code
echo "DB Version: ${ENV_DB_COMMIT_HASH}"
git clone https://github.com/cmangos/wotlk-db /tmp/db
if [ "$ENV_DB_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to DB Commit: ${ENV_DB_COMMIT_HASH}\n"
  cd /tmp/db
  git checkout ${ENV_DB_COMMIT_HASH}
fi

# Create default database structures
if [ -f /tmp/cmangos/sql/base/characters.sql ]; then
  echo "Creating characters ..."
  mysql -uroot -pmangos wotlkcharacters < /tmp/cmangos/sql/base/characters.sql
fi

if [ -f /tmp/cmangos/sql/base/logs.sql ]; then
  echo "Creating logs ..."
  mysql -uroot -pmangos wotlklogs < /tmp/cmangos/sql/base/logs.sql
fi

if [ -f /tmp/cmangos/sql/base/mangos.sql ]; then
  echo "Creating mangos ..."
  mysql -uroot -pmangos wotlkmangos < /tmp/cmangos/sql/base/mangos.sql
fi

if [ -f /tmp/cmangos/sql/base/realmd.sql ]; then
  echo "Creating realmd ..."
  mysql -uroot -pmangos wotlkrealmd < /tmp/cmangos/sql/base/realmd.sql
fi

# Install Updates for all databases except wotlkmangos
# wotlkcharacters
echo "Updating characters ..."
for FILE in $(ls -1 /tmp/cmangos/sql/updates/characters | grep -v README | sort); do
  echo "> Applying ${FILE} ...";
  mysql -uroot -pmangos wotlkcharacters < /tmp/cmangos/sql/updates/characters/${FILE};
done

# wotlklogs
echo "Updating logs ..."
for FILE in $(ls -1 /tmp/cmangos/sql/updates/logs | grep -v README | sort); do
  echo "> Applying ${FILE} ...";
  mysql -uroot -pmangos wotlklogs < /tmp/cmangos/sql/updates/logs/${FILE};
done

# wotlkrealmd
echo "Updating realmd ..."
for FILE in $(ls -1 /tmp/cmangos/sql/updates/realmd | grep -v README | sort); do
  echo "> Applying ${FILE} ...";
  mysql -uroot -pmangos wotlkrealmd < /tmp/cmangos/sql/updates/realmd/${FILE};
done

# Copy install script
cp -v /docker-entrypoint-initdb.d/InstallFullDB.config /tmp/db/InstallFullDB.config

# Set ADMINISTRATOR account to level 4 and lock it down
mysql -uroot -pmangos wotlkrealmd -e 'UPDATE `account` SET gmlevel = "4", locked = "1" WHERE id = "1" LIMIT 1;'

# Remove other accounts
mysql -uroot -pmangos wotlkrealmd -e 'DELETE FROM `account` WHERE id = "2" LIMIT 1;'
mysql -uroot -pmangos wotlkrealmd -e 'DELETE FROM `account` WHERE id = "3" LIMIT 1;'
mysql -uroot -pmangos wotlkrealmd -e 'DELETE FROM `account` WHERE id = "4" LIMIT 1;'

# Run install script
cd /tmp/db
./InstallFullDB.sh

# Cleanup
cd /
rm -rf /tmp/db
rm -rf /tmp/cmangos
