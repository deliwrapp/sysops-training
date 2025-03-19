# Travaux pratiques guidés (TP)

## Étape 1 : Préparer le projet Docker-compose (10 min)

**Créez un dossier projet :**

```shell
mkdir projet-app && cd projet-docker
```

Créez une application simple (serveur web Nginx + base de données MySQL).

```docker-compose.yml ```

```yaml
version: '3'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: examplepassword

```

**Créez un dossier /html avec un index.html simple :**

```html
<!DOCTYPE html>
<html>
<body>
  <h1>Bienvenue sur mon site conteneurisé !</h1>
</body>
</html>
```

## Étape 2 : Déployer l’application avec docker-compose

```shell
docker-compose up -d
```

**Vérifiez le fonctionnement à l’adresse :**

http://localhost:8080

## Maintenance & mise à jour pratique d’applications Dockerisées (15 min)


**Étapes de mise à jour :**

- Modifier l’application (fichiers source ou Dockerfile).
- Reconstruire l’image Docker : ```docker-compose build```
Redéployer la nouvelle image : ```docker-compose up -d```

**Exemple :**

Modifier la page HTML puis redémarrer l’application :

```shell
docker-compose down
docker-compose up -d --build
```

**Remarque :** En production, utilisez un workflow CI/CD automatisé (GitHub Actions, Jenkins, etc.).