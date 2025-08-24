#!/usr/bin/bash

# Post deployment script after using dotter

# Set bash as default for terminal
if [ "$SHELL" == "/usr/bin/zsh" ]; then # Likely kali box
    echo "/usr/bin/bash" >> ~/.zshrc
elif [ "$SHELL" == "/usr/bin/bash" ]; then
    echo "Using Bash as default"
else
    for rc in $(find "$HOME" -wholename "$HOME/.*rc"); do
        echo -e "Consider adding bash as default using:\n\techo '/usr/bin/bash' >> $rc"
    done
fi

# Setting wallpaper
monitor=$(xfconf-query --channel xfce4-desktop --list | grep -i last-image | grep workspace)
xfconf-query -c xfce4-desktop -p "$monitor" -s "$HOME"/Pictures/wp.jpg

# Keyboard settings
xsetkbmap no

# Message to user
echo -e "Install:\nranger\nhtop\ntodo"

# Opening bash
bash
