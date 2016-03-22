#!/bin/bash
#
# Mac OS X Automated Installer Script
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
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
#  - My basic setup for OS X Lion
#	http://www.darkoperator.com/blog/2011/7/24/my-basic-setup-on-osx-lion.html
#  - Installing Metasploit Framework on OS X El Capitan
#	http://hackerforhire.com.au/installing-metasploit-framework-on-os-x-el-capitan/
#  - How to fix permission issues on Homebrew in OS X El Capitan?
#	http://digitizor.com/fix-homebrew-permissions-osx-el-capitan/
#  - Use Homebrew zsh Instead of the OSX Default
#	http://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
#

echo "******************************************************"

# Change to the current user's home directory, a few of the commands require it and nothing prohibits it...
echo "Switching to your home directory..."
cd ~

echo "Ensuring permissions are set correctly on /usr/local and sub-directories..."
sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local

# You need to have installed Xcode via the AppStore for this script to run
echo "Xcode Command Line Tools is required for this setup script."

# Check & Prompt for Install if needed - See Stack Exchange Reference above
if xcode-select --install 2>&1 | grep installed; then
  echo "Xcode Command Line Tools already installed, proceeding with setup...";
else
  echo "Xcode Command Line Tools is not currently installed."
  echo "Please accept the confirmation when prompted to complete the install to continue...";
fi

# TODO - NEED TO REVIEW IF THIS IS BEST ROUTE FOR KEY MANAGEMENT
echo "Copying Secrets File & setting permissions...."
cp .api_keys ../.api_keys
chmod 600 ~/.api_keys

echo "******************************************************"
echo

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing Homebrew Cask"
brew install Caskroom/cask/brew-cask

# currently only really using it for the beta of iTerm2 v3
echo "Tapping versions Caskroom for installing alternate versions of Casks..."
brew tap caskroom/versions

echo "Tapping php Caskroom for developer tools..."
brew tap homebrew/php

echo "Running brew doctor - halt the script & investigate if you see any errors."
brew doctor

echo "Updating app lists"
brew update
brew cask update
brew upgrade -all

echo "Updating bash to latest version & installing related utilities..."
brew install bash
brew install bash-completion
brew cask install Caskroom/cask/go2shell

echo "Installing iTerm2 v3 (beta) & tmux..."
brew cask install Caskroom/versions/iterm2-beta
brew install tmux							# tmux requires openssl & libevent which will be installed also

# Install git & close the config repo - note will need to enter credentials for the initial clone

echo "Installing git & git utility apps..."
brew install git
brew install hub
alias git=hub								# Recommended per https://hub.github.com/
brew install git-flow
# brew install bash-git-prompt 						# Disabling until configuration can be customized
brew cask install Caskroom/cask/github-desktop
brew cask install Caskroom/cask/gitkraken
brew cask install Caskroom/cask/sourcetree

# Configure Git's Global Settings in my Home Directory
echo "Copying global git ignore& config files to home directory..."
cp mac-setup/global.gitignore ~/.gitignore
cp mac-setup/global.gitconfig ~/.gitconfig

# Install Cloud Storage Clients to grab shared configurations before proceeding

echo "Installing and configuring Google Drive..."
brew cask install Caskroom/cask/google-drive

# Can we configure drive from the CLI? We can start it....

echo "Installing Amazon Cloud Drive, may prompt for password..."
# brew cask install Caskroom/cask/amazon-cloud-drive

# Signed up for free trial for unlimited storage, need to figure out strategy before enabling fully

# Can we configure drive from the CLI? We can start it....

echo "Installing Box Sync..."
brew cask install Caskroom/cask/box-sync

# Can we configure drive from the CLI? We can start it....

echo "Installing Dropbox..."
brew cask install Caskroom/cask/dropbox

# Can we configure drive from the CLI? We can start it....

echo "Installing Transmission..."
brew cask install Caskroom/cask/transmission

# Can we configure drive from the CLI? We can start it....


# Startup Storage Client of your choice and sync to copy down config files & scripts
#
# Launch sync utility and provide credentials & kick off sync 
#
# Execute script to symlink cloud storage directory to HOME when sync is complete
#

# Install Common Libraries needed for development and for dependencies in other apps & build scripts
brew install libyaml

# Install common applications via Homebrew
brew install ack 
brew install wget
brew install htop
brew install archey
brew install autoconf
brew install pkg-config
brew install colordiff

# Install top-utilities
brew install iftop dnstop 

# Programming Languages & Related Utilities

# Python...
echo "Installing pip, pre-req for virtualenv, enter your password if promptedv..."
sudo easy_install pip

echo "Installing virtualenv & virtualenvwrapper..."
sudo -H pip install virtualenv --upgrade
sudo -H pip install virtualenvwrapper --upgrade --ignore-installed six
source /usr/local/bin/virtualenvwrapper_lazy.sh

# JavaScript...
echo "Installing Node.js & npm..."
brew install node npm
export NODE_PATH="/usr/local/lib/node_modules"

# Install npm packages
npm install -g grunt
npm install -g gulp

# Install Gulp-App
brew cask install Caskroom/cask/gulp

# Ruby
echo "Updating, Installing and configuring all ruby versions & rbenv..."
brew install ruby-build 
brew install rbenv
rbenv init

# Go
echo "Installing and configuring Go language..."
brew install go
mkdir $HOME/work
export GOPATH=$HOME/work
export PATH=$LOCALBIN:$PATH:$GOPATH/bin

# Java
# TODO - Verify if JENV can be installed before the latest java cask
# TODO - Verify installation proceedures for alternate versions of Java (if needed)
echo "Installing and configuring all Java versions & jenv..."
brew install jenv
brew cask install Caskroom/cask/java
brew install jvmtop

