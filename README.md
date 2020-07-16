# CMaNGOS - Docker
## What is it?
These are docker-compose files for the CMaNGOS project, currently for the WotLK variant. But they should be easy to alter for a different branch. I will probably do so later on by having multiple Dockerfiles.

## How to use it?
To use this project clone it using:
```
$ git clone https://github.com/korhaldragonir/cmangos-docker.git
```

Make sure you have docker and docker-compose installed on your system and run:
```
$ cd cmangos-docker/
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

# Credits
Thanks to @vishnubob and contributors for the wait-for-it.sh script (https://github.com/vishnubob/wait-for-it).  
Thanks to CMaNGOS Community (https://github.com/cmangos) / (https://cmangos.net/)  