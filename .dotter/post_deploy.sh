#!/usr/bin/bash

# Post deployment script after using dotter
echo "[-] Running post-deploy script"

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

# Keyboard settings
setxkbmap no
localectl set-x11-keymap no # Asks for system to input password

# Prompt
chmod +x ~/.prompt_script

# Creating symlinks for scripts
echo "Using ./generate-symlinks.sh to fix symlinks that dotter cannot"
$(./generate-symlinks.sh) 2> /dev/null

# Config
# Default position for rockyou in kali
gunzip /usr/share/wordlists/rockyou.txt.gz
# TMUX settings
echo "set -g mouse on\n" >> $HOME/.tmux.conf

# XFCE settings
echo "Using ./xfce4-customize.sh to set wallpaper and such"
./xfce4-customize.sh

echo "Remember to update and upgrade"

echo "[-] Opening bash"
# Opening bash
bash