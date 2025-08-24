#!/bin/python3
from subprocess import check_output, run, PIPE
from os import popen, chmod
from urllib import request
from getpass import getpass
from termcolor import colored

outputFile = "generalLocalInfo.txt"
connectFile = "connect"
sendFile = "send"

class m():
	pre = " "
	pos = " "
	err = 	colored(pre + "[×]" + pos, "red")
	warn =	colored(pre + "[!]" + pos, "yellow")
	info =	colored(pre + "[i]" + pos, "blue")
	tsk = 	colored(pre + "[.]" + pos, "blue")
	ok = 	colored(pre + "[+]" + pos, "green")
	prompt =colored(pre + "[>]" + pos, "magenta")
	flag =  colored(pre + "[#]" + pos, "blue", attrs=["blink", "bold"])

with open(outputFile, "w") as fil:
	fil.write("General info about connection installer script\n")

for fileName in [connectFile, sendFile]:
	with open(fileName, "w") as fil:
		fil.write("#!/usr/bin/bash\n")

def checkService():
	if str(checkReturnCode("systemctl status ssh")) == "0":
		print(m.info + "The ssh service seems to be running fine")
	else:
		print(m.err + "Doesn't look like ssh is running.")
		print(m.warn + "Please ensure that the ssh service is running as should before continuing")
		input(m.info + "Press [Enter] when ready ")


def cmd(command, formatIP=False):
	if formatIP:
		try:
			return check_output(command, shell=True).decode("utf-8").split(" ")[0]
		except:
			print(m.err + f"Could not get IP address with: {command}")
			print(m.err + "Make sure you are connected to the network/internet")
			exit()
	else:
		return check_output(command, shell=True).decode("utf-8")


def checkReturnCode(command):
	result = run(command.split(), stdout=PIPE, stderr=PIPE)
	return str(result.returncode)


def checkIP(ip, skipPing=False):
	if "." not in ip:
		print(m.err + "This IP address doesn't contain any '.', please ensure it is IPv4")
		return 0
	if not len(ip.split(".")) == 4:
		print(m.err + "This IP address doesn't contain all 4 subnet parts, unusable")
		return 0
	if len(ip) < 7:
		print(m.err + "This IP address seems too short, unusable")
		return 0
	if not skipPing:
		if not str(checkReturnCode(f"ping -c 1 {ip}")) == "0":
			print(m.err + f"Could not reach IP {ip}")
			print(m.info + "Will try to continue anyways")
	return 1


def getLocalIPCommand():
	return "ip a | grep inet | grep -v -e '127.0' -e ':' | cut -d'/' -f1 | awk '{print $2}' | xargs"

# Start of procedures
checkService()
print(m.tsk + "Fetching neccesary IP addresses")

gotIP = False
fails = 0
while gotIP == False:
	llIP = cmd(getLocalIPCommand(), formatIP=True)


	if checkIP(llIP):
		gotIP = True
	else:
		fails += 1
		print(m.err + "Could not get local IP address")
		if fails > 3:
			print(m.prompt + "Please enter local IP address manually")
			llIP = input(m.prompt)
			if checkIP(llIP):
				gotIP = True


gotIP = False
fails = 0
while gotIP == False:
	try:
		plIP = str(request.urlopen('https://ipecho.net/plain').read())
		plIP = plIP[2:-1]
	except:
		print(m.err + "Could not get public IP address")
		print(m.err + "Make sure you are connected to the internet")
		exit()

	if checkIP(plIP, True):
		gotIP = True
	else:
		fails += 1
		print(m.err + "Could not get public IP address")
		if fails > 3:
			print(m.prompt + "Please enter public IP address manually")
			plIP = input(m.prompt)
			if checkIP(plIP, True):
				gotIP = True


# printFile(pIP)
gotIP = False
fails = 0
while gotIP == False:
	print(m.prompt + "What's the remote public IP address? ")
	prIP = input(m.prompt)

	if checkIP(prIP, True):
		gotIP = True
	else:
		fails += 1
		print(m.err + "Could not get public IP address")
		if fails > 3:
			print(m.prompt + "Please enter public IP address manually")
			prIP = input(m.prompt)
			if checkIP(prIP, True):
				gotIP = True


print(m.ok + "Got IP addresses")
print(m.prompt + "What's the remote login username? ")
runame = input(m.prompt)
luname = cmd("id -un")
print(m.prompt + "What's the remote login password? ")
rpassw = getpass(m.prompt)
# rpassw = input(prompt)


print(m.tsk + "Getting the remote host's local IP")
print(m.tsk + "Connecting")
gotIP = False
fails = 0
while gotIP == False:
	lrIP = cmd(f"ssh -t {runame}@{prIP} {getLocalIPCommand()}", formatIP=True)

	if checkIP(lrIP, True):
		gotIP = True
	else:
		fails += 1
		print(m.err + "Could not get public IP address")
		if fails > 3:
			print(m.prompt + "Please enter public IP address manually")
			lrIP = input(m.prompt)
			if checkIP(lrIP, True):
				print(m.ok + "Got the remote host's local IP")
				gotIP = True


with open(outputFile, "a") as f:
	f.write("\nLocal machine:\n")
	f.write("public IP:".ljust(11) + plIP + "\n")
	f.write("local IP:".ljust(11) + llIP)
	f.write("usr:".ljust(11) + luname + "\n")

	f.write("\nRemote machine:\n")
	f.write("public IP:".ljust(11) + prIP + "\n")
	f.write("local IP:".ljust(11) + lrIP)
	f.write("usr:".ljust(11) + runame + "\n")
	f.write("psw:".ljust(11) + rpassw + "\n")

print(m.prompt + "Do you want to copy over ssh-id now? (Y/n)")
inp = input(m.prompt)
if len(inp) >= 1 and inp[0].upper() == "N":
	pass
else:
	print(m.tsk + "Copying over ssh-id")
	try:
		cmd(f"ssh-copy-id {runame}@{prIP}")
		print(m.ok + "Copied over ssh-id")
	except:
		print(m.err + "Failed, couldn't copy over ssh-id using 'copy-ssh-id'")


print(m.prompt + "Do you want to open a vpn connection now? (Y/n)")
inp = input(m.prompt)
if len(inp) >= 1 and inp[0].upper() == "N":
	pass
else:
	print(m.tsk + "Opening vpn connection for general forwarding")
	try:
		cmd(f"sshuttle -D -H -N -r {runame}:{rpassw}@{prIP} {lrIP}/24 &")
		print(m.ok + f"Opening vpn connection for general forwarding from\n	Remote: {prIP}\n		to\n	Local:{plIP}")
	except:
		print(m.err + "Failed, couldn't open the connection using sshuttle")

print(m.info + "Making shorthand connection script")

#connectFile
with open(connectFile, "a") as f:
	f.write(f"sshpass -p '{rpassw}' ssh {runame}@{prIP}")
chmod(connectFile, 0o777)

#sendFile
with open(sendFile, "a") as f:
	f.write(f"""if [ $# -lt 2 ]; then
	echo -e 'usage: $0 <from-local-file> <to-remote-file>'
	exit 1
else
	scp -r -p "$1" {runame}@{prIP}:"$2"
fi""")
chmod(sendFile, 0o777)

print(m.ok + f"Made '{connectFile}' and '{sendFile}', execute it to automatically ssh into the remote host")

print(m.ok + "Done with setup")
print(m.prompt + f"File for quick overview is '{outputFile}', open now? (Y/n)")
inp = input(m.prompt)
if len(inp) >= 1 and inp[0].upper() == "N":
	pass
else:
	checkReturnCode(f"less {outputFile}")
