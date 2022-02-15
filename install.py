#!/bin/python3

from os import system, get_terminal_size, path, walk, scandir, remove
from shutil import copy, copytree, rmtree
from platform import python_version
from termcolor import colored
from time import sleep
import getpass
import apt


size = get_terminal_size()
space = " "
wart = 62
loud = False
checkuser = getpass.getuser()

cache = apt.cache.Cache()
notInstalled = False

prompt = colored(" [_] ", "yellow")
tsk = colored(" [ ] ", "blue")
suc = colored(" [+] ", "green")
inf = colored(" [i] ", "blue")
err = colored(" [x] ", "red")
rew = chr(27) + "[1A" + chr(27) + "[2K"

def backupfikser(dir, file):
    global prompt
    if path.isdir(dir + file):
        filedir = "directory"
    else:
        filedir = "file"
    inp = 0
    while inp < 1 or inp > 2:
        print(err + "The " + filedir + " '" + file + "' already exists, along with a backup.")
        print(err + "Do you want to:\n    [1] Keep old backup\n    [2] Remove old backup")
        inp = input(prompt)

        try:
            inp = int(inp)
        except:
            print(err + "Enter either '1' or '2' as numbers")
            inp = 0
        if inp == 2:
            # Skal være false
            checkfile(dir, file, False)
            #checkfile(dir, file, True)
            #print(inf + "Chose option 1 anyways")
        elif inp == 1:
            checkfile(dir, file, True)


def checkdir(direc):
    global prompt
    if not direc[-1] == "/":
        direc = direc + "/"
    if not path.isdir(direc):
        #print(err + "")
        print(err + "Expected to put the file(s) in:\n    " + direc + "\nBut the directory was missing/not accessible.\nWhere is the correct directory?")
        dir2 = input(prompt)
        direc = checkdir(dir2)
    return direc

# Setting default home folder here
home = checkdir(path.expanduser("~"))

def checkfile(dir, file, beholdgammel="vetIkke"):
    if path.exists(dir + file):
        if path.isdir(dir + file):
            try:
                if file[-1] == "/":
                    file = file[0:-1]
                if beholdgammel == "vetIkke":
                    if path.exists(dir + file + ".bak/"):
                        backupfikser(dir + "/", file)
                    else:
                        copytree(dir + file + "/", dir + file + ".bak/")
                        if loud:
                            print(inf + "Moved " + dir + file + " to " + dir + file + ".bak/")
                        rmtree(dir + file + "/")
                        if loud:
                            print(inf + "Removed " + dir + file + "/")
                elif beholdgammel == True:
                    rmtree(dir + file + "/")
                    if loud:
                        print(inf + "Removed " + dir + file + "/")
                elif beholdgammel == False:
                    rmtree(dir + file + ".bak/")
                    if loud:
                        print(inf + "Removed " + dir + file + ".bak/")
                    copytree(dir + file + "/", dir + file + ".bak/")
                    rmtree(dir + file + "/")
                    if loud:
                        print(inf + "Moved " + dir + file + " to " + dir + file + ".bak/")
                else:
                    print(err + "Some unexpected error encountered while trying to figure out backups and folders")
            except:
                print(err + "Something went wrong, backup probably already created")
                backupfikser(dir + "/", file)
        else:
            try:
                if beholdgammel == "vetIkke":
                    if path.exists(dir + file + ".bak"):
                        backupfikser(dir, file)
                    else:
                        copy(dir + file, dir + file + ".bak")
                        if loud:
                            print(inf + "Moved " + dir + file + " to " + dir + file + ".bak")
                        remove(dir + file)
                        if loud:
                            print(inf + "Removed " + dir + file)
                elif beholdgammel == True:
                    remove(dir + file)
                    if loud:
                        print(inf + "Removed " + dir + file)
                elif beholdgammel == False:
                    remove(dir + file + ".bak")
                    if loud:
                        print(inf + "Removed " + dir + file + ".bak")
                    copy(dir + file, dir + file + ".bak")
                    remove(dir + file)
                    if loud:
                        print(inf + "Moved " + dir + file + " to " + dir + file + ".bak")
                else:
                    print(err + "Some unexpected error encountered while trying to figure out backups and folders")
            except:
                print(err + "Something went wrong, backup probably already created")
                backupfikser(dir, file)
    #else:
    #    backupfikser(dir, file)


