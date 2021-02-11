# Alpine local repository with docker
Alpine's Docker repository for local Alpine-based developments. Nginx and synchronization on external volume

* Built on the lightweight and secure Alpine Linux distribution
* Small docker image size
* Nginx, rsync and supervisor
* The servers Nginx, rsync and supervisord run under a non-privileged user (nobody) to make it more secure
* The logs of all the services are redirected to the output of the Docker container (visible with `docker logs -f <container name>`)
* Follows the KISS principle (Keep It Simple, Stupid) to make it easy to understand and adjust the image to your needs 
* Run rsync every hour without overlapping

![alpine 3.13](https://img.shields.io/badge/alpine-3.13-brightgreen.svg)
![nginx 1.18.0](https://img.shields.io/badge/nginx-1.18-brightgreen.svg)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

## Preparation
###  You can to make changes in docker-compose.yml
- Config for use an external volume mount in system `/backup5t/mirror/alpine`. You can to change this in docker-compose.yml
- Network base en create or use an internal network, and docker use a static IP. And this ip to your `/etc/hosts` for use FQDN local instead IP 

### Usage
#### Build 
Run this on top level
```
docker-compose build # or
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build # Cached
```
#### Run
```
docker-compose up #Not dettached
docker-compose up -d #detached
```

#### Shell access
```
docker exec -it repoalpine sh #repoalpine or hostanme used
```

## Contributing
Feel free to upload an upgrade by making a pull request. :heart: 

## License 
[MIT License](https://gitlab.castris.com/root/alpine-mirror/-/blob/master/LICENSE)
