# Création d’un Dockerfile simple

## Construire l’image Docker

```shell
docker build -t monappweb:v1 .
```

**Explication des commandes :**

- ```docker build``` : création d’une image Docker.
- ```-t``` : étiquette l’image (nom:image-tag).
- ```.``` : emplacement du Dockerfile.

## Publier l’image sur Docker Hub (Push)

- Tagger une image avant publication :

```shell
docker tag monappweb:v1 moncompteDocker/monappweb:v1
```

Publier l’image :

```shell
docker login
docker push moncompteweb/monappweb:v1
```

**Explication :**

- Connexion préalable au compte Docker Hub.
- Envoi de l’image dans un dépôt distant (Docker Hub).

## Télécharger et exécuter l’image depuis Docker Hub

```shell
docker pull moncompteweb/monappweb:v1
docker run -d -p 8080:80 moncompteweb/monappweb:v1
```

L’application est accessible via : http://localhost:8080

**Explication :**

- Téléchargement et exécution de l’image Docker depuis Docker Hub.
