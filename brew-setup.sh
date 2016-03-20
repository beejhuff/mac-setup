#!/bin/bash
#
# References : 
#  - My macosx app setup list using brew and cask
#       http://javapapo.blogspot.com/2015/08/my-macosx-app-setup-list-using-brew-and.html
#  - Best Way to check if the Command Line Tools are installed?
#       http://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed
#  - How to Write Go Code 
#       https://golang.org/doc/code.html#GOPATH
#  - How to Setup Your Mac to Develop News Applications Like We Do
#       http://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html
#  - Set your Github API Token If you hit a ”GitHub API rate limit exceeded” :
#       https://gist.github.com/christopheranderton/8644743    
#  - Why I am not able to see the JAVA_HOME path on my MAC OS X 10.11? :
#       http://stackoverflow.com/questions/33046697/why-i-am-not-able-to-see-the-java-home-path-on-my-mac-os-x-10-11
#  - VirtualEnv & VirtualEnvWrapper problems installing b/c of SIP : 
#       https://github.com/pypa/pip/issues/3165
#  - On OS X El Capitan I can not upgrade a python package dependent on the six compatibility utilities NOR can I remove six :
#       http://stackoverflow.com/questions/33185147/can-not-uninstall-six-on-os-x10-11
#  - Setting Up the Amazon EC2 Command Line Interface Tools on Linux/Unix and Mac OS X
#       http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html
#  - How to setup OS X EL Capitan Environment Variables (Create, Read, Update, Delete)
#       http://codewithintent.com/how-to-setup-os-x-el-capitan-environment-variables-create-read-update-delete/
#  - Eight Terminal Utilities Every OS X Command Line User Should Know
#       http://www.mitchchn.me/2014/os-x-terminal/
#
echo "******************************************************"

# You need to have installed Xcode via the AppStore for this script to run
echo "Xcode Command Line Tools is required for this setup script."

# Check & Prompt for Install if needed - See Stack Exchange Reference above
if xcode-select --install 2>&1 | grep installed; then
  echo "Xcode Command Line Tools already installed, proceeding with setup...";
else
  echo "Xcode Command Line Tools is not currently installed."
  echo "Please accept the confirmation when prompted to complete the install to continue...";
fi

echo "Copying Secrets File & setting permissions...."
cp .not_public ../.not_public
chmod 600 ~/.not_public

echo "******************************************************"
echo

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing Homebrew Cask"
brew install caskroom/cask/brew-cask

# currently only really using it for the beta of iTerm2 v3
echo "Enabling alternate version tap for Cask"
brew tap caskroom/versions

echo "Tapping php Caskroom for developer tools..."
brew tap homebrew/php

echo "Installing iTerm2 v3 (beta)..."
brew cask install Caskroom/versions/iterm2-beta
brew install tmux

echo "Running brew doctor - halt the script & investigate if you see any errors."
brew doctor

echo "Updating app lists"
brew update
brew cask update
brew upgrade -all


echo "Updating bash to latest v4..."
brew install bash
brew install bash-completion

# Install git & close the config repo - note will need to enter credentials for the initial clone
brew install git
brew install git-flow
brew cask install github-desktop
brew cask install gitkraken
brew install bash-git-prompt


# Install Cloud Storage Clients to grab shared configurations before proceeding

echo "Installing and configuring Google Drive..."
brew cask install Caskroom/cask/google-drive

# Can we configure drive from the CLI? We can start it....

echo "Installing Amazon Cloud Drive..."
brew cask install Caskroom/cask/amazon-cloud-drive

# Can we configure drive from the CLI? We can start it....

echo "Installing Box Synce..."
brew cask install Caskroom/cask/box-sync

# Can we configure drive from the CLI? We can start it....

echo "Installing Dropbox..."
brew cask install Caskroom/cask/dropbox

# Can we configure drive from the CLI? We can start it....

echo "Installing Transmission..."
brew cask install Caskroom/cask/transmission

# Can we configure drive from the CLI? We can start it....


# Install Virtualenv
echo "Installing pip, pre-req for virtualenv, enter your password if promptedv..."
sudo easy_install pip

