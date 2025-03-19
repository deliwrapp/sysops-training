#!/bin/bash

# Script interactif pour l'installation d'extensions Docker sur Ubuntu

# Liste des extensions Docker disponibles
docker_extensions=("compose" "machine" "buildx" "registry" "cli" "swarm" "networking" "kubernetes")

# Demander au développeur de choisir les extensions à installer
echo "Choisissez les extensions Docker à installer (séparées par des espaces) :"
select_extensions=()
select_extension_names=()

for i in "${!docker_extensions[@]}"; do
    echo "$((i+1)). ${docker_extensions[i]}"
done

while true; do
    read -p "Entrez le numéro de l'extension à installer (0 pour terminer) : " choice
    if [ "$choice" -eq 0 ]; then
        break
    elif [ "$choice" -ge 1 ] && [ "$choice" -le "${#docker_extensions[@]}" ]; then
        select_extensions+=("${docker_extensions[choice-1]}")
        select_extension_names+=("${docker_extensions[choice-1]}")
    else
        echo "Choix invalide. Veuillez entrer un numéro valide ou 0 pour terminer."
    fi
done

# Vérifier si des extensions ont été sélectionnées
if [ ${#select_extensions[@]} -eq 0 ]; then
    echo "Aucune extension sélectionnée. Installation annulée."
    exit 1
fi

# Installer les extensions Docker sélectionnées
echo "Installation des extensions Docker sélectionnées : ${select_extension_names[@]}"

for extension in "${select_extensions[@]}"; do
    case "$extension" in
        "compose")
            echo "Installation de Docker Compose..."
            sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            ;;
        "machine")
            echo "Installation de Docker Machine..."
            sudo curl -L "https://github.com/docker/machine/releases/latest/download/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine
            sudo chmod +x /usr/local/bin/docker-machine
            ;;
        "buildx")
            echo "Installation de Docker Buildx..."
            sudo docker buildx install
            ;;
        "registry")
            echo "Installation de Docker Registry..."
            sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
            ;;
        "cli")
            echo "Aucune installation nécessaire pour Docker CLI, car il est inclus avec Docker."
            ;;
        "swarm")
            echo "Installation de Docker Swarm..."
            sudo docker swarm init
            ;;
        "networking")
            echo "Installation du plugin Docker Networking..."
            sudo docker network create mynetwork
            ;;
        "kubernetes")
            echo "Installation de Docker Kubernetes..."
            sudo docker run -d --name kube -p 6443:6443 gcr.io/google_containers/kube-apiserver:v1.19.0
            ;;
        *)
            echo "Extension Docker non reconnue : $extension. Aucune installation n'a été effectuée."
            ;;
    esac
done

echo "Les extensions Docker suivantes ont été installées avec succès : ${select_extension_names[@]}"