#!/usr/bin/bash

if [[ "$#" -ne 1 ]]; then
	echo -e "usage: $0 <IP-address or range>"
	exit
fi

# Setting globals
targets="targets.lst"
logSuffix="_scan.log"
targetsip=$(echo "$1" | tr '.' '_' | tr '/' '#')
fastlogname="quick_""$targetsip""$logSuffix"

blue="\e[34m"
normal="\e[0m"
heading="\e[1;36m"
info="$blue""[i]""$normal"" "
task="[*] "

# Functions
discovery() {
	echo -e "$task""Discovering alive targets"
	#hostsResult=$(fping -ganq $1)
	hostsResult=$(nmap -sn -T4 "$@" | grep "Nmap scan report for" | awk '{print $NF}')
	count=$(echo "$hostsResult" | wc -l)
	echo -e "$info""Found $count targets"

	echo -e "" > "$targets"
	while IFS= read -r host; do
		echo -e "$host" >> "$targets"
	done <<< "$hostsResult"
	echo -e "$info""Written target list to $targets"
}


unset targetsOverview
OSScan() {
	echo -e "$task""Getting OS information"
	while IFS= read -r host; do
		echo -e "$host" >> "$targets"
		osscan=$(nmap "$host" -O -T5 -F)
#		filter=$(echo "$osscan" | grep OS | grep -v -e cpe | cut -d: -f2 | cut -d')' -f1 | head -n 1)
		filter=$(echo "$osscan" | grep -e OS -e HOST | grep -v -e cpe -e nmap | cut -d: -f2- | cut -d')' -f1 | head -n 1)
		hostOS="$host\t$filter"")"
		echo -e " | ""$hostOS"
		targetsOverview+=("# ""$hostOS")
	done <<< "$hostsResult"
}

quickScan() {
	echo -e "$task""Running QUICK portscan"
	echo -e "$heading""Quick portscan overview of $@\n""$normal" > "$fastlogname"
	while IFS= read -r host; do
		for line in "${targetsOverview[@]}"; do # Only runs if OSScan has been performed
			if [[ "$line" == *"$host"* ]]; then
				echo -e "\n\n""$heading""$line""$normal" >> "$fastlogname"
			fi
		done
		nmap "$host" -T5 -F -sV -sC >> "$fastlogname"
	done <<< "$hostsResult"
	echo -e "$info""Written quick scan log to $fastlogname"
}

detailedScan() {
	echo -e "$task""Running DETAILED portscan"
	while IFS= read -r host; do
		hostip=$(echo "$host" | tr '.' '_')
		logname="$hostip""$logSuffix"
		output=$(nmap "$host" -T4 -p- -sV -sC -A -oN "$logname")
		echo -e "$info""Outputting log: $logname"
	done <<< "$hostsResult"
}

# Running
echo -e "$info""Scanning ip(s) $1"

discovery "$@"
OSScan "$@"
#quickScan "$@"
# &
# sleep 1
# watch "cat $fastlogname"
# detailedScan "$@"
# less "$fastlogname"

echo -e "$info""Done"