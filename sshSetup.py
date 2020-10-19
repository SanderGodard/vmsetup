#!/bin/python3
from subprocess import check_output
from os import system, popen, chmod
from urllib import request
from getpass import getpass
from termcolor import colored

outputFile = "generalLocalInfo.txt"
connectFile = "connect"
sendFile = "send"

prompt = colored(" [_] ", "yellow")
tsk = colored(" [ ] ", "blue")
suc = colored(" [+] ", "green")
inf = colored(" [i] ", "blue")
err = colored(" [x] ", "red")
rew = chr(27) + "[1A" + chr(27) + "[2K"

with open(outputFile, "w") as fil:
	fil.write("General info about connection installer script\n")

with open(connectFile, "w") as fil:
	fil.write("#!/usr/bin/bash\n")

with open(sendFile, "w") as fil:
	fil.write("#!/usr/bin/bash\n")

def printFile(st, fil):
	print(st, file=open(fil, "a"))

def checkService():
	if str(system("systemctl status ssh 1> /dev/null")) == "0":
		print(inf + "The ssh service seems to be running fine")
	else:
		print(err + "Please ensure that the ssh service is running as should before continuing")
		input(inf + "Press [Enter] when ready ")

def cmd(st, ip=""):
	if ip == "ip":
		try:
			return check_output(st, shell=True).decode("utf-8").split(" ")[0]
		except:
			print(err + "Could not get IP address with: " + st)
			print(err + "Make sure you are connected to the network/internet")
			exit()
	else:
		return check_output(st, shell=True).decode("utf-8")


def checkIP(ip, skipPing=False):
	try:
		if ip[-1] == int(ip[-1]):
			pass
	except:
		try:
			ip = ip.split(" ")[0]
		except:
			liste = list(ip)
			ip = ""
			for i in liste:
				if not ((i == "\n") or (i == " ")):
					ip += i
	try:
		if ip[-1] == int(ip[-1]):
			pass
	except:
		print(err + "Unexpected error while quality checking IP address: " + ip)
		return 0
	if not skipPing:
		status = system("ping -c 1 " + ip + " 1> /dev/null")
		if not str(status) == "0":
			print(err + "Could not reach IP " + ip)
			print(inf + "Will try to continue anyways")
	if "." not in ip:
		print(err + "This IP address doesn't contain any '.', please ensure it is IPv4")
		return 0
	if len(ip) < 7:
		print(err + "This IP address seems too short, unusable")
		return 0
	return 1

checkService()
print(tsk + "Fetching neccesary IP addresses")

gotIP = False
fails = 0
while gotIP == False:
	llIP = cmd("hostname -I", "ip")


	if checkIP(llIP):
		gotIP = True
	else:
		fails += 1
		print(err + "Could not get local IP address")
		if fails > 3:
			print("Please enter local IP address manually")
			llIP = input(prompt)
			if checkIP(llIP):
				gotIP = True


gotIP = False
fails = 0
while gotIP == False:
	try:
		plIP = str(request.urlopen('https://ipecho.net/plain').read())
		plIP = plIP[2:-1]
	except:
		print(err + "Could not get public IP address")
		print(err + "Make sure you are connected to the internet")
		exit()

	if checkIP(plIP, True):
		gotIP = True
	else:
		fails += 1
		print(err + "Could not get public IP address")
		if fails > 3:
			print("Please enter public IP address manually")
			plIP = input(prompt)
			if checkIP(plIP, True):
				gotIP = True


# printFile(pIP)
gotIP = False
fails = 0
while gotIP == False:
	print("What's the remote public IP address? ")
	prIP = input(prompt)

	if checkIP(prIP, True):
		gotIP = True
	else:
		fails += 1
		print(err + "Could not get public IP address")
		if fails > 3:
			print("Please enter public IP address manually")
			prIP = input(prompt)
			if checkIP(prIP, True):
				gotIP = True


print(suc + "Got IP addresses")
print("What's the remote login username? ")
runame = input(prompt)
luname = cmd("id -un")
print("What's the remote login password? ")
rpassw = getpass(prompt)
# rpassw = input(prompt)


print(tsk + "Getting the remote host's local IP")
print(tsk + "Connecting")
gotIP = False
fails = 0
while gotIP == False:
	# lrIP = cmd("sshpass -p '" + rpassw + "' ssh -t " + runame + "@" + prIP + ' "hostname -I"', "ip")
	lrIP = cmd("ssh -t " + runame + "@" + prIP + ' "hostname -I"', "ip")

	if checkIP(prIP, True):
		gotIP = True
	else:
		fails += 1
		print(err + "Could not get public IP address")
		if fails > 3:
			print("Please enter public IP address manually")
			lrIP = input(prompt)
			if checkIP(lrIP, True):
				print(rew + suc + "Got the remote host's local IP")
				gotIP = True


printFile("\nLocal machine:\n", outputFile)
printFile("public IP:	" + plIP, outputFile)
printFile("local IP:	" + llIP, outputFile)
printFile("usr:		" + luname, outputFile)

printFile("\nRemote machine:\n", outputFile)
printFile("public IP:	" + prIP, outputFile)
printFile("local IP:	" + lrIP, outputFile)
printFile("usr:		" + runame, outputFile)
printFile("psw:		" + rpassw, outputFile)

print(inf + "Do you want to copy over ssh-id now?\n(Y/n)\n" + inf + "Default is Yes")
inp = input(prompt)
if (inp == "no") or (inp == "No"):
	pass
else:
	if len(inp) == 1 and inp == "n" or inp == "N":
		pass
	else:
		print(tsk + "Copying over ssh-id")
		try:
			cmd("ssh-copy-id " + runame + "@" + prIP)
			print(rew + suc + "Copied over ssh-id")
		except:
			print(err + "Failed, couldn't copy over ssh-id using copy-ssh-id")


print(inf + "Do you want to open a vpn connection now?\n(Y/n)\n" + inf + "Default is Yes")
inp = input(prompt)
if (inp == "no") or (inp == "No"):
	pass
else:
	if len(inp) == 1 and inp == "n" or inp == "N":
		pass
	else:
		print(tsk + "Opening vpn connection for general forwarding")
		try:
			cmd("sshuttle -D -H -N -r " + runame + ":" + rpassw + "@" + prIP + " " + lrIP + "/24 &")
			print(rew + suc + "Opening vpn connection for general forwarding from\n	Remote: " + prIP + "\n	to\n	Local:" + plIP)
		except:
			print(err + "Failed, couldn't open the connection using sshuttle")

print(inf + "Making shorthand connection script")

#connectFile
printFile("sshpass -p '" + rpassw + "' ssh " + runame + "@" + prIP, connectFile)
chmod(connectFile, 0o777)
#sendFile
printFile('if [ $# -lt 2 ]; then', sendFile)
printFile('	echo -e "usage: $0 <from-local-file> <to-remote-file>"', sendFile)
printFile('	exit 1', sendFile)
printFile('else', sendFile)
printFile('	scp -r -p "$1" ' + runame + "@" + prIP + ":" + '"$2"', sendFile)
printFile('fi', sendFile)
chmod(sendFile, 0o777)

print(rew + suc + "Made '" + connectFile + "' and '" + sendFile + "', execute it to automatically ssh into the remote host")

print(suc + "Done with setup")
print(inf + "File for quick overview is " + outputFile + ", open now?\n(Y/n)\n" + inf + "Default is Yes")
inp = input(prompt)
if (inp == "no") or (inp == "No"):
	pass
else:
	if len(inp) == 1 and inp == "n" or inp == "N":
		pass
	else:
		system("less " + outputFile)
