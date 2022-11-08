# E-Commerce Box
> E-Commerce  system in micro services archticture

## Requirements
* [Docker](https://docs.docker.com/install/overview/) (or docker on a docker-machine-env for [macOS](https://docs.docker.com/machine/))
* [Docker Compose](https://docs.docker.com/compose/install/)
* Git access via [ssh](https://help.github.com/en/articles/connecting-to-github-with-ssh)

## Install Docker
Choose your Operating System platform and download from https://docs.docker.com/install/#supported-platforms
Configure any extra parameters like [docker-machine env](https://docs.docker.com/docker-for-mac/docker-toolbox/#setting-up-to-run-docker-desktop-for-mac) for docker toolbox users on mac or [linux options](https://docs.docker.com/install/linux/linux-postinstall/)

## Install GIT
```bash
sudo apt install git
```

## Install Docker
```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce
```
Based on this link: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04


## Install Docker Compose
```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
sudo usermod -a -G docker $USER
newgrp docker
```

Based on this link: https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04


## Install E-COMMERCE Apps
### Clone the repo and change file mode bits

```bash
git@github.com:waelwalid/e-commerce-micro.git
cd e-commerce-micro
./install.sh
```

### Xtra command available on install.sh
```bash

# This commend will install required dependencies
./install install_dependencies

# Try to Update all repositories to most recent revision
./install.sh update_repositories

# Update /etc/hosts update_hosts
./install.sh update_hosts

# This commend will build all necessary applications
./install.sh build

# This commend will create all databases in mysql_database container
./install.sh create_databases


```

/etc/hosts will look like this:

```bash

172.31.0.2 e-commerce.local
172.31.0.3 
172.31.0.4 
... any other hosts will go here automatically

```

### Up Containers

To put up specific containters
```bash
docker-compose up -d <container_name> <container_name> 
```

To put up All containters
```bash
docker-compose up -d
```

### IPs range

172.31.0.100-120 Core Apps

    172.31.0.10 mongodb.local
	172.31.0.11 mysqldb.local


172.31.0.121-150 Adapters (Intergarions Microservices)

      TO BE READY 


172.31.0.151-253 All other supporting services

      172.31.0.200       notifications.local
      172.31.0.201       redis.local


## Check Applications
    172.31.0.2 e-commerce.local
	172.31.0.3 
	172.31.0.4 
| IP | Service | Url |
| ------------- | ------------- | -------------       |
| 172.31.0.110-120 | ------------- | Core Apps          |
|  172.31.0.11 | Databases |  mysqldb.local:3306           |
|  172.31.0.2 | e-commerce | <http://e-commerce.local>            |
|  172.31.0.3 | authentication | <http://>          |
|  172.29.0.4 | catalog_service | <https://>              |
| 172.31.0.121-150 | ------------- | Adapters               |
| 172.31.0.151-253  | ------------- | supporting services                |
|  172.31.0.112 | ex: redis | <http://redis.local>          |
|  172.29.0.113 | ex: notifications | <https://notifications.local>              |




## TODO
- [ ] Database seeding
- [x] Single script configuration (```./install.sh```)
- [x] Automatic Database Creation
- [x] Automatically write hosts to `/etc/hosts`
- [x] Parameters should not be managed on root folder, but instead on each application
- [ ] Check logs for specific application (e.g. `./logs.sh <container>`)


## E-Commerce Box, Nov, 2022

Naming convention:
- Docker Compose Service: same as github repository
- Docker Compose Container: same as github repository
- Domain: <same as github repository>Docker-compose.yml configurations.local

configs:
- database name same as service
- database user: root password: root
- command to copy ".env.example to .env" 

Initial DB
- catalog_service

### Thank you :) 
