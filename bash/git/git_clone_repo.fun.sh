#!/bin/bash

# Script pour cloner un répertoire depuis un dépôt Git sur Ubuntu

function git_clone_repo() {
    local git_repo_url="$1"
    local git_branch="$2"
    local destination_path="$3"

    # Demander les informations au développeur si non fournis
    
    if [ -z "$git_repo_url" ]; then
        read -p "URL du dépôt Git : " git_repo_url
    fi

    if [ -z "$git_branch" ]; then
        read -p "Branche du dépôt Git : " git_branch
    fi

    if [ -z "$destination_path" ]; then
        read -p "Path de destination : " destination_path
    fi

    if [ -z "$git_repo_url" ]; then
        echo "Veuillez spécifier une url de repositoire Git valide."
        exit 1
    fi
    
    if [ -z "$git_branch" ]; then
        echo "Veuillez spécifier une branche."
        exit 1
    fi

    if [ -z "$destination_path" ]; then
        echo "Veuillez spécifier chemin de destinartion valide."
        exit 1
    fi

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
}
