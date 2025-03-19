#!/bin/bash

# Script de déploiement Symfony

# Fonction pour déployer l'application Symfony
symfony_deploy() {
    local remote_path="$1"
    local branch="$2"

    if [ -z "$branch" ]; then
        read -p "Branche de déploiement : " branch
    fi

    if [ -z "$remote_path" ]; then
        read -p "Remote Path : " remote_path
    fi

    if [ -z "$remote_path" ]; then
        echo "Veuillez spécifier le Remote Path."
        exit 1
    fi

    if [ -z "$branch" ]; then
        echo "Veuillez spécifier la branche."
        exit 1
    fi

    echo "Début du déploiement Symfony..."

    # Se déplacer vers le répertoire local de l'application Symfony
    cd $remote_path

    # Récupérer les dernières modifications depuis le référentiel Git
    git pull origin $branch

    # Installer les dépendances avec Composer
    composer install --no-dev --optimize-autoloader

    # Mettre à jour la base de données si nécessaire
    php bin/console doctrine:migrations:migrate --no-interaction

    # Effacer le cache Symfony
    php bin/console cache:clear --env=prod

    echo "Fin du déploiement Symfony."
}