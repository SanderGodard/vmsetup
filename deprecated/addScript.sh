#!/bin/bash

if [ "$#" != 1 ]; then
	echo "usage: addScript [scriptPath]"
	exit
fi
scriptname=$(echo "$1" | rev | cut -d'/' -f1 | rev)
mkdir lib/"$scriptname"
cp "$1" lib/"$scriptname"/"$scriptname"
