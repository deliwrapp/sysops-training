#!/bin/bash

# Script interactif pour l'installation de GIT

# Vérifier l'installation de Git
if ! command -v git &> /dev/null; then
    read -p "Git n'est pas installé. Voulez-vous l'installer maintenant ? (y/n) " install_git
    if [ "$install_git" = "y" ]; then
        sudo apt-get update
        sudo apt-get install -y git
    else
        echo "Le script nécessite Git. Installation annulée."
        exit 1
    fi
fi