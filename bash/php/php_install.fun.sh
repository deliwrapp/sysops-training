#!/bin/bash

# Script pour l'installation de PHP 
function php_install() {
    local php_version="$1"

    # Vérifier si l'argument php_version est fourni
    if [ -z "$php_version" ]; then
        # Demander la version de PHP à installer si elle n'est pas spécifiée
        read -p "Version de PHP à installer (par exemple, 8.2) : " php_version
    fi

    # Vérifier si la version de PHP est spécifiée
    if [ -z "$php_version" ]; then
        echo "Veuillez spécifier une version de PHP valide."
        exit 1
    fi

    # Installer PHP
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install -y php"$php_version" php"$php_version"-cli php"$php_version"-fpm

    # Afficher la version installée de PHP
    installed_version=$(php -v | grep -oP "PHP \K[0-9]+\.[0-9]+")
    echo "PHP $installed_version a été installé avec succès."

}