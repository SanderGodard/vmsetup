# ~/.bashrc: executed by bash(1) for non-login shells.

# To get /etc/sudoers.lecture on each time you type password edit /etc/sudoers using root user

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="[%d/%m/%y %T] "
# append to the history file, don't overwrite it
shopt -s histappend
#shopt -o noclobber

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=30000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


PS1=$(/bin/prompt)


#			Scripts

# Extracts files from compression
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#copy file contents to clipboard
copy() {
	xclip -i $1 -selection clipboard
}

# cd and ls into same dir
cdls() {
	cd "$1"
	ls
}

# Make dir then cd into it
mkcd() {
	mkdir -p "$1"
	cd "$1"
}

# Scan qr code with zbarimg
qrScan() {
	zbarimg $1 | cut -d ":" -f2
}

# Open image in new window (without error messages)
see() {
	eog $1 &> /dev/null
}

# Open other shit
open() {
	xdg-open $1 &> /dev/null
}

# Move things to their places
#move() {
#	i3-msg move container[class="Spotify$"] to workspace3
#	i3-msg workspace1
#
#	wmctrl -r "Spotify Premium" -t 2
#	wmctrl -r "Discord" -t 2
#	wmctrl -r "Mozilla Firefox" -t 1
#	wmctrl -r "erminal" -t 0
#	wmctrl -s 1
#	sleep 1
#	wmctrl -s 0
#}

# Diff-file
diff-file() {
	diff -syT "$1" "$2" | less
}

# Get last file from download
lastDownload() {
	mv ~/Downloads/"$(ls -1t ~/Downloads/ | head -n1)" "$(pwd)"/.
}

# Get last screenshot from tmp
lastScreenshot() {
	if [ $# == 1 ]; then
		mv /tmp/"$(ls -1t /tmp/ | grep 'screenshot' | head -n1)" "$(pwd)"/"$1"
	else
		mv /tmp/"$(ls -1t /tmp/ | grep 'screenshot' | head -n1)" "$(pwd)"/.
	fi
}

# gcc compile and make exe
compile() {
	if [ "$#" != 1 ]; then
		echo "usage: compile [file.c]"
		return
	fi
	name="$(echo $1 | cut -d'.' -f1)"
	gcc "$1" -o "$name"
	if [ "$?" == 0; then
		chmod +x "$name"
		echo "$name compiled and is executable with './$name'"
	fi
}

# cat all files in dir
catdir() {
	arra="$(find)"
	for i in $arra; do
		if [[ -e $i && ! -d $i ]]; then
			cat "$i"
		fi
	done
}

#Takes author as argument
gitLinesByAuthor() {
	git log --author="$1" --pretty=tformat: --numstat \
	| gawk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }' -
}

# For every file in dir, do $@
forEveryFileInDir() {
	find . | while read line; do "$@" "$line"; done
}

# Shorthand reach into tools dir and get tool
# Homemade autocomplete right here
#ctftools() {
#	if [ "$#" -lt 2 ]; then
#		echo "$(ls ~/Documents/tools/$1)"
#	else
#		~/Documents/tools/"$1"/"$2" "$@"
#	fi
#}

# This one uses good autocomplete that lies in /usr/share/bash-completion/completions/tools
tools() {
	echo "~/Documents/tools/$1/$2 ${@:3}"
	~/Documents/tools/"$1"/"$2" "${@:3}"
}

# Spawn new terminal in same dir (WIP)
#spawnHere() {
#	tmpalac="/tmp/alacritty-tmp-last-pwd"
#	echo -e "cd $(pwd)" > "$tmpalac"
#	alacritty -e "$tmpalac" & disown -a
#}

# Spawn unicode pretty border making characters
unicodeBorderChars() {
	for i in 6a 6b 6c 6d 6e 71 74 75 76 77 78; do
		printf "0x$i \x$i \x1b(0\x$i\x1b(B\n";
	done

}

#decompress zlib
zlibd() {
	for var in "$@"; do
		if [ -f "$var" ]; then
			printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" | cat - "$var" | gzip -dc > "$var""_decompressed"
		else
			echo "$var is not a file"
		fi
	done
}




# Adds colors to LESS
export LESS_TERMCAP_mb=$'\E[01;31mBold'
export LESS_TERMCAP_md=$'\E[01;96m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Tell LESS to normally use colors for ls and grep, ignore case, and see percentage through file
export LESS="-iMR"

# default editor
export EDITOR='nano'

# Timezone
export TZ=Europe/Oslo

# Default browser
export BROWSER="/opt/google/chrome/google-chrome --profile-directory=Default"

# Default display
export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0

#alias wireguard-ecsc19-kill='wg-quick down wireguard/sander.conf'
#alias wireguard-ecsc19='wg-quick up wireguard/sander.conf'
#alias discord='discord --no-sandbox'
#alias chrome='google-chrome --no-sandbox'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# startup commands

# Turns on numlock
#setleds -D +num
numlockx on

# Language keymap
setxkbmap no


# Makes numpad . be .
#xmodmap -e 'keycode 79 = 7 7'
#xmodmap -e 'keycode 80 = 8 8'
#xmodmap -e 'keycode 81 = 9 9'
#xmodmap -e 'keycode 82 = KP_Subtract KP_Subtract'
#xmodmap -e 'keycode 83 = 4 4'
#xmodmap -e 'keycode 84 = 5 5'
#xmodmap -e 'keycode 85 = 6 6'
#xmodmap -e 'keycode 86 = KP_Add KP_Add'
#xmodmap -e 'keycode 87 = 1 1'
#xmodmap -e 'keycode 88 = 2 2'
#xmodmap -e 'keycode 89 = 3 3'
#xmodmap -e 'keycode 90 = 0 0'
xmodmap -e 'keycode 91 = period period'

#cd
#cd /home/sGodard/Documents/skole/ntnu/
cd /home/sGodard/Documents/
#cd /home/sGodard/Documents/skole/ntnu/informasjonsteknologi-tdt4109/inspera/eksamen
#cd /home/sGodard/Documents/ctf/ncsc2022/

#if (( $(ps aux | grep "startx" | grep -v -e "grep" | wc -l) < 1 )); then
#	sleep 4; nmcli d s &
#fi

#clear

#sleep .2
#if (( $(tput cols) > 51 )) && (( $(tput lines) > 20 )); then
#	neofetch
#fi


# Java opplegg???
export CLASSPATH=".:./*"
export CLASSPATH="$CLASSPATH:/usr/share/java/junit.jar"
export CLASSPATH="$CLASSPATH:../../../../src/main/java/*/*"
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


# quickly jot down notes
note() {
	echo -e "\n$*" >> notes
}

# wifi config, for those browser login functions
wificonfig() {
	google-chrome-stable "$(route -n | head -n3 | tail -n1 | awk '{print $2}')"
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
alias ifconfig='ip -c address && ip route show && route -n && echo -e "\nPublic IP address:" && myip'
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
alias paru="/home/sGodard/Documents/linux-customization/checkKernel ; storage ; paru"
alias unmount='umount'
alias sleuthkit='cat /home/sGodard/.config/sleuthkit/info'
alias rofissh='rofi -show ssh'
alias rm='echo -e "Be careful! Use full path /usr/bin/rm to prove your intent"'
alias fontsUpdate='fc-cache -f'
alias ..='cd ..'
alias sl='ls'
alias notes='nano notes' # Har lagt inn note funksjon øverst i fila
#alias gcc-mingw='x86_64-w64-mingw32-gcc'
