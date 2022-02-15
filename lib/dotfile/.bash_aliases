# ~/.bash_aliases

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F -t --color=auto'
    alias ll='ls -lhAS -F -t --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

tablet() {
	#ssh -l u0_a154 $1
	nc -lvp 3743
}

alias firefox-connect='sshuttle -H -N -r root:DetteErGruppe2SittSuperSikrePassord@128.39.143.176 172.168.2.0/24'
send() {
	scp "$1" root@128.39.143.176:"$2"
}

#zipfolder() {
#	zip -r "$1.zip" "$1/"*
#}

swpusage() {
	for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -n -k2
}


# some more aliases
#alias see='firefox --new-tab '
alias aliases='nano ~/.bash_aliases'
alias androidStudio='/home/sGodard/Applications/android-studio/bin/studio.sh'
alias atom='atom --no-sandbox'
alias autolock='blurlock'
alias bashrc='nano ~/.bashrc'
alias burpsuite='sudo burpsuite'
alias c='clear'
alias clock='tty-clock -c -C 7'
alias cls='clear'
alias cp='cp -r -i'
alias deb='dpkg -i'
alias dim='echo Terminal Dimensions: $(tput cols) columns x $(tput lines) rows'
alias dir='dir --color=auto'
alias discover='sudo netdiscover -i wlan0'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias greeterEdit='nano /etc/lightdm/lightdm-gtk-greeter.conf'
alias grep='grep'
alias hack='/home/sGodard/Documents/projects/AccessGrantedAlertScript.py'
alias hack2='cd / && find | lolcat'
alias hack3='echo "Do not disturb, L33T hacking in progress." | cowsay'
alias hack4='echo -e "\e[32m" & cat /dev/urandom | tr -cd " 01" | fold -w $COLUMNS'
alias hydrahelp='hydra -t 64 -L Documents/klasserom/usr_list.txt -P Documents/klasserom/psw_list/a_c.txt 194.69.213.40 ftp'
alias ifconfig='ip -c address && echo -e "\nPublic IP address:" && myip'
alias imageMagik='convert'
alias ll='ls -lahA -F -t --color=auto'
alias lock='blurlock'
alias ls='ls -F -t --color=auto'
alias la='ls -A -F -t --color=auto'
alias metasploit='msfconsole'
alias mkdir='mkdir -pv'
alias msg-host='nc -l -p PORT'
alias msg-join='telnet HOST-IP PORT'
alias mv='mv -i -v'
alias myip='curl --silent https://ipecho.net/plain; echo'
alias nano='nano -A -i -U -q'
alias neo='neofetch'
alias nmapHelp='nmap -sC -sV -A'
alias o='xdg-open'
alias onedrive='google-chrome --no-sandbox https://opplandvgs-my.sharepoint.com/personal/sama0705_opplandvgs_no/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Fsama0705%5Fopplandvgs%5Fno%2FDocuments%2FPersonlig'
alias passwdListAnalyse='pipal'
alias ping='ping -c 5'
alias pip='pip3'
alias pip27='pip'
alias pstree='pstree -C age -h'
alias py3='python3'
alias q='exit'
alias r='ranger'
alias reboot='sudo systemctl reboot'
#alias rm='rm -v -I'
alias screensaver='xfce4-terminal --fullscreen --title=screensaver -e "tty-clock -s -c -b -C 5"'
alias screenshot='maim --select -u "/home/$USER/Pictures/recent_screenshot.png"; notify-send "Screenshot taken"'
#alias search='echo "Husk at den søker gjennom dir du er i" && sudo find | grep'
alias search='xdg-open "$(locate home media | rofi -threads 0 -width 100 -dmenu -i -p "locate ")"'
alias shutdown='sudo shutdown now'
alias speedtest='speedtest-cli --simple'
alias spicetify='/home/sGodard/spicetify-cli/spicetify'
alias spotify-fix='sudo spicetify apply'
alias sqlinjection='sqlmap -r RAW_HEADER.TXT -p PARAM --tables --risk3 --level 5'
#alias stegsolve='sudo o /usr/share/java/stegsolve/stegsolve.jar'
alias sudi='sudo '
alias sudo='sudo '
alias sudp='sudo '
alias suroot='sudo -E su -p'
alias svgopen='firefox'
alias tree='/home/sGodard/Documents/tools/general/py-tree/tree.py'
alias vdir='vdir --color=auto'
alias wifi='nmcli dev wifi'
alias www='php -S localhost:8000'
alias www-open='xdg-open http://localhost:8000'
alias i3conf='sudo nano ~/.config/i3/config'
alias i3status-edit='sudo nano /etc/i3status.conf'
alias brightness-fix='xrandr --output eDP1 --brightness 1'
alias brightness='xrandr --output eDP1 --brightness'
alias connect-wifi='sh /home/sGodard/.config/polybar/scripts/connect-top-wifi.sh'
alias polyconf='sudo nano ~/.config/polybar/config'
alias comptonconf='sudo nano ~/.config/compton/compton.conf'
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias servster='echo "Jeghetersander";ssh ender@40.88.147.240'
alias mkserver='echo "Joe123mama!!";ssh Humle@40.88.147.240'
#alias mkserver='echo "joemama";ssh markus@81.167.126.238'
alias cal='cal -wm'
alias storage='/home/sGodard/.config/polybar/scripts/storage'
alias sizeOfDir='du -sh'
alias stopSpotify='rm /tmp/spotifyID & killall spotify'
alias pythonserver='python3 -m http.server'
alias refreshPrompt='PS1=$(/bin/prompt)'
alias resetPrompt='PS1=$(/bin/prompt)'
alias frequency='/home/sGodard/Documents/tools/freq.py'
alias bluetoothStart='systemctl start bluetooth.service'
alias prosjektorfix='xrandr --output HDMI1 --mode 1920x1080 --same-as eDP1'
alias less='less -S'
#alias clearNotifications="//notifWrapper.py clear"
# bruk bokbind
#alias paru='paru --skipreview'
alias javaoptions='nano /etc/environment'
alias wordlist='echo "/usr/share/dirbuster/directory-list-2.3-medium.txt"'
alias commit='git commit -m'
alias audiostego='/home/sGodard/Documents/ctf/tools/AudioStego/build/hideme'
alias zip='zip -r'
alias grepInDir='grep -r -n -I -i'
alias nc='ncat'
alias java16='/usr/lib/jvm/java-16-adoptopenjdk/bin/java'
alias xxd='xxd -g 1'
alias gpush='cat /home/sGodard/.ssh/github_personal_access_token | copy; git push'
alias bluetoothConnectedDevices='bluetoothctl devices | cut -f2 -d" " | while read uuid; do bluetoothctl info $uuid; done|grep -e "Device\|Connected\|Name"'
alias paru="/home/sGodard/Documents/linux-customization/checkKernel ;paru"
alias unmount='umount'
alias sleuthkit='cat /home/sGodard/.config/sleuthkit/info'
alias rofissh='rofi -show ssh'
alias rm='echo -e "Be careful! Use full path /usr/bin/rm to prove your intent"'
