#!/bin/bash

# Fonction pour sauvegarder une base de données PostgreSQL
function postgresql_backup_database() {
    local db_name="$1"
    local postgres_password="$2"
    local backup_path="$3"
    local export_format="$4"

    if [ -z "$db_name" ]; then
        read -p "Nom de la base de données à sauvegarder : " db_name
    fi

    if [ -z "$postgres_password" ]; then
        # Demander le mot de passe de l'utilisateur PostgreSQL
        read -s -p "Mot de passe de l'utilisateur PostgreSQL : " postgres_password
        echo # Ajouter un saut de ligne après la saisie du mot de passe
    fi

    if [ -z "$backup_path" ]; then
        read -p "Chemin d'enregistrement du backup (par défaut : ./backup/) : " backup_path
    fi

    if [ -z "$export_format" ]; then
        read -p "Format d'export (sql, csv, txt, tar, plain, directory ; par défaut : sql) : " export_format
    fi

    if [ -z "$db_name" ]; then
        echo "Veuillez spécifier un nom de BDD de valide."
        exit 1
    fi

    if [ -z "$postgres_password" ]; then
        echo "Veuillez spécifier le mot de passe PostgreSql."
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
        "sql" | "csv" | "txt" | "tar" | "plain" | "directory")
            ;;
        *)
            echo "Format d'export invalide. Utilisation du format par défaut : sql"
            export_format="sql"
            ;;
    esac

    # Nom du fichier de sauvegarde avec la date et l'heure actuelles
    backup_file="$backup_path$db_name-$(date +'%Y%m%d%H%M%S').$export_format"

    # Demander le mot de passe de l'utilisateur PostgreSQL
    read -s -p "Mot de passe de l'utilisateur PostgreSQL : " postgres_password
    echo # Ajouter un saut de ligne après la saisie du mot de passe

    # Utiliser la commande pg_dump pour sauvegarder la base de données
    pg_dump -U postgres -w -F $export_format -f "$backup_file" "$db_name"

    # Vérifier si la sauvegarde a réussi
    if [ $? -eq 0 ]; then
        echo "La sauvegarde de la base de données '$db_name' a été créée avec succès : $backup_file"
    else
        echo "Erreur lors de la sauvegarde de la base de données '$db_name'. Vérifiez les informations fournies."
    fi

}