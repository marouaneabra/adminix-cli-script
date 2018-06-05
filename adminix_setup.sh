#! /bin/bash

# Date: 5/31/18
# This sh script program sets up Adminix in your local machine

# Installing MUST have libs

if [ -x "$(command -v apt-get)" ]; then
    echo "..."
    echo "Installing required libraries..."
    apt-get update
    apt-get install -y ruby-full git-core git curl vim tar zlib2g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nginx

elif [ -x "$(command -v brew)" ]; then
    echo "..."
    echo "Installing required libraries..."
    brew install ruby git curl vim gcc nginx
fi
gem install bundler

# Installing the Adminix Gem
gem install adminix

# Adding user to sudo group
# sudo adduser <username> sudo

     
# DOCKER check

# Uninstall older versions of Docker
sudo apt-get remove docker docker-engine docker.io

ARCH=$(dpkg --print-architecture)
MACHINE=$(uname -m)
if [[ $MACHINE == "x86_64" ]]; then
    echo "..."
    echo "Installing Docker..."
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
    sudo apt-get update
    sudo apt-get install docker-ce
  
elif [ -x "$(command -v brew)" ]; then
    echo "..."
    echo "Installing Docker..."
    brew install docker-ce
    
    
# Check for armhf
# This will output the primary architecture of the machine
# Returns either "armhf" running 32-bit ARM Debian or Ubuntu
# or "arm64" on a machine running 64-bit ARM
elif [[ $ARCH == "armhf" ]] || [[ $ARCH == "arm64" ]]; then
     echo "..."
     echo "Installing Docker..."
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
     sudo apt-get update
     sudo apt-get install docker-c
fi

