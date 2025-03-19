#!/bin/bash

# Script interactif pour installer ou mettre à jour Symfony CLI sur Ubuntu

# Demander à l'utilisateur s'il souhaite installer ou mettre à jour Symfony CLI
read -p "Voulez-vous installer ou mettre à jour Symfony CLI ? (i pour installer, u pour mettre à jour) : " install_or_update

# Vérifier la réponse
if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
    echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
    exit 1
fi

# Installer ou mettre à jour Symfony CLI
if [ "$install_or_update" == "i" ]; then
    echo "Installation de Symfony CLI..."
    wget https://get.symfony.com/cli/installer -O - | bash
    sudo mv ~/.symfony* /usr/local/bin/symfony
else
    echo "Mise à jour de Symfony CLI..."
    symfony self-update
fi

# Vérifier si l'installation a réussi
if command -v symfony &> /dev/null; then
    echo "Symfony CLI a été installé ou mis à jour avec succès."
else
    echo "Erreur : Symfony CLI n'est pas installé. Vérifiez l'installation."
    exit 1
fi
