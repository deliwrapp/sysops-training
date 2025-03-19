#!/bin/bash

# Inclure le script avec la fonction
source git_install.fun.sh
source git_clone_repo.fun.sh
source git_update_repo.fun.sh

# Appeler les fonction
git_install "y"
git_clone_repo "git@gitlab.git" "git@gitlab.git" "main" "./"
git_update_repo "git@gitlab.git" "git@gitlab.git" "main" "./"