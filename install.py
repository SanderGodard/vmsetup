#!/bin/python3
from os import get_terminal_size, path, scandir, remove, makedirs, system
from shutil import copy, copytree, rmtree
from termcolor import colored
from platform import python_version
from time import sleep
import argparse



def getArguments():
	# Define arguments and types
	parser = argparse.ArgumentParser(description='VMsetup - small temporary config install script')
	parser.add_argument('-v', '--verbose', dest='verbose', action='store_true', help="Print debugging information")
	parser.add_argument('-t', '--testrun', dest='testrun', action='store_true', help="Run script without making any changes to computer")
	parser.add_argument('-l', '--lib-path', type=str, metavar="path", dest='libPath', help="Full path of the vmsetup library folder - (default path is './lib/')")
	args = parser.parse_args()
	return args


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


def checkPythonVersion():
	if (int(python_version().split(".")[0]) <= 3) and (int(python_version().split(".")[1]) < 7):
		print(m.err + "Python version is too old.")
		exit()


def art(termwidth):
	smallmsg = "VMsetup | Make your VMs comfy"
	a = """██╗   ██╗███╗   ███╗███████╗███████╗████████╗██╗   ██╗██████╗
██║   ██║████╗ ████║██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║   ██║██╔████╔██║███████╗█████╗	 ██║   ██║   ██║██████╔╝
╚██╗ ██╔╝██║╚██╔╝██║╚════██║██╔══╝	 ██║   ██║   ██║██╔═══╝
 ╚████╔╝ ██║ ╚═╝ ██║███████║███████╗   ██║   ╚██████╔╝██║
  ╚═══╝  ╚═╝	 ╚═╝╚══════╝╚══════╝   ╚═╝	╚═════╝ ╚═╝
A small collection of scripts with a automatic install script,
to help setup basic comfort in new temporary VMs"""
# https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Moon
	alist = a.split("\n")
	artwidth = len(alist[0])
	if termwidth < artwidth:
		print(smallmsg)
	#	print("By Ender")
	else:
		filler = " " * ((termwidth-artwidth)//2)
		for line in alist:
			print(filler + line)


def checkdir(p, home=False):
	if not p[-1] == "/":
		p += "/"
	if not path.isdir(p):
		print(m.warn + f"Expected to put the file(s) in:\n {p}\nBut the directory was missing/not accessible.")
		print(m.info + f"If you input the same directory, the script will create it.")
		if home == False:
			h = ""
		else:
			h = "home "
		inp = input(m.prompt + f"Where is the correct {h}directory? ")
		if inp == p:
			os.makedirs(p)
		return checkdir(inp)
	return p


def chooseHome():
	print(m.info + "Will automatically try to make backups")
	users = [ f.name for f in scandir("/home/") if f.is_dir() ]
	users.append("root")

	while True:
		print(m.prompt + "Which of the following home directories do you want to install in?")
		for i, user in enumerate(users):
			print(f"  [{i}] {user}")
		inp = input(m.prompt + " ")
		if inp.isnumeric() and int(inp) < len(users):
			chosen = users[int(inp)]
			break
		else:
			print(m.err + "Input takes numbers, eg. '0'")

	if chosen == "root":
		homePath = checkdir("/root/", True)
	else:
		homePath = checkdir(f"/home/{chosen}", True)

	print(m.info + "Home folder set to: " + homePath)
	return homePath


def move(testrun, f, t):
	if testrun:
		print(m.flag + f"Pretending to move {f} to {t}")
		return
	if path.isdir(t):
		rmtree(t)
	else:
		remove(t)
	if path.isdir(f):
		copytree(f, t)
	else:
		copy(f, t)
	return


def moveFile(testrun, verbose, f, t): # from, to
	if path.exists(t):
		if path.exists(t + ".bak"):
			print(m.warn + f"Backup for {t} already exists. Overwriting.")
			move(testrun, t, t + ".bak")
		if verbose: print(m.info + f"Path already exists, moving existing to backup.")
		move(testrun, f, t)
	else:
		if testrun:
			print(m.flag + f"Pretending to move {f} to {t}")
			return
		if path.isdir(f):
			copytree(f, t)
		else:
			copy(f, t)
	return


class Config():
	def __init__(self, args, name="name", endpoint="/tmp/vmsetup/", file="file.name", note=None):
		self.args = args
		self.name = name
		self.endpoint = endpoint
		self.file = file
		self.note = note
		self.termwidth = args.width

	def install(self):
		max = self.termwidth - 5
		if max < 0: max = 0
		r = "\r"
		if self.args.verbose or self.args.testrun: r="\n"
		print(m.tsk + f"Adding {self.name} ..."[:max], end=r)
		if self.args.verbose: print(m.tsk + f"Copying {self.args.libPath}{self.name}/{self.file} to {self.endpoint}")
		loc = checkdir(self.endpoint) # Checking that endpoint folder exists
		moveFile(self.args.testrun, self.args.verbose, f"{self.args.libPath}{self.name}/{self.file}", loc + self.file) # Check if config file already exist
		print(m.ok + f"Added {self.name}")
		if not self.note is None: print(m.info + self.note)
		return True


def runInstallation(args, home):
	# name is same as folder in lib
	Config(args, name="htop", endpoint="/usr/bin/", file="htop", note="Process manager").install()
	Config(args, name="prompt", endpoint="/usr/bin/", file="prompt", note="Prompt script to be used by .bashrc").install()
	Config(args, name="bashrc", endpoint=home, file=".bashrc").install()
	Config(args, name="nmap", endpoint="/usr/bin/", file="nmap").install()
	Config(args, name="vibeCheck", endpoint="/usr/bin/", file="vibeCheck", note="Custom nmap script").install()
	Config(args, name="w", endpoint="/usr/bin/", file="w", note="Watch system users activity").install()
	Config(args, name="pip", endpoint="/usr/bin/", file="pip", note="Python installation service").install()
	Config(args, name="ncat", endpoint="/usr/bin/", file="ncat", note="Networking tool").install()
	Config(args, name="unzip", endpoint="/usr/bin/", file="unzip", note="To unzip shit").install()
	Config(args, name="gobuster", endpoint="/usr/bin/", file="gobuster", note="Directory brute force machine").install()
	Config(args, name="dirbust_list", endpoint=home, file="dirbust_list.txt", note="Directory name list").install()
	Config(args, name="xclip", endpoint="/usr/bin/", file="xclip", note="Clipboard manager").install()
	Config(args, name="setxkbmap", endpoint="/usr/bin/", file="setxkbmap", note="Keyboard language manager").install()
	Config(args, name="numlockx", endpoint="/usr/bin/", file="numlockx", note="Numlock fix that goes with bashrc").install()
	system("/usr/bin/pip install termcolor pwntools pycryptodome")


	# Det under her blir for moon-landing
	# Config(args, name="rofi-theme", endpoint="/usr/share/rofi/themes/", file="Moon.rasi", note="To select the rofi theme run 'rofi-theme-selector'").install()
	# Config(args, name="rofi-config", endpoint=home + ".config/rofi/", file="config").install()
	# Config(args, name="polybar", endpoint=home + ".config/", file="polybar/").install()
	# Config(args, name="dunst", endpoint=home + ".config/dunst/", file="dunstrc").install()
	# Config(args, name="i3-gaps", endpoint=home + ".config/i3/", file="config").install()
	# Config(args, name="alacritty", endpoint=home + ".config/alacritty/", file="alacritty.yml").install()
	# Config(args, name="wallpapers", endpoint=home + "Pictures/", file="Wallpapers/").install()
	# Config(args, name="gtk-theme", endpoint="/usr/share/themes", file="Moon/").install()
	# Config(args, name="gtk-config", endpoint=home + ".config/", file="gtk-3.0/", note="Requires reboot to take effect").install()
	return


def main():
	checkPythonVersion()

	args = getArguments()
	if args.libPath is None:
		args.libPath = checkdir("./lib/")

	args.width = get_terminal_size()[0] or 0
	art(args.width)
	home = chooseHome()

	time = int(3)
	i = time
	s = "s"
	max = args.width - 5
	if max < 0: max = 0
	while i > 0:
		if i == 1:
			s = ""
		print(m.info + f"Installation starts in {i} second{s} ..."[:max], end="\r")
		sleep(1)
		i -= 1

	print(m.info + "Adding configs")
	runInstallation(args, home)

	print(m.info + "Remember to set new password on the machine with 'passwd'")
	print(m.info + "Relay network connection back to local machine with 'sshuttle'")


	return


if __name__ == "__main__":
	main()
