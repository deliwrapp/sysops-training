#!/bin/bash

# Script interactif pour installer ou mettre à jour MySQL sur Ubuntu

# Demander au développeur s'il souhaite installer ou mettre à jour MySQL
read -p "Voulez-vous installer ou mettre à jour MySQL ? (i pour installer, u pour mettre à jour) : " install_or_update

# Vérifier la réponse
if [ "$install_or_update" != "i" ] && [ "$install_or_update" != "u" ]; then
    echo "Réponse invalide. Veuillez répondre 'i' pour installer ou 'u' pour mettre à jour."
    exit 1
fi

# Définir le mot de passe pour l'utilisateur root MySQL
read -p "Entrez le mot de passe pour l'utilisateur root MySQL : " mysql_root_password

# Vérifier si le mot de passe est spécifié
if [ -z "$mysql_root_password" ]; then
    echo "Veuillez spécifier un mot de passe pour l'utilisateur root MySQL."
    exit 1
fi

# Installer ou mettre à jour MySQL
if [ "$install_or_update" == "i" ]; then
    echo "Installation de MySQL..."
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
else
    echo "Mise à jour de MySQL..."
    sudo apt-get update
    sudo apt-get upgrade -y mysql-server
fi

# Sécuriser l'installation MySQL
sudo mysql_secure_installation <<EOF

y
$mysql_root_password
$mysql_root_password
y
y
y
y
EOF

# Afficher la version installée de MySQL
installed_version=$(mysql --version | awk '{print $5}')
echo "MySQL $installed_version a été installé ou mis à jour avec succès."