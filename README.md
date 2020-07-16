# CMaNGOS - Docker
## What is it?
These are docker-compose files for the CMaNGOS project, currently for the WotLK variant. But they should be easy to alter for a different branch.

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

Now wait for a while because it will need to build the images (cmangos_mangosd, cmangos_realmd, cmangos_db) and will then start spinning up containers.

# Credits
Thanks to @vishnubob and contributors for the wait-for-it.sh script (https://github.com/vishnubob/wait-for-it).
Thanks to CMaNGOS Community (https://github.com/cmangos) / (https://cmangos.net/)