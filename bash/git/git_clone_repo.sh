#!/bin/bash

# Script pour cloner un répertoire depuis un dépôt Git sur Ubuntu

# Demander les informations au développeur
read -p "URL du dépôt Git : " git_repo_url
read -p "Branche à cloner (Laissez vide pour la branche par défaut) : " git_branch
read -p "Chemin du répertoire de destination : " destination_path

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

# Cloner le répertoire depuis le dépôt Git avec la branche spécifiée (ou la branche par défaut)
if [ -n "$git_branch" ]; then
    git clone --branch "$git_branch" "$git_repo_url" "$destination_path"
else
    git clone "$git_repo_url" "$destination_path"
fi

echo "Le répertoire a été cloné avec succès."