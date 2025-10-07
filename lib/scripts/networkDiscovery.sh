#!/usr/bin/bash

# Setting globals
TARGETS="targets.lst"
logSuffix="_scan.log"

BLUE="\e[34m"
NC="\e[0m"
HEADING="\e[1;36m"
INFO="${BLUE}[i]${NC} "
TASK="[*] "

# Functions
usage() {
	echo -e "Usage: $(basename $0) [OPTIONS] <IP-address or range> [IP-address or range]"
	echo -e "Script for efficiently running host discovery, and running standardized nmap port scans"
	echo -e ""
	echo -e "Options:"
	echo -e "  -h, --help, -?	Display this help message and exit"
	echo -e "  -o, --osscan		Perform OS scan"
	echo -e "  -q, --quickscan	Perform quick NMAP scan for overview while doing detailed scan"
	echo -e "  -d, --detailedscan	Perform detailed NMAP TCP standard scan to look for common services"
	echo -e "  -u, --udpscan	Perform detailed NMAP UDP scan to avoid missing any UDP running (beware of false positives)"
	echo -e "  -s, --stealthyscan	Perform stealthy NMAP scan to avoid detection at the cost of time"
	echo -e "  -r, --readlog	Automatically open quickscan log of finished scans with 'less'"
	echo -e ""
	echo -e "Example:"
	echo -e "  $(basename $0) -o -q -r 10.129.22.228"
	exit
}

discovery() {
	echo -e "${TASK}Discovering alive targets"
	#hostsResult=$(fping -ganq $1)
	hostsResult=$(nmap -sn -T4 "$@" | grep "Nmap scan report for" | awk '{print $NF}')
	count=$(echo "$hostsResult" | wc -l)
	echo -e "${INFO}Found $count targets"

	if [[ -f "$TARGETS" ]]; then rm "$TARGETS"; fi
	while IFS= read -r host; do
		echo -e "$host" >> "$TARGETS"
	done <<< "$hostsResult"
	echo -e "${INFO}Written target list to $TARGETS"
}


unset targetsOverview
OSScan() {
	echo -e "${TASK}Getting OS information"
	while IFS= read -r host; do
		osscan=$(nmap "$host" -O --top-ports=20 -F --osscan-guess)
#		filter=$(echo "$osscan" | grep OS | grep -v -e cpe | cut -d: -f2 | cut -d')' -f1 | head -n 1)
		filter=$(echo "$osscan" | grep -e OS -e HOST | grep -v -e cpe -e nmap | cut -d: -f2- | cut -d')' -f1 | head -n 1)
		hostOS="$host\t$filter"")"
		echo -e " | ""$hostOS"
		targetsOverview+=("# ""$hostOS")
	done <<< "$hostsResult"
}

quickScan() {
	echo -e "${TASK}Running QUICK portscan"
	echo -e "${HEADING}Quick portscan overview of $@\n${NC}" > "$fastlogname"
	while IFS= read -r host; do
		for line in "${targetsOverview[@]}"; do # Only runs if OSScan has been performed
			if [[ "$line" == *"$host"* ]]; then
				echo -e "\n\n${HEADING}$line${NC}" >> "$fastlogname"
			fi
		done
		nmap "$host" -T5 -F -sV -sC >> "$fastlogname"
	done <<< "$hostsResult"
	echo -e "${INFO}Written quick scan log to $fastlogname"
}

detailedScan() {
	echo -e "${TASK}Running DETAILED TCP portscan"
	while IFS= read -r host; do
		hostip=$(echo "$host" | tr '.' '_')
		logname="$hostip""$logSuffix"
		output=$(nmap "$host" -T4 -p- -sV -sC -A --append-output -oN "$logname")
		echo -e "${INFO}Outputting log: $logname"
	done <<< "$hostsResult"
}

udpScan() {
	echo -e "${TASK}Running DETAILED UDP portscan"
	while IFS= read -r host; do
		hostip=$(echo "$host" | tr '.' '_')
		logname="$hostip""$logSuffix"
		output=$(nmap "$host" -T4 -p53,47,48,88,123,137,161,514 -sU -sV --append-output -oN "$logname")
		echo -e "${INFO}Outputting log: $logname"
	done <<< "$hostsResult"
}

stealthyScan() {
	echo -e "${TASK}Running STEALTHY portscan"
	while IFS= read -r host; do
		hostip=$(echo "$host" | tr '.' '_')
		logname="$hostip""$logSuffix"
		output=$(nmap "$host" --top-ports 50 -T2 -sS --append-output -oN "$logname")
		echo -e "${INFO}Outputting log: $logname"
	done <<< "$hostsResult"
}


main() {
	# ArgParsing
	doOSScan=0
	doQuickScan=0
	doDetailedScan=0
	doStealthyScan=0
	doReadLog=0
	ips=()

	while test $# != 0; do
	    case "$1" in
	    -o|--osscan) doOSScan=1 ;;
	    -q|--quickscan) doQuickScan=1 ;;
	    -d|--detailedscan) doDetailedScan=1 ;;
	    -u|--udpscan) doUDPScan=1 ;;
	    -s|--stealthyscan) doStealthyScan=1 ;;
	    -r|--readlog) doReadLog=1 ;;
	    *)  ips+=("$1") ;;
	    esac
	    shift
	done

	targetsip=$(echo "$ips" | tr '.' '_' | tr '/' '#' | tr ' ' '+')
	fastlogname="quick_""$TARGETSip""$logSuffix"


	# Running
	echo -e "${INFO}Scanning ip(s) $ips"

	discovery "$ips"

	if [[ $doOSScan == 1 ]]; then
		OSScan "$ips"
	fi
	if [[ $doQuickScan == 1 ]]; then
		quickScan "$ips"
	fi
	if [[ $doDetailedScan == 1 ]]; then
		detailedScan
	fi
	if [[ $doUDPScan == 1 ]]; then
		udpScan
	fi
	if [[ $doStealthyScan == 1 ]]; then
		stealthyScan
	fi
	if [[ $doReadLog == 1 && $doQuickScan == 1 ]]; then
		less "$fastlogname"
	fi

	echo -e "${INFO}Done"
}


if [[ "$#" -lt 1 || "$*" == *"-h"* ]]; then
	usage $@
else
	main $@
fi
