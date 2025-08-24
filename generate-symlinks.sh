#!/usr/bin/bash

configFile=".dotter/global.toml"
pwd="$(pwd)"

IFS=$'\n'
for line in $(cat .dotter/global.toml | grep 'lib'); do
#    echo -e "$line"
    step="${line// = / }"
    step2="${step//lib/$pwd/lib}"
    echo -e "sudo ln -s ${step2//\~/$HOME}"
done
unset IFS