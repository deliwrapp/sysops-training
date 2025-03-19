#!/bin/bash

# Script pour installer ou mettre à jour Composer sur Ubuntu

# Demander au développeur s'il souhaite installer ou mettre à jour Composer
read -p "Voulez-vous installer ou mettre à jour Composer ? (i pour installer, u pour mettre à jour) : " install_or_update

# Vérifier la réponse
if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
    echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
    exit 1
fi

# Installer ou mettre à jour Composer
if [ "$install_or_update" == "i" ]; then
    echo "Installation de Composer..."
    sudo apt-get update
    sudo apt-get install -y composer
else
    echo "Mise à jour de Composer..."
    sudo composer self-update
fi

# Afficher la version installée de Composer
installed_version=$(composer --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
echo "Composer version $installed_version a été installé ou mis à jour avec succès."
