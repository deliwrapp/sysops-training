#!/bin/bash

# Script interactif pour l'installation d'extensions PHP

function php_extensions_install() {
    local php_version="$1"

    # Vérifier si l'argument php_version est fourni
    if [ -z "$php_version" ]; then
        # Demander la version de PHP à installer si elle n'est pas spécifiée
        read -p "Version de PHP à installer (par exemple, 8.2) : " php_version
    fi

    # Vérifier si la version de PHP est spécifiée
    if [ -z "$php_version" ]; then
        echo "Veuillez spécifier une version de PHP valide."
        exit 1
    fi

    # Liste des extensions PHP disponibles
    extensions=("bcmath" "gd" "mbstring" "mysql" "mysqli" "pdo" "sqlite3" "xml" "zip")

    # Demander au développeur de choisir les extensions à installer
    echo "Choisissez les extensions PHP à installer (séparées par des espaces) :"
    select_extensions=()
    select_extension_names=()
    select_extension_codes=()
    for i in "${!extensions[@]}"; do
        echo "$((i+1)). ${extensions[i]}"
    done

    while true; do
        read -p "Entrez le numéro de l'extension à installer (0 pour terminer) : " choice
        if [ "$choice" -eq 0 ]; then
            break
        elif [ "$choice" -ge 1 ] && [ "$choice" -le "${#extensions[@]}" ]; then
            select_extensions+=("${extensions[choice-1]}")
            select_extension_names+=("php${php_version}-${extensions[choice-1]}")
            select_extension_codes+=("php${php_version}-${extensions[choice-1]}")
        else
            echo "Choix invalide. Veuillez entrer un numéro valide ou 0 pour terminer."
        fi
    done

    # Vérifier si des extensions ont été sélectionnées
    if [ ${#select_extensions[@]} -eq 0 ]; then
        echo "Aucune extension sélectionnée. Installation annulée."
        exit 1
    fi

    # Installer les extensions PHP sélectionnées
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install -y "${select_extension_codes[@]}"

    # Afficher les extensions installées
    echo "Les extensions suivantes ont été installées avec succès : ${select_extension_names[@]}"
}
