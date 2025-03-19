# Démonstration GitHub CI

## Introduction rapide : GitHub Actions permet d’automatiser workflows directement depuis GitHub via fichiers YAML.**

**Exemple de workflow minimal GitHub CI :**

- Créer dossier et fichier : ```gitlab-test/gitlab-ci.yml```

```yaml
stages:
  - build

build_image:
  image: docker:latest
  stage: build
  script:
    - docker build -t monapp:latest .

```

**🖥️ Explication étape par étape :**

- GitLab CI est intégré directement dans GitLab et fonctionne de manière similaire à GitHub Actions.
- Construction automatisée d'une image Docker.

## 🚀 TP Pratique guidé : mise en place d'un workflow CI/CD simple

### Objectif du TP

- Créer et tester un workflow GitHub Actions simple sur votre propre dépôt GitHub.

### Étapes à suivre

- Créer un dépôt GitHub
- Créez un nouveau dépôt public GitHub (ex: demo-ci-cd).
- Ajouter votre Dockerfile simple

```Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

- Ajoutez un fichier ```index.html``` personnalisé.
- Créer votre workflow
- Placez le workflow YAML sous ```.github/workflows/ci.yml``` comme vu précédemment.
- Déclencher la CI/CD
- Poussez votre code vers GitHub pour déclencher l'action.

```shell
git add .
git commit -m "Ajout workflow CI/CD"
git push origin main
```

### Validation des résultats

- Vérifiez dans l’onglet « Actions » du dépôt GitHub que le workflow s'exécute correctement.