echo "Installing virtualenv & virtualenvwrapper..." 
sudo -H pip install virtualenv --upgrade
sudo -H pip install virtualenvwrapper --upgrade --ignore-installed six
source /usr/local/bin/virtualenvwrapper_lazy.sh

echo "Installing Node.js & npm..."
brew install node npm
export NODE_PATH="/usr/local/lib/node_modules"



# Startup Storage Client of your choice and sync to copy down config files & scripts
#
# Launch sync utility and provide credentials & kick off sync 
#
# Execute script to symlink cloud storage directory to HOME when sync is complete
#


# Install common applications via Homebrew
brew install ack 
brew install autojump 
brew install automake 
brew install colordiff 
brew install curl 
brew install wget
brew install hub 
brew install icoutils 
brew install ossp-uuid 
brew install qt
brew install coreutils 
brew install readline 
brew install libxml2 
brew install htop 
brew install archie

echo "Updating, Installing and configuring all ruby versions & rbenv..."
brew install 


echo "Installing SSH / SSL / Encryption Utilities..."
brew install keybase
brew install ssh-copy-id
brew install openssl 



# Setup Programming Languages for Development

echo "Installing ruby & rbenv..."
brew install rbenv ruby-build


echo "Installing and configuring Go language..."
brew install go
mkdir $HOME/work

echo "Installing and configuring all Java versions & jenv..."
brew cask install Caskroom/cask/java

# re-work path logic using jenv
export PATH=$JAVA_HOME/bin:$PATH


# Install Test Automation Tools

echo "Installing Selenium and associated webdrivers..."
brew install selenium-server-standalone
brew install js-test-driver


# Install Browsers, Communications Clients and DevOps Toolkits

echo "Installing Chrome Browser & Related Apps / Extensions"
brew cask install Caskroom/cask/google-chrome
brew cask install Caskroom/cask/chrome-remote-desktop-host
brew install chromedriver
brew cask install Caskroom/cask/chrome-devtools			# Run Chrome DevTools as a stand-alone app
brew install chrome-cli						# Cool CLI Automation for Chrome, see https://github.com/prasmussen/chrome-cli

echo "Installing Messaging Apps"
brew cask install Caskroom/cask/slack
brew cask install Caskroom/cask/hipchat 
brew cask install Caskroom/cask/skype

echo "Installing Document Readers"
brew cask install Caskroom/cask/kindle
brew cask install Caskroom/cask/adobe-reader
brew cask install Caskroom/cask/dash 

echo "Installing Image Processing Libraries & Utilies..."
brew install zimg imagemagick
brew cask install imageoptim

# Install all of the available AWS CLI Tools

echo "Installing all available Amazon Web Services CLI Utilities..."
brew options aws-apigateway-importer aws-as aws-cfn-tools aws-cloudsearch \
        aws-elasticache aws-elasticbeanstalk aws-keychain aws-mon aws-shell \
        aws-sns-cli awscli awsebcli



# Virtualization / Container Stacks & Provisioning System

echo "Installing Additional DevOps Tools via Casks..."
brew cask install Caskroom/cask/virtualbox
brew cask install Caskroom/cask/virtualbox-extension-pack

# Vagrant

# Other HashiCorp Stuff ?

# Docker

# Otto

# Packer


# Install Local DataStores
#
# Don't plan on using them for development, per-se, but want to have clients
# installed and have the local server setup to be startable since some of the
# auto-discovery systems in Zend and other Clients run into issues when the 
# client and server are on different hosts.
#
# Redis, Memcache, MySQL (or MariaDB, Percona)?


# Install UI Enhancements and Client Apps

echo "Installing Client Apps and configuring UI Enhancements..."
brew cask install Caskroom/cask/bartender


# Installing vim Enhancements & Light-Weight IDE Atom


# Install Zend Stack : Zend Server, Z-Ray, Zend Studio
# http://justinhileman.info/article/reinstalling-php-on-mac-os-x/



# Install Video Clients

echo "Installing Local and Online Video Clients..."
brew cask install 4k-video-downloader				# YouTube video downloader
brew cask install Caskroom/vlc/vlc				# Video Lan Client



