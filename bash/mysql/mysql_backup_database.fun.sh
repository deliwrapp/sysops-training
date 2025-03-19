#!/bin/bash

# Fonction pour sauvegarder une base de données MySQL
function mysql_backup_database() {
    local db_name="$1"
    local mysql_password="$2"
    local backup_path="$3"
    local export_format="$4"

    if [ -z "$db_name" ]; then
        read -p "Nom de la base de données à sauvegarder : " db_name
    fi

    if [ -z "$mysql_password" ]; then
        # Demander le mot de passe de l'utilisateur MySQL
        read -s -p "Mot de passe de l'utilisateur MySQL : " mysql_password
        echo # Ajouter un saut de ligne après la saisie du mot de passe
    fi

    if [ -z "$backup_path" ]; then
        read -p "Chemin d'enregistrement du backup (par défaut : ./backup/) : " backup_path
    fi

    if [ -z "$export_format" ]; then
        read -p "Format d'export (sql, csv, json, txt ; par défaut : sql) : " export_format
    fi

    if [ -z "$db_name" ]; then
        echo "Veuillez spécifier un nom de BDD de valide."
        exit 1
    fi

    if [ -z "$mysql_password" ]; then
        echo "Veuillez spécifier le mot de passe MySql."
        exit 1
    fi
    
    # Vérifier si le format d'export est spécifié, sinon utiliser "sql" par défaut
    export_format=${export_format:-sql}

    # Vérifier si le chemin d'enregistrement du backup est spécifié, sinon utiliser "./backup/"
    backup_path=${backup_path:-./backup/}

    # Vérifier si le répertoire de sauvegarde existe, sinon le créer
    if [ ! -d "$backup_path" ]; then
        mkdir -p "$backup_path" || { echo "Erreur : Impossible de créer le répertoire de sauvegarde."; exit 1; }
    fi

    # Vérifier si l'utilisateur a les droits d'écriture dans le répertoire de sauvegarde
    if [ ! -w "$backup_path" ]; then
        echo "Erreur : Vous n'avez pas les droits d'écriture dans le répertoire de sauvegarde."
        exit 1
    fi

    # Vérifier si le nom de la base de données est spécifié
    if [ -z "$db_name" ]; then
        echo "Veuillez spécifier le nom de la base de données."
        exit 1
    fi

    # Vérifier si le format d'export est valide
    case "$export_format" in
        "sql" | "csv" | "json" | "txt")
            ;;
        *)
            echo "Format d'export invalide. Utilisation du format par défaut : sql"
            export_format="sql"
            ;;
    esac

    # Nom du fichier de sauvegarde avec la date et l'heure actuelles
    backup_file="$backup_path$db_name-$(date +'%Y%m%d%H%M%S').$export_format"

    # Utiliser la commande mysqldump pour sauvegarder la base de données
    mysqldump -u root -p"$mysql_password" "$db_name" > "$backup_file"

    # Vérifier si la sauvegarde a réussi
    if [ $? -eq 0 ]; then
        echo "La sauvegarde de la base de données '$db_name' a été créée avec succès : $backup_file"
    else
        echo "Erreur lors de la sauvegarde de la base de données '$db_name'. Vérifiez les informations fournies."
    fi
}