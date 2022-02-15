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
shopt -o noclobber

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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
# export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "
if [ "$color_prompt" = yes ]; then
	#Backup - PS1='${debian_chroot:+($debian_chroot)}\e[\033\]\e[01;31m\u\]\e[0m@\e[37m\H\]\[\033[00m\]:\[\033[01;34m\]\]\w\[\033[00m\] \$ '
	#Backup 2 - PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[00;00m\]@\[\033[01;0m\]\H\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\] \$ '
	#PS1='${debian_chroot:+($debian_chroot)}\[\033[00;00m\]╭── \[\033[01;31m\]\u\[\033[00;00m\]@\[\033[01;0m\]\H\[\033[01;31m\]\[\033[00;00m\] ─── \[\033[00;34m\]\w\[\033[01;00m\] ─── \[\033[01;33m\]$(date +%H:%M)\n\[\033[00;00m\]╰─\$ '

	#scriptttt
	#sleep .01
PS1='${debian_chroot:+($debian_chroot)}\
\[\033[00;00m\]╭── \
\[\033[01;31m\]\u\
\[\033[00;00m\]@\
\[\033[01;0m\]\H\
\[\033[01;31m\]\[\033[00;00m\] ── \
\[\033[00;34m\]\w\
\[\033[01;00m\] \
$(repeat " " \
$(($(tput cols) - \
$(count "$(id -un)'@'$(hostname)") - \
$(count "$(dirs +0)") - \
$(count "00:00") - 10))) \
\[\033[01;95m\]$(date +%H:%M)\
\n\
\[\033[00;00m\]╰─\
\[\033[01;34m\]\$\
\[\033[00;00m\] '
	# The script doesn't use an ordinary space. Dont delete this character " "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\H:\w \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac






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
cl() {
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


#alias wireguard-ecsc19-kill='wg-quick down wireguard/sander.conf'
#alias wireguard-ecsc19='wg-quick up wireguard/sander.conf'
#alias discord='discord --no-sandbox'
#alias chrome='google-chrome --no-sandbox'

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

# default editor
export EDITOR='nano'

export TZ=Europe/Oslo

# startup commands
# Turns on numlock
#setleds -D +num
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

numlockx on

clear

sleep .2
if (( $(tput cols) > 51 )) && (( $(tput lines) > 20 )); then
	neofetch
fi
# ~/.bash_aliases

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F -t --color=auto'
    alias ll='ls -lhA -F -t --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more aliases
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
alias grep='grep'
alias ifconfig='ip address && echo -e "\nPublic IP address:" && myip'
alias ll='ls -lahA -F -t --color=auto'
alias ls='ls -A -F -t --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -i -v'
alias myip='curl --silent https://ipecho.net/plain; echo'
alias nano='nano -A -i -U -q'
alias neo='neofetch'
alias nmapHelp='nmap -sC -sV -A'
alias ping='ping -c 5'
alias pip='pip3'
alias pip27='pip'
alias pstree='pstree -C age -h'
alias py3='python3'
alias q='exit'
alias r='ranger'
alias rm='rm -v -I'
alias search='echo "Husk at den søker gjennom dir du er i" && sudo find | grep'
alias shutdown='sudo shutdown now'
alias speedtest='speedtest-cli --simple'
alias sqlinjection='sqlmap -r RAW_HEADER.TXT -p PARAM --tables --risk3 --level 5'
alias sudi='sudo '
alias sudo='sudo '
alias sudp='sudo '
alias suroot='sudo -E su -p'
alias vdir='vdir --color=auto'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cal='ncal -w -b -M'
alias sizeOfDir='du -sh'
