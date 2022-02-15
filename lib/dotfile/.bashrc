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
