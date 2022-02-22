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


PS1=$(/usr/bin/prompt)


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

# Open image in new window (without error messages)
see() {
	eog $1 &> /dev/null
}

# Open other shit
open() {
	xdg-open $1 &> /dev/null
}

# Diff-file
diff-file() {
	diff -syT "$1" "$2" | less
}

# Get last file from download
lastDownload() {
	mv ~/Downloads/"$(ls -1t ~/Downloads/ | head -n1)" "$(pwd)"/.
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

# For every file in dir, do $@
forEveryFileInDir() {
	find . | while read line; do "$@" "$line"; done
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

cd ~/


# Java opplegg
export CLASSPATH=".:./*"
export CLASSPATH="$CLASSPATH:/usr/share/java/junit.jar"
export CLASSPATH="$CLASSPATH:../../../../src/main/java/*/*"


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

swpusage() {
	for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -n -k2
}


# some more aliases
alias aliases='nano ~/.bashrc'
alias bashrc='nano ~/.bashrc'
alias c='clear'
alias cls='clear'
alias cp='cp -r -i'
alias deb='dpkg -i'
alias dim='echo Terminal Dimensions: $(tput cols) columns x $(tput lines) rows'
alias dir='dir --color=auto'
alias discover='sudo netdiscover -i wlan0'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ifconfig='ip -c address && echo -e "\nPublic IP address:" && myip'
alias imageMagik='convert'
alias ll='ls -lahA -F -t --color=auto'
alias ls='ls -F -t --color=auto'
alias la='ls -A -F -t --color=auto'
alias metasploit='msfconsole'
alias mkdir='mkdir -pv'
alias mv='mv -i -v'
alias myip='curl --silent https://ipecho.net/plain; echo'
alias nano='nano -A -i -U -q'
alias neo='neofetch'
alias nmapHelp='nmap -sC -sV -A'
alias o='xdg-open'
alias ping='ping -c 5'
alias pip='pip3'
alias pip27='pip'
alias pstree='pstree -C age -h'
alias py3='python3'
alias q='exit'
alias r='ranger'
alias reboot='sudo systemctl reboot'
alias screenshot='maim --select -u "/home/$USER/Pictures/recent_screenshot.png"; notify-send "Screenshot taken"'
alias search='echo "Husk at den søker gjennom dir du er i" && sudo find | grep'
alias shutdown='sudo shutdown now'
alias sqlinjection='sqlmap -r RAW_HEADER.TXT -p PARAM --tables --risk3 --level 5'
alias sudi='sudo '
alias sudo='sudo '
alias sudp='sudo '
alias suroot='sudo -E su -p'
alias wifi='nmcli dev wifi'
alias brightness-fix='xrandr --output eDP1 --brightness 1'
alias brightness='xrandr --output eDP1 --brightness'
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias cal='cal -wm'
alias sizeOfDir='du -sh'
alias pythonserver='python3 -m http.server'
alias refreshPrompt='PS1=$(/bin/prompt)'
alias resetPrompt='PS1=$(/bin/prompt)'
alias bluetoothStart='systemctl start bluetooth.service'
alias less='less -S'
alias javaoptions='nano /etc/environment'
alias wordlist='echo "/usr/share/dirbuster/directory-list-2.3-medium.txt"'
alias zip='zip -r'
alias grepInDir='grep -r -n -I -i'
alias nc='ncat'
alias java16='/usr/lib/jvm/java-16-adoptopenjdk/bin/java'
alias xxd='xxd -g 1'
alias bluetoothConnectedDevices='bluetoothctl devices | cut -f2 -d" " | while read uuid; do bluetoothctl info $uuid; done|grep -e "Device\|Connected\|Name"'
alias unmount='umount'
alias rm='echo -e "Be careful! Use full path /usr/bin/rm to prove your intent"'
