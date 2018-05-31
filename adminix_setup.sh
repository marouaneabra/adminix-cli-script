#! /bin/bash

# Date: 5/31/18
# This sh script program sets up Adminix in your local machine

# Initial flag settings for OS check
# Mac
MAC=false
# amd64
AMD=false
# armhf
ARM=false

# Initial check for OS type

# Check for Mac
if [[ "$OSTYPE" == "darwin"* ]]
then
    MAC=true
fi

# Check for amd64
MACHINE=$(uname -m)
if [[ $MACHINE == "x86_64" ]]
then
    AMD=true
fi

# Check for armhf
# This will output the primary architecture of the machine
# Returns either "armhf" running 32-bit ARM Debian or Ubuntu
# or "arm64" on a machine running 64-bit ARM
ARCH=$(dpkg --print-architecture)
if [[ $ARCH == "armhf" ]] || [[ $ARCH == "arm64" ]]
then
    ARM=true
fi

#------------------------------------------------------------------------#

# Check for must have libs

# Check if git is installed
git --version 2>&1 >/dev/null
IS_GIT=$?
if [ $IS_GIT -ne 0 ]
then
    if $MAC
    then
	brew install git
    elif $AMD
    then
	sudo apt install git-all
    elif $ARM
    then
	sudo apt-get update
	sudo apt-get install git
    fi
fi

# Check for vim
vim --version 2>&1 >/dev/null
IS_VIM=$?
if [ $IS_VIM -ne 0 ]
then
    if $MAC
    then
	brew install vim
    elif $AMD
    then
	sudo apt-get install vim
    elif $ARM
    then
	sudo apt-get update
	sudo apt-get install vim-runtime
	sudo apt-get install vim
    fi
fi

INFO=$(cat /etc/os-release)

if [[ $INFO == *"Raspbian"* ]] || [[ $INFO == *"Debian"* ]]
then
    echo "It's a Raspberry"
else
    echo "It's not a Raspberry"
fi
echo "$INFO"
