#!/bin/bash

# Inclure le script avec la fonction
source docker_install_update.fun.sh
source docker_compose_install_update.fun.sh
source docker_extensions_install.fun.sh

# Appeler les fonction
docker_install_update "i"
docker_compose_install_update "i"
docker_extensions_install