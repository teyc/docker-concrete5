# docker-concrete5

A [Concrete5](https://www.concrete5.org/) Docker image that contains PHP, MySQL and nginx preconfigured. Suitable for use as a development environment only.

# Quick-Start 

You can start the image by using bash or Powershell (see below). Then navigate to http://localhost:8080 to install Concrete5.

When prompted, you should set

```
Database: localhost
Database user: c5_user
Database password: c5_password
```

## bash

```bash
docker run -it \
    -e MYSQL_ROOT_PASSWORD=kHfj3_mp1@ha-agZMNB35AAgw \
    -p 8080:80 -p 13306:3306 \
    --name c5 teyc/concrete5:temp
```

## Powershell

docker build . -t teyc/concrete5:8.5.4

```powershell
docker run -it `
    -e MYSQL_ROOT_PASSWORD=kHfj3_mp1@ha-agZMNB35AAgw `
    -p 8080:80 -p 13306:3306 `
    --name c5 teyc/concrete5:8.5.4
```

# Adminer

There is a copy of Adminer installed and is accessible on 
http://localhost:8080/adminer

# Common tasks

## Shell into running Docker instance

```bash
docker exec -it c5 /bin/sh
/var/www/html # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
```

## Restart a stopped container

bash

```bash
containerId=(docker ps -qaf "name=c5")
docker start --attach $containerId
```

powershell

```powershell
$containerId=(docker ps -qaf "name=c5")
docker start "--attach" $containerId
```

# Contributing

```
docker build . -t teyc/concrete5:8.5.4
```

## Removing docker images that has no tags
```
docker image prune
```

## TODO

1. Use multistage Docker builds

2. Document how to persist MySQL data

3. Document how to persist downloaded add-ons/packages

