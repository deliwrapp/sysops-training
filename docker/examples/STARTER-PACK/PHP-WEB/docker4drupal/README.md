
# Intro

Docker4Drupal by Wodby was designed to help developers deploy and manage drupal across their servers in the most simple fashion.

## Useful Links

Drupal stack documentation
https://wodby.com/docs/1.0/stacks/drupal/
https://wodby.com/docs/1.0/stacks/drupal/local/
https://wodby.com/docs/1.0/stacks/template/
https://wodby.com/docs/1.0/stacks/config/

# Wodby Stack Overview

Stack is a pre-configured infrastructure package for your application. Every stack consist of services, they can be mandatory or optional. Every service has at least one container implementation, e.g. MariaDB or PostgreSQL containers for a database management service.

You can find all stacks offered by Wodby at https://wodby.com/stacks

# CONTAINERS SERVICES LINKS


|   Service         |   Domain                                          |
|---                |:-:                                                |
|  `nginx/apache`   |  http://drupal.docker.localhost:8000              |
|  `pma`            |  http://pma.drupal.docker.localhost:8000          |
|  `adminer`        |  http://adminer.drupal.docker.localhost:8000      |
|  `mailpit`        |  http://mailpit.drupal.docker.localhost:8000      |
|  `solr`           |  http://solr.drupal.docker.localhost:8000         |
|  `node`           |  http://node.drupal.docker.localhost:8000         |
|  `varnish`        |  http://varnish.drupal.docker.localhost:8000      |
|  `portainer`      |  http://portainer.drupal.docker.localhost:8000    |
|  `webgrind`       |  http://webgrind.drupal.docker.localhost:8000     |



Ajouter l'adresse au fichier host

```
127.0.0.1   drupal.docker.localhost:8000
```
LINUX   =>  /etc/hosts
MAC     =>  /etc/hosts
WINDOW  =>  C:\Windows\ System32\drivers\etc\hosts

Si vous souhaitez utiliser une autre adresse que "drupal.docker.localhost", penser à modifier les fichiers de config d'apache

# CONFIGURATIONS

## php settings.php

```php

$databases['default']['default'] = array (
    'database' => 'drupal', // same as $DB_NAME
    'username' => 'drupal', // same as $DB_USER
    'password' => 'drupal', // same as $DB_PASSWORD
    'host' => 'mariadb', // same as $DB_HOST
    'driver' => 'mysql',  // same as $DB_DRIVER
    'port' => '3306', // different for PostgreSQL
    'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql', // different for PostgreSQL
    'prefix' => '',
);

```

# MAKE COMMANDS

```shell
Usage: make COMMAND

Commands:
    help            List available commands and their description 
    up              Start up all container from the current compose.yml 
    start           Start stopped containers 
    stop            Stop all containers for the current compose.yml (docker compose stop) 
    down            Same as stop
    prune [service] Stop and remove containers, networks, images, and volumes (docker compose down)
    ps              List container for the current project (docker ps with filter by name)
    shell [service] Access a container via shell as a default user (by default [service] is php)
    logs [service]  Show containers logs, use [service] to show logs of specific service
    mutagen         Start mutagen container and runs mutagen project
```

Drupal-specific:


```shell
make drush [command] Execute drush command (runs with -r /var/www/html/web, you can override it via DRUPAL_ROOT=PATH)

```

# DOCKER USAGE

The code is run inside some docker container.

- `docker-compose build` Build your containers
- `docker-compose up -d` Run yours containers
- `make deploy-dev` Build the project

## Day-to-day usages

The code is run inside some docker container.

- `docker-compose up -d --force-recreate` Recreate your containers
- `docker exec -it <docker_container_name> bash` Get a bash terminal on docker php
- `docker rm $(docker stop $( docker ps -a -q))` Remove your containers
- `docker-compose up -d --force-recreate` Recreate your containers
- `docker system prune -a --volumes` Remove ALL your docker data (except running containers)


## BUILD

Créer un build des containers
```shell
docker-compose build
```

## RUN

Ensuite executer la commande, pour initialiser tous les containers

```shell
docker-compose up -d
```

OU bien

```shell
docker-compose up
```

## BUILD and RUN

Commande pour lancer le build et le run des container

```shell
docker-compose up -d --build
```

## CONTAINER BASH ACCESS

Pour lancer un bash et rentrer dans le container de l'app

```shell
docker exec -it <container_name> bash
```

## USEFUL COMMANDS

### CONTAINER COMMANDS

Pour afficher tout vos containers

```shell
docker ps -a
```

Pour stopper un container

```shell
docker stop <docker_container_name>
```

Pour stopper tous les containers

```shell
docker stop $(docker ps -a -q)
```

Pour supprimer un container

```shell
docker rm -f <docker_container_name>

docker rm -f <docker_container_id>
```

Pour supprimer tous les containers

```shell
docker rm $(docker ps -a -q)
```

Pour supprimer tous les containers déjà stoppés

```shell
docker container prune

```

### IMAGE COMMANDS

Pour supprimer une image

```shell
docker rmi image_id

docker rmi image_id_1 image_id_2
```

Pour supprimer une image via son tag

```shell
docker rmi -f tag_name
```

Pour supprimer toutes les images inutilisées

```shell
docker image prune -a
```

OU

```shell
docker rmi $(docker images -a -q)
```

Pour supprimer toutes les images

```shell
docker rmi $ (docker images -a -q)
```

### VOLUME COMMANDS

Pour supprimer un volume

```shell
docker volume rm volume_name

docker volume rm volume_name1 volume_name2
```

Pour supprimer tous les volumes

```shell
docker volume rm $(docker volume ls -q)
```

### NETWORK COMMANDS

Pour supprimer un network

```shell
docker network rm network_name_or_id
```

Pour supprimer tous les networks

```shell
docker network prune
```

### GLOBAL COMMANDS

Pour supprimer toutes les images, networks, volumes, containers inutilisés

```shell
docker system prune
```

Pour supprimer tous les objets créés par un docker-compose

```shell
docker-compose down --rmi all -v --remove-orphans
```

Pour supprimer toutes les images et containers

```shell
docker ps -a
```

Par défaut, les volumes ne sont pas supprimés pour empêcher la suppression de données importantes si aucun conteneur n'utilise actuellement le volume. Utilisez l'indicateur --volumes lors de l'exécution de la commande pour élaguer également les volumes :

```shell
docker system prune -a --volumes
```