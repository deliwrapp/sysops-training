#!/bin/bash

# Inclure le script avec la fonction
source symfony_install_update.fun.sh
source symfony_deploy.fun.sh

# Appeler les fonction
symfony_install_update "i"
symfony_deploy "votre_utilisateur_ssh" "votre_adresse_ip_ou_nom_de_domaine" "remote_path" "branch" "app_path"
