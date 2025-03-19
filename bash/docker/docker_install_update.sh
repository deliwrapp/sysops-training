#!/bin/bash

# Script interactif pour installer ou mettre à jour Docker

# Installer ou mettre à jour Docker
if [ "$install_or_update" == "i" ]; then
    echo "Installation de Docker..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    echo "Mise à jour de Docker..."
    sudo apt-get update
    sudo apt-get upgrade -y docker-ce docker-ce-cli containerd.io
fi

# Afficher la version installée de Docker
installed_version=$(docker --version | awk '{print $3}')
echo "Docker $installed_version a été installé ou mis à jour avec succès."