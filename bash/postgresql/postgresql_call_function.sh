#!/bin/bash

# Inclure le script avec la fonction
source postgresql_install_update.fun.sh
source postgresql_backup_database.fun.sh

# Appeler les fonction
postgresql_install_update "i" "password_postgresql"
postgresql_backup_database "nom_de_la_base" "password_postgresql" "./repertoire_de_sauvegarde/" "sql"
