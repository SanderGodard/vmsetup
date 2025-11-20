#!/usr/bin/bash

git clone https://github.com/SanderGodard/vmsetup.git

cd vmsetup

# Dotfiles has script stored in .dotter/post_deploy.sh
./dotter_x64 deploy -f
