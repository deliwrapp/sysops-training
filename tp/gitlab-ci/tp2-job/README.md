# Démonstration et création d’une Action Docker personnalisée (10 min)

## Exemple : Création d’une action personnalisée Docker

- Imaginons que nous souhaitons automatiser le test de sécurité de nos images Docker. Nous allons créer une action Docker personnalisée qui utilise Trivy, un outil de scan de sécurité pour les images Docker.

**Créer le fichier Dockerfile de l’action :**

```Dockerfile
FROM aquasec/trivy:latest

ENTRYPOINT ["trivy"]
```

**Créer un fichier ```action.yml``` pour définir l'action :**

```yaml
name: 'Docker Security Scan Action'
description: 'Scan Docker images for security vulnerabilities using Trivy'
inputs:
  image:
    description: 'Docker image to scan'
    required: true
runs:
  using: 'docker'
  image: 'Dockerfile'
  args:
    - ${{ inputs.image }}
```

**Utilisation dans un pipeline :**

```yaml
jobs:
  security_scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Docker Security Scan
        uses: user/repository@v1
        with:
          image: monapp:v1
```

- Cette action scanne l’image Docker pour détecter les vulnérabilités. Vous pouvez maintenant l’ajouter à votre pipeline.

## Utilisation de l’Action Docker dans un Workflow

```yaml
name: CI Pipeline with Docker Security Scan

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build Docker image
      run: docker build -t monapp:v1 .
      
  scan:
    runs-on: ubuntu-latest
    needs: build

    steps:
    - uses: actions/checkout@v3
    - name: Docker Security Scan
      uses: user/repository@v1
      with:
        image: monapp:v1
```

## Test d’un pipeline complet

### 🟢 Objectif du test

- Valider l’intégration d’une action personnalisée dans un pipeline complet, du code jusqu’au déploiement sur Kubernetes.

### Structure du pipeline à tester

- **Tests automatisés** : Vérifier le code.
- **Build de l’image Docker** : Créer une image Docker à partir du Dockerfile.
- **Sécurité de l’image Docker** : Scannez l’image avec l’action personnalisée.
- **Push sur Docker Hub**: Poussez l’image vers le registre.
- **Déploiement sur Kubernetes** : Déployez l’image automatiquement sur un cluster Kubernetes.

### 🟢 Validation du pipeline

- Vérifiez que l’image Docker est correctement scannée et qu’il n’y a pas de vulnérabilités.
- Vérifiez que l’image est poussée sur Docker Hub.
- Vérifiez le déploiement réussi sur Kubernetes.
