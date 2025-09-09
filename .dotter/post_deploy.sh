#!/usr/bin/bash

# Post deployment script after using dotter

# Set bash as default for terminal
if [ "$SHELL" = "/usr/bin/zsh" ]; then # Likely kali box
    echo "/usr/bin/bash" >> ~/.zshrc
elif [ "$SHELL" = "/usr/bin/bash" ]; then
    echo "Using Bash as default shell"
else
    for rc in $(find "$HOME" -wholename "$HOME/.*rc"); do
        echo -e "Consider adding bash as default using:\n\techo '/usr/bin/bash' >> $rc"
    done
fi

# Set bash as default shell
chsh -s /usr/bin/bash

# Setting wallpaper
monitor=$(xfconf-query --channel xfce4-desktop --list | grep -i last-image | grep workspace)
xfconf-query -c xfce4-desktop -p "$monitor" -s "$HOME"/Pictures/wp.jpg

xrandr --listmonitors | awk '{print $4}' | tail -n $(( $( xrandr --listmonitors | wc -l ) - 1 )) | while read monitor; do
    xfconf-query --channel xfce4-desktop -property /backdrop/screen0/monitor"$monitor"/workspace0/last-image -n -t string -s "$HOME"/Pictures/wp.jpg
done

# Keyboard settings
setxkbmap no
localectl set-x11-keymap no # Asks for system to input password

chmod +x ~/.prompt_script

# Opening bash
bash
