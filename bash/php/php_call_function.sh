#!/bin/bash

# Inclure le script avec la fonction
source php_install.fun.sh
source php_extensions_install.fun.sh

# Appeler les fonction
php_install "8.2"
php_extensions_install "8.2"