# TODO - re-work path logic using jenv
export PATH=$JAVA_HOME/bin:$PATH


# PHP ????


# Encryption Utilities and Libraries
echo "Installing SSH / SSL / Encryption Utilities..."
brew install autossh
brew install ssh-copy-id
brew cask install Caskroom/cask/ssh-tunnel-manager
brew install openssl
brew install keybase

echo "Installing GPG & associated libraries and utilities..."
brew cask install Caskroom/cask/gpgtools 					# Requires Password but also installs all gpg apps

# Holding off on these until additional research can be completed.
# TODO - Investigate Massively Parallel SSH : https://github.com/ndenev/mpssh
# brew install mpssh
# TODO - Investigate Advanced SSH : https://github.com/moul/advanced-ssh-config
# brew install assh


# Install Test Automation Tools

echo "Installing Selenium and associated webdrivers..."
brew install selenium-server-standalone
brew install js-test-driver


# Install Browsers, Communications Clients and DevOps Toolkits

echo "Installing Chrome Browser & Related Apps / Extensions..."
brew cask install Caskroom/cask/google-chrome
brew cask install Caskroom/cask/chrome-remote-desktop-host	# NOTE: Will be prompted for Admin PWD & Reboot required
brew install chromedriver					# Launcing requires either 
	# Launch at Startup : ln -sfv /usr/local/opt/chromedriver/*.plist ~/Library/LaunchAgents
	# Launch on demand : launchctl load ~/Library/LaunchAgents/homebrew.mxcl.chromedriver.plist
brew cask install Caskroom/cask/chrome-devtools			# Run Chrome DevTools as a stand-alone app
brew install chrome-cli						# Cool CLI Automation for Chrome, see https://github.com/prasmussen/chrome-cli

echo "Installing Firefox Browser and Related Apps / Extensions..."
brew cask install Caskroom/cask/firefox

echo "Installing Remote Access Utilities..."
brew cask install Caskroom/cask/teamviewer

echo "Installing Security Utilities..."
brew cask install Caskroom/cask/integrity
brew cask install Caskroom/cask/scrutiny
# brew cask install Caskroom/cask/reactivity			# Not currently available via Homebrew or eask
brew install dependency-check					# OWASP Dependency Checker Utility
brew cask install Caskroom/cask/1password

echo "Installing Mac OS X System Utilities..."
brew cask install Caskroom/cask/onyx
brew cask install Caskroom/cask/maintenance
brew cask install Caskroom/cask/deeper
brew cask install Caskroom/cask/the-unarchiver
brew cask install Caskroom/cask/daisydisk
brew cask install Caskroom/cask/divvy

echo "Installing Messaging Apps"
brew cask install Caskroom/cask/slack
brew cask install Caskroom/cask/hipchat 
brew cask install Caskroom/cask/skype

echo "Installing Document Readers"
brew cask install Caskroom/cask/kindle
brew cask install Caskroom/cask/adobe-reader
brew cask install Caskroom/cask/dash 
brew cask install Caskroom/cask/calibre

echo "Installing Image Processing Libraries & Utilies..."
brew cask install Caskroom/cask/imageoptim

# Cloud / Virtualization / Container Stacks & Provisioning System

echo "Installing VirtualBox..."
brew cask install Caskroom/cask/virtualbox
brew cask install Caskroom/cask/virtualbox-extension-pack

echo "Installing VMWare Fusion 8..."
brew cask install Caskroom/cask/vmware-fusion

echo "Installing Docker & Supporting Utilities..."
# Docker + Kitematic + Boot2Docker ???

# Vagrant & HashiCorp Apps
# TODO - See if we can automate the installation of the Fusion Provider & associated license
echo "Installing Vagrant and other HashiCorp applications /  utilities..."
brew install vagrant

brew install vassh						# Vagrant Host-Guest SSH Command Wrapper/Proxy/Forwarder
								#   https://github.com/x-team/vassh

# Other HashiCorp Stuff ?

# Otto

# Packer

# Install all of the available AWS CLI Tools

echo "Installing all available Amazon Web Services CLI Utilities..."
brew install aws-apigateway-importer aws-as aws-cfn-tools aws-cloudsearch \
        aws-elasticache aws-elasticbeanstalk aws-keychain aws-mon aws-shell \
        aws-sns-cli awscli awsebcli


# Install Local DataStores
#
# Don't plan on using them for development, per-se, but want to have clients
# installed and have the local server setup to be startable since some of the
# auto-discovery systems in Zend and other Clients run into issues when the 
# client and server are on different hosts.
#
# Redis, Memcache, MySQL (or MariaDB, Percona)?

# Make sure to add the various top-utils that don't conflict
brew install innotop pg_top memcache-top

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




# Install mackup and restore Application Settings
echo "Installing mackup Application Settings Backup Program..."
brew install mackup

echo "Restoring Application Settings from last mackup backup stored in Dropbox..."
mackup restore

# Cleanup files downloaded for installations....
brew cleanup
brew cask cleanup

# Apps which cannot be installed via Homebrew - needs AppStore installation
# Apple Apps
# - Final Cut Pro 
# - Garage
# Buffer by Buffer
# Proxy by WebSecurify
# WebReaver by WebSecurify
# Voila by Global Delight Technologies
# Sunrise Calendar by Microsoft
# SmartConverter by Systemic Pty Ltd / Shedworx
# Sitemap Plus by Chris Brown
# Screeny by Daeo Corp. Software
# IP Scanner Pro by 10base-t Interactive
