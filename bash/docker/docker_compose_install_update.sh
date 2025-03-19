#!/bin/bash

# Script interactif pour installer ou mettre à jour Docker Compose

# Demander au développeur s'il souhaite installer ou mettre à jour Docker Compose
read -p "Voulez-vous installer ou mettre à jour Docker Compose ? (i pour installer, u pour mettre à jour) : " install_or_update

# Vérifier la réponse
if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
    echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
    exit 1
fi

# Définir la dernière version stable de Docker Compose
latest_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep "tag_name" | cut -d'"' -f4)

# Installer ou mettre à jour Docker Compose
if [ "$install_or_update" == "i" ]; then
    echo "Installation de Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/$latest_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Mise à jour de Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/$latest_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Afficher la version installée de Docker Compose
installed_version=$(docker-compose --version | awk '{print $3}')
echo "Docker Compose $installed_version a été installé ou mis à jour avec succès."