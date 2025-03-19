#!/bin/bash

# Script interactif pour installer ou mettre à jour PostgreSQL sur Ubuntu

# Demander à l'utilisateur s'il souhaite installer ou mettre à jour PostgreSQL
read -p "Voulez-vous installer ou mettre à jour PostgreSQL ? (i pour installer, u pour mettre à jour) : " install_or_update

# Vérifier la réponse
if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
    echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
    exit 1
fi

# Définir le mot de passe pour l'utilisateur postgres
read -p "Entrez le mot de passe pour l'utilisateur postgres : " postgres_password

# Vérifier si le mot de passe est spécifié
if [ -z "$postgres_password" ]; then
    echo "Veuillez spécifier un mot de passe pour l'utilisateur postgres."
    exit 1
fi

# Installer ou mettre à jour PostgreSQL
if [ "$install_or_update" == "i" ]; then
    echo "Installation de PostgreSQL..."
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-contrib
else
    echo "Mise à jour de PostgreSQL..."
    sudo apt-get update
    sudo apt-get upgrade -y postgresql postgresql-contrib
fi

# Vérifier si PostgreSQL est en cours d'exécution
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL a été installé ou mis à jour avec succès."
else
    echo "Erreur : PostgreSQL n'est pas en cours d'exécution. Vérifiez l'installation."
    exit 1
fi

# Modifier le mot de passe de l'utilisateur postgres
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$postgres_password';"

echo "Le mot de passe de l'utilisateur postgres a été modifié avec succès."
