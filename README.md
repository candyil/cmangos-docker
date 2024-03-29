# CMaNGOS - Docker
## What is it?
These are docker-compose files for the CMaNGOS project for the WotLK variant.

## How to use it?
To use this project clone it using:
```
$ git clone https://github.com/korhaldragonir/cmangos-docker.git
```

Place the Data files (DBC, Maps, VMaps, MMaps) in the directory `/opt/cmangos-data` with the following structure:
```
/opt/cmangos-data
├── dbc
├── maps
├── mmaps
└── vmaps
```
I did not include these because they would make the repository far to big and may need re-extraction every once in a while.

Make sure you have docker and docker-compose installed on your system and run the following command in the `cmangos-docker` directory:
```
$ sudo docker-compose up -d
```

Now wait for a while because it will need to build the images (cmangos_mangosd, cmangos_realmd, cmangos_db) and will then start spinning up containers. (Depending on your system this can take between 30min up to 1 hour)

Afterwards you should be able to connect with mysql to 127.0.0.1:3306 and change the IP of the Realm if you are not planning on using it locally:
```
$ mysql -umangos -pmangos -h 127.0.0.1 -P 3306
mysql> use wotlkrealmd;
mysql> UPDATE `realmlist` SET `address` = '<your-ip>', `name` = '<realm-name>' WHERE `id` = '1' LIMIT 1;
mysql> quit;
```

### Administration
To control the environment you will need to use the Remote Console via the server it is running on. Usually a `telnet` would suffice. E.g:
```
$ telnet localhost 3443
```

You can login with the default `ADMINISTRATOR` credentials. From this console you can create an account to use from the Game Client.

## Running / Building a specific Commit version
It is now possible to specify a Commit Hash for both the Core and for the DB. This will overrule the behaviour to clone and build the latest version. Useful for building a known-good build for example. To use this follow either of the following.

### Using Environment Variables (Useful for CI/CD)
```
$ export CORE_COMMIT_HASH=67d01de4c04bc69a81c1a462b2f49a90eb86abae
$ export DB_COMMIT_HASH=ebc069766dfd57c1a9f631b6cec9434f4f345a8c
$ sudo docker-compose build --no-cache --build-arg CORE_COMMIT_HASH --build-arg DB_COMMIT_HASH
```

### Using Build Arguments (useful for Single Run)
```
$ sudo docker-compose build --no-cache --build-arg CORE_COMMIT_HASH=67d01de4c04bc69a81c1a462b2f49a90eb86abae --build-arg DB_COMMIT_HASH=ebc069766dfd57c1a9f631b6cec9434f4f345a8c
```

In both cases you can now run:
```
$ sudo docker-compose up -d
```

## Build Arguments
Below you will find the supported build arguments.

When using the `docker-compose build` command only the images that support the arguments will pick them up. So you can specify them all in one go.

### cmangos_db
| Argument     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| DB_COMMIT_HASH | This argument determines which Commit hash to use when initializing the db. | HEAD |

### cmangos_mangosd
| Argument     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| BUILD_AHBOT | This build argument determines whether the Auction House Bot will be built. | ON |
| BUILD_METRICS | This build argument determines whether the Metric Support will be built. | OFF |
| BUILD_PLAYERBOT | This build argument determines whether PlayerBot will be built. | OFF |
| CORE_COMMIT_HASH | This argument determines which Commit hash to use when building (C)MaNGOS. | HEAD |

### cmangos_realmd
| Argument     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| CORE_COMMIT_HASH | This argument determines which Commit hash to use when building (C)MaNGOS. | HEAD |

## Environment Variables
### cmangos_mangosd
| Variable     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| TZ       | This variable is used set the correct timezone. | Europe/Amsterdam |
| CHARACTERS_DB | This variable is used to set the Characters Database during init. | wotlkcharacters |
| LOGS_DB | This variable is used to set the Logs Database during init. | wotlklogs |
| MANGOSD_DB | This variable is used to set the Wold Database during init. | wotlkmangos |
| REALMD_DB | This variable is used to set the Realm Database during init. | wotlkrealmd |
| DB_USER | This variable is used to set the Database user for the World and Characters Database during init. | mangos |
| DB_PASS | This variable is used to set the Database password for the World and Characters Database during init. | mangos |
| REALMD_USER | This variable is used to set the Database user for the Realm Database during init. | mangos |
| REALMD_PASS | This variable is used to set the Database password for the Realm Database during init. | mangos |
| DB_SERVER | This variable is used to set the Database Server (Host or IP) for the World and Characters Database during init. | database |
| REALMD_SERVER | This variable is used to set the Database Server (Host or IP) for the Realm Database during init. | database |

### cmangos_realmd
| Variable     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| TZ       | This variable is used set the correct timezone. | Europe/Amsterdam |
| REALMD_DB | This variable is used to set the Realm Database during init. | wotlkrealmd |
| DB_USER | This variable is used to set the Database user for the Realm Database during init. | mangos |
| DB_PASS | This variable is used to set the Database password for the Realm Database during init. | mangos |
| DB_SERVER | This variable is used to set the Database Server (Host or IP) for the Realm Database during init. | database |

### cmangos_db
| Variable     | Description           | Default Value     |
|--------------|-----------------------|-------------------|
| TZ       | This variable is used set the correct timezone. | Europe/Amsterdam |
| MYSQL_ROOT_PASSWORD       | This variable is used to set the MySQL/MariaDB root password on initial deploy. | mangos |

## Tips
If you want to re-build the CMaNGOS code within the images without bringing down the running containers you can run the following from within the `cmangos-docker` directory:
```
$ sudo docker-compose build --no-cache
```

Then after that was succesful you can run:
```
$ sudo docker-compose down
$ sudo docker-compose up -d
```
Now you should be running the new version with minimal downtime.

# Credits
Thanks to @vishnubob and contributors for the wait-for-it.sh script (https://github.com/vishnubob/wait-for-it).  
Thanks to @krallin and contributors for making tini (https://github.com/krallin/tini/).  
Thanks to CMaNGOS Community (https://github.com/cmangos) / (https://cmangos.net/).  