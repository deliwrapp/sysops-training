#!/bin/bash

# Script interactif pour la mise à jour d'un dépôt Git

function git_update_repo() {
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
        echo "Veuillez spécifier chemin de destination valide."
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

    # Mettre à jour le dépôt depuis GitLab avec la branche spécifiée
    if [ -d "$destination_path" ]; then
        read -p "Le répertoire de destination existe déjà. Voulez-vous mettre à jour le dépôt ? (y/n) " update_repo
        if [ "$update_repo" = "y" ]; then
            echo "Mise à jour du dépôt existant..."
            cd "$destination_path" || exit 1
            git pull origin "$git_branch"
        else
            echo "Mise à jour annulée."
            exit 0
        fi
    else
        read -p "Le répertoire de destination n'existe pas. Voulez-vous le créer et cloner le dépôt ? (y/n) " clone_repo
        if [ "$clone_repo" = "y" ]; then
            echo "Clonage du dépôt pour la première fois..."
            git clone --branch "$git_branch" "$gitlab_repo_url" "$destination_path"
        else
            echo "Opération annulée."
            exit 0
        fi
    fi

    echo "Le dépôt a été mis à jour avec succès."
}
