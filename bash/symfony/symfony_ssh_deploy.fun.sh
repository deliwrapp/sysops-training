#!/bin/bash

# Script de déploiement Symfony

# Variables
REMOTE_USER="votre_utilisateur_ssh"
REMOTE_HOST="votre_adresse_ip_ou_nom_de_domaine"
REMOTE_PATH="/chemin/vers/votre/application"
BRANCH="master"

# Fonction pour déployer l'application Symfony
symfony_ssh_deploy() {
    local remote_user="$1"
    local remote_host="$2"
    local remote_path="$3"
    local branch="$4"

    if [ -z "$remote_user" ]; then
        read -p "Remote User : " remote_user
    fi

    if [ -z "$remote_host" ]; then
        read -p "Remote Host : " remote_host
    fi

    if [ -z "$remote_path" ]; then
        read -p "Remote Path : " remote_path
    fi

    if [ -z "$branch" ]; then
        read -p "Branche de déploiement : " branch
    fi

    if [ -z "$app_path" ]; then
        read -p "Répertoire local de l'application Symfony : " app_path
    fi

    if [ -z "$remote_user" ]; then
        echo "Veuillez spécifier le Remote User."
        exit 1
    fi

    if [ -z "$remote_host" ]; then
        echo "Veuillez spécifier le Remote Host."
        exit 1
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

    # Déployer l'application sur le serveur distant via SSH
    ssh $remote_user@$remote_host <<EOF
        echo "Connexion au serveur distant réussie."

        # Se déplacer vers le répertoire distant de l'application Symfony
        cd $remote_path

        # Récupérer les dernières modifications depuis le référentiel Git
        git pull origin $branch

        # Installer les dépendances avec Composer
        composer install --no-dev --optimize-autoloader

        # Mettre à jour la base de données si nécessaire
        php bin/console doctrine:migrations:migrate --no-interaction

        # Effacer le cache Symfony
        php bin/console cache:clear --env=prod

        echo "Fin du déploiement Symfony sur le serveur distant."
EOF

    echo "Fin du déploiement Symfony."
}