def art():
    if size[0] < wart:
        print("VMsetup | Make your VMs comfy")
    #    print("By Ender")
    else:
        amount = int((size[0]-wart)/2)

        filler = ""
        i = 0
        while i < amount:
            filler = filler + space
            i = i + 1

        print(filler + "██╗   ██╗███╗   ███╗███████╗███████╗████████╗██╗   ██╗██████╗ " + filler)
        print(filler + "██║   ██║████╗ ████║██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗" + filler)
        print(filler + "██║   ██║██╔████╔██║███████╗█████╗     ██║   ██║   ██║██████╔╝" + filler)
        print(filler + "╚██╗ ██╔╝██║╚██╔╝██║╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ " + filler)
        print(filler + " ╚████╔╝ ██║ ╚═╝ ██║███████║███████╗   ██║   ╚██████╔╝██║     " + filler)
        print(filler + "  ╚═══╝  ╚═╝     ╚═╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     " + filler)
        print(filler + "A small collection of scripts with a automatic install script," + filler)
        print(filler + "to help setup basic comfort in new temporary VMs              " + filler)
        # https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=vmsetup

def isInstalled(program):
    global cache
    global notInstalled
    try:
        if cache[program].is_installed:
            print(inf + program + " is already installed")
            return True
        else:
            print(err + program + " is not installed, will try to install via apt.")
            notInstalled = True
            cache[program].mark_install()
            return False
    except:
        print(err + "App is probably not availible in the apt package manager.\nInstall manually")


def appsInstall():
    global cache
    global prompt
    print(inf + "Try to install missing software via the apt package manager?\n" + inf + "Default is Yes\n    [1] Yes\n    [2] No")
    inp = input(prompt)
    if inp == "1" or inp == "":
        try:
            print(inf + "Trying to install via apt")
            cache.commit()
        except:
            print(err + "Failed to install packages")
            print(err + "Check internet connection/update the apt cache")
    elif inp == "2":
        print(inf + "Will not try to install packages, install them manually.")

def install():
    global cache
    global notInstalled
    print(inf + "Checking if needed apps are installed.")
    print(inf + "Give me a minute")
    try:
        cache.update()
        print(rew + suc + "Opening apt cache")
        cache.open()
        print(rew + suc + "Checking apps")
    except:
        print(err + "You need to run this script with sudo to see if apps are installed/install them automatically")
        exit()
    if not isInstalled("nmap"):
        notInstalled = True
    if not isInstalled("neofetch"):
        notInstalled = True
    if not isInstalled("htop"):
        notInstalled = True
    # if not isInstalled("i3-gaps"):
    #     notInstalled = True
    if notInstalled:
        appsInstall()

def movelib():
    global color
    global loud
    global home
    lib = "lib/"

#VIBECHECK
    text=" vibeCheck"
    dir = "/usr/bin"
    file = "vibeCheck"
    print(rew + tsk + "Copying" + text)
    dir = checkdir(dir)
    checkfile(dir, file)
    copy(lib + "vibeCheck/" + file, dir + file)
    print(rew + suc + "Implemented" + text)
    if loud:
        print(inf + "Copied it to " + dir + file)
    try:
        pass
    except:
        print(rew + err + "Could not implement" + text)

#count
    text=" count"
    dir = "/usr/bin"
    file = "count"
    print(rew + tsk + "Copying" + text)
    dir = checkdir(dir)
    checkfile(dir, file)
    copy(lib + "count/" + file, dir + file)
    print(rew + suc + "Implemented" + text)
    if loud:
        print(inf + "Copied it to " + dir + file)
    try:
        pass
    except:
        print(rew + err + "Could not implement" + text)

#repeat
    text=" repeat"
    dir = "/usr/bin"
    file = "repeat"
    print(rew + tsk + "Copying" + text)
    dir = checkdir(dir)
    checkfile(dir, file)
    copy(lib + "repeat/" + file, dir + file)
    print(rew + suc + "Implemented" + text)
    if loud:
        print(inf + "Copied it to " + dir + file)
    try:
        pass
    except:
        print(rew + err + "Could not implement" + text)

#w
    text=" w"
    dir = "/usr/bin"
    file = "w"
    print(rew + tsk + "Copying" + text)
    dir = checkdir(dir)
    checkfile(dir, file)
    copy(lib + "w/" + file, dir + file)
    print(rew + suc + "Implemented" + text)
    if loud:
        print(inf + "Copied it to " + dir + file)
    try:
        pass
    except:
        print(rew + err + "Could not implement" + text)

#DOTFILE
    text=" bashrc with aliases"
    dir = home
    file = ".bashrc"
    print(tsk + "Copying" + text)
    dir = checkdir(dir)
    checkfile(dir, file)
    copy(lib + "dotfiles/" + file, dir + file)
    print(rew + suc + "Implemented" + text)
    if loud:
        print(inf + "Copied it to " + dir + file)
        print(inf + "Restart the bash session with '$ bash' to use")
    try:
        pass
    except:
        print(rew + err + "Could not implement" + text)

#FOLDER
    # text=" folder"
    # dir = home
    # file = "folder/"
    # print(tsk + "Copying" + text)
    # dir = checkdir(dir)
    # checkfile(dir, file)
    # copytree(lib + "folder/" + file, dir + file)
    # print(rew + suc + "Implemented" + text)
    # if loud:
    #     print(inf + "Copied it to " + dir + file)
    # try:
    #     pass
    # except:
    #     print(rew + err + "Could not implement" + text)



def main():
    global color
    global loud
    global prompt
    global home

    art()

    if (int(python_version().split(".")[0]) <= 3) and (int(python_version().split(".")[1]) < 7):
        print(inf + "Calculating")
        for i in range(100):
            print(rew + inf + "At " + str(i) + "%")
            sleep(1)
        print(rew + err + "Python version is too old.")
        exit()

    print(inf + "Will automatically try to make backups")
    users = [ f.name for f in scandir("/home/") if f.is_dir() ]
    users.append("root")
    inp = 0
    o = 0
    while inp > o or inp < 1:
        print("Which of the following home directories do you want to install in?")
        o = 0
        for user in users:
            o += 1
            print("    [" + str(o) + "] " + user)
        inp = input(prompt)
        try:
            inp = int(inp)
        except:
            print(err + "Only print a number. eg. '" + prompt + "1'")
            inp = 0

    if users[inp-1] == "root":
        home = checkdir("/root/")
    else:
        home = checkdir("/home/" + users[inp-1])
    print(inf + "Home folder set to: " + home)


    print("Do you want the install script to be extra verbose?\n(y/N)\n" + inf + "Default is No")
    inp = input(prompt)
    if (inp == "Yes") or (inp == "yes"):
        loud = True
    else:
        if len(inp) == 1 and inp == "y" or inp == "Y":
            loud = True
        else:
            loud = False

    print("Do you want to check if needed apps are installed,\nor install them automatically? (needs sudo)\n(Y/n)\n" + inf + "Default is Yes")
    inp = input(prompt)
    if (inp == "no") or (inp == "No"):
        wantInstall = False
    else:
        if len(inp) == 1 and inp == "n" or inp == "N":
            wantInstall = False
        else:
            wantInstall = True
    time=3
    print(inf + "Installation starts in " + str(time) + " seconds ...")
    i = time-1
    while i > 0:
        if i == 1:
            sleep(1)
            print(rew + inf + "Installation starts in " + str(i) + " second ...")
            sleep(1)
        else:
            sleep(1)
            print(rew + inf + "Installation starts in " + str(i) + " seconds ...")
        i -= 1

    if wantInstall:
        install()
    #movelib()
    print()
    print(inf + "Remember to set new password on the machine with 'passwd'")
    print(inf + "Relay network connection back to local machine with 'sshuttle'")


main()
