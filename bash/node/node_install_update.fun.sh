#!/bin/bash

# Script pour l'installation de Node JS 
function node_install_update() {
    local install_or_update="$1"
    local node_version="$1"

    if [ -z "$install_or_update" ]; then
        # Demander au développeur s'il souhaite installer ou mettre à jour Node.js
        read -p "Voulez-vous installer ou mettre à jour Node.js ? (i pour installer, u pour mettre à jour) : " install_or_update
    fi
    # Vérifier la réponse
    if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
        echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
        exit 1
    fi

    # Vérifier si l'argument node_version est fourni
    if [ -z "$node_version" ]; then
        # Demander la version de Node.js à installer si elle n'est pas spécifiée
        read -p "Version de Node à installer (par exemple, 20) : " node_version
    fi

    # Vérifier si la version de Node est spécifiée
    if [ -z "$node_version" ]; then
        echo "Veuillez spécifier une version de Node valide."
        exit 1
    fi

    # Installer ou mettre à jour Node.js
    if [ "$install_or_update" == "i" ]; then
        echo "Installation de Node.js version $node_version..."
        sudo apt-get update
        sudo apt-get install -y curl
        curl -sL https://deb.nodesource.com/setup_"$node_version".x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "Mise à jour de Node.js vers la version $node_version..."
        sudo apt-get update
        sudo apt-get install -y nodejs="$node_version"
    fi

    # Afficher la version installée de Node.js
    installed_version=$(node -v)
    echo "Node.js $installed_version a été installé ou mis à jour avec succès."

}