#!/bin/bash

# Script interactif pour sauvegarder une base de données PostgreSQL sur Ubuntu

# Demander à l'utilisateur de spécifier les détails de la sauvegarde
read -p "Nom de la base de données à sauvegarder : " db_name
read -p "Format d'export (par défaut : sql) : " export_format
read -p "Chemin d'enregistrement du backup (par défaut : ./backup/) : " backup_path

# Vérifier si le format d'export est spécifié, sinon utiliser "sql" par défaut
export_format=${export_format:-sql}

# Vérifier si le chemin d'enregistrement du backup est spécifié, sinon utiliser "./backup/"
backup_path=${backup_path:-./backup/}

# Vérifier si le répertoire de sauvegarde existe, sinon le créer
if [ ! -d "$backup_path" ]; then
    read -p "Le répertoire d'enregistrement du backup n'existe pas. Voulez-vous le créer ? (o/n) : " create_backup_path
    if [ "$create_backup_path" == "o" ]; then
        mkdir -p "$backup_path" || { echo "Erreur : Impossible de créer le répertoire de sauvegarde."; exit 1; }
    else
        echo "Annulation de la sauvegarde. Le répertoire de sauvegarde n'existe pas."
        exit 1
    fi
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
    "sql" | "custom" | "tar" | "plain" | "directory")
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