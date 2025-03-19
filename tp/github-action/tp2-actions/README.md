# GitLab CI : Jobs Docker et principes fondamentaux (5 min)

## Principe des Jobs Docker dans GitLab CI

- GitLab CI utilise des conteneurs Docker pour exécuter ses jobs.
- Chaque job peut spécifier une image Docker spécifique pour exécuter une tâche particulière.
- Ex : Utilisation basique d'un job Docker avec GitLab CI

```yaml
image: docker:latest

stages:
  - build

docker_build:
  stage: build
  services:
    - docker:dind
  script:
    - docker build -t monapp:v1 .
    - docker push monapp:v1
```

## 📌 Création d’un Job Docker personnalisé GitLab CI (10 min)

Exemple : Job Docker personnalisé (Scan sécurité)

- Créer un job GitLab CI personnalisé utilisant Trivy (outil de sécurité Docker) :

```yaml
stages:
  - test
  - build

security_scan:
  stage: build
  image: aquasec/trivy:latest
  script:
    - trivy image monapp:v1
```

- Intégration au pipeline :

```yaml
stages:
  - test
  - build
  - deploy

docker_build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t monapp:v1 .
    - docker push monapp:v1

security_scan:
  stage: test
  image: aquasec/trivy:latest
  script:
    - trivy image monapp:v1

deploy_to_k8s:
  stage: deploy
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  script:
    - kubectl apply -f deployment.yaml
```

## 📌 GitLab CI Marketplace – Templates & bonnes pratiques

**Présentation rapide du Marketplace GitLab :**

- GitLab CI fournit de nombreux templates prêts à l'emploi :
- GitLab CI templates officiels
  - Exemples : Docker Build, Kubernetes Deploy, tests automatisés, sécurité.

**Exemple d’utilisation :**

Pour intégrer rapidement un template officiel :

```yaml
include:
  - template: Docker.gitlab-ci.yml
```

## 🛠️ TP pratique : Création pipeline complet GitLab CI avec Docker

### 🟢 Objectif

- Créer un pipeline GitLab CI complet de test, build Docker, push Docker Hub, puis déploiement sur Kubernetes.

Étapes pratiques :

- Étape 1 : Créer dépôt GitLab et fichiers
  - Dockerfile simple (ex. nginx)
  - Fichier GitLab CI : ```.gitlab-ci.yml```
  - Fichier Kubernetes : ```deployment.yaml```

- Étape 2 : Configurer secrets GitLab

  - DOCKER_USERNAME et DOCKER_PASSWORD
  - KUBECONFIG pour Kubernetes (Cluster simulé ou réel)

- Étape 3 : Créer le pipeline complet GitLab CI

```yaml
stages:
  - build
  - deploy

docker-build-push:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
    - docker build -t $DOCKER_USERNAME/monapp:v1 .
    - docker push $DOCKER_USERNAME/monapp:v1

k8s-deploy:
  stage: deploy
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  script:
    - kubectl apply -f deployment.yaml
```

**Exemple Kubernetes :**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mon-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: monapp
  template:
    metadata:
      labels:
        app: monapp
    spec:
      containers:
      - name: monapp
        image: $DOCKER_USERNAME/monapp:v1
---
apiVersion: v1
kind: Service
metadata:
  name: monapp-service
spec:
  selector:
    app: monapp
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

- Étape 3 : Tester le pipeline complet en déclenchant manuellement ou automatiquement le pipeline.
