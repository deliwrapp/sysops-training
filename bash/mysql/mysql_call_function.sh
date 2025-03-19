#!/bin/bash

# Inclure le script avec la fonction
source mysql_install_update.fun.sh
source mysql_backup_database.fun.sh

# Appeler les fonction
mysql_install_update "i" "password_mysql"
mysql_backup_database "nom_de_la_base" "password_mysql" "./repertoire_de_sauvegarde/" "sql"
