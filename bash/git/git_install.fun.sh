#!/bin/bash

# Script interactif pour l'installation de GIT

function git_install() {
    local install_git="$1"

    # Demander les informations au développeur si non fournis

    # Vérifier l'installation de Git
    if ! command -v git &> /dev/null; then
    
        if [ -z "$install_git" ]; then
            read -p "Git n'est pas installé. Voulez-vous l'installer maintenant ? (y/n) " install_git
        fi

        if [ -z "$install_git" ]; then
            echo "Veuillez spécifier chemin de destinartion valide."
            exit 1
        fi
        
        if [ "$install_git" = "y" ]; then
            sudo apt-get update
            sudo apt-get install -y git
        else
            echo "Le script nécessite Git. Installation annulée."
            exit 1
        fi
    fi
}