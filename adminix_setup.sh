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

# Check for MUST have libs

# Install brew for Mac
if $MAC
then
    brew help 2>&1 >/dev/null
    IS_BREW=$?
    if [ $IS_BREW -ne 0 ]
    then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
fi

# Update the apt package index
if $AMD || $ARM
then
    sudo apt-get update
fi

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
	sudo apt-get install vim-runtime
	sudo apt-get install vim
    fi
fi

# Check for cURL 
curl --version 2>&1 >/dev/null
IS_CURL=$?
if [ $IS_CURL -ne 0 ]
then
    if $MAC
    then
	brew install curl
    elif $AMD
    then
	sudo apt-get install curl
    elif $ARM
    then
	sudo apt-get install php5-curl
    fi
fi

# Check for gcc
gcc --version 2>&1 >/dev/null
IS_GCC=$?
if [ $IS_GCC -ne 0 ]
then
    if $MAC
    then
	brew install gcc
    elif $AMD
    then
	sudo apt-get install build-essential
    elif $ARM
    then
	git clone https://bitbucket.org/sol_prog/raspberry-pi-gcc-binary.git
	cd raspberry-pi-gcc-binary
	tar xf gcc-8.1.0.tar.bz2
	sudo mv gcc-8.1.0 /usr/local
	export PATH=/usr/local/gcc-8.1.0/bin:$PATH
	cd ..
	cd rm -rf raspberry-pi-gcc-binary
    fi
fi

# DOCKER check

# Uninstall older versions of Docker
sudo apt-get remove docker docker-engine docker.io

docker --version 2>&1 >/dev/null
IS_DOCKER=$?
if [ $IS_DOCKER -ne 0 ]
then
    if $MAC
    then
	brew install docker-ce
    elif $AMD
    then
	sudo apt-get install \
	     apt-transport-https \
	     ca-certificates \
	     curl \
	     software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
	     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
	sudo apt-get install docker-ce
    elif $ARM
    then
        sudo apt-get install \
	     apt-transport-https \
	     ca-certificates \
	     curl \
	     software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
	     "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
	sudo apt-get install docker-ce
    fi
fi


# Ruby Install
ruby --version 2>&1 >/dev/null
IS_RUBY=$?
if [ $IS_RUBY -ne 0 ]
then
    if $MAC
    then
	brew install ruby
    elif $AMD
    then
	sudo apt-get install ruby-full
    elif $ARM
    then
	sudo apt-get install rubygems
    fi
fi

# Install Adminix Gem
gem install adminix

# Add user to sudo group
# sudo adduser <username> sudo

# Install Nginx
if ! which nginx > /dev/null 2>&1
then
    if $MAC
    then
	brew install nginx
    elif $AMD
    then
	sudo apt-get install nginx
    elif $ARM
    then
	sudo apt-get install nginx
    fi
fi
