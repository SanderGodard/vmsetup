#!/usr/bin/bash

# Setting wallpaper for XFCE4
echo -e "Setting up wallpaper"
xrandr --listmonitors | awk '{print $4}' | tail -n $(( $( xrandr --listmonitors | wc -l ) - 1 )) | while read monitor; do
    xfconf-query --channel xfce4-desktop -property /backdrop/screen0/monitor"$monitor"/workspace0/last-image -n -t string -s "$HOME"/Pictures/wp.jpg
done

echo -e "Finished"