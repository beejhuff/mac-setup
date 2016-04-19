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
#  - Immutable Infrastructure with AWS and Ansible – Part 1 – Setup
#	http://vcdxpert.com/?p=105

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
cp .api_keys ~/.api_keys
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

# Configure Shell Integration for iTerm2
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash


# Install git & clone the config repo - note will need to enter credentials for the initial clone
# ASSUMING we want to use this method of managing config vs. mackup method
# OR we come up with a way to merge the two methods to make everything managed cleanly


echo "Installing git & git utility apps..."
brew install git git-lfs
brew install hub
alias git=hub								# Recommended per https://hub.github.com/
brew install git-flow
# brew install bash-git-prompt 						# Disabling until configuration can be customized
brew cask install Caskroom/cask/github-desktop
brew cask install Caskroom/cask/sourcetree
brew cask install gitup

# Configure Git's Global Settings in my Home Directory
echo "Copying global git ignore& config files to home directory..."
cp mac-setup/global.gitignore ~/.gitignore
cp mac-setup/global.gitconfig ~/.gitconfig

# Install Cloud Storage Clients to grab shared configurations before proceeding

echo "Installing and configuring Google Drive..."
brew cask install Caskroom/cask/google-drive google-photos-backup/google-photos-backup

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

# Install and Configure CloudUp
echo "Installing CloudUp Storage Client..."
brew cask install Caskroom/cask/cloudup

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
brew cask install etrecheck
brew install automake autoconf curl pcre re2c mhash libtool icu4c \
	gettext jpeg libxml2 mcrypt gmp libevent
brew link icu4c
brew install timedog


# Install Alternative Shells
echo "Installing zsh (Z Shell) and supporting utilities..."
brew install zsh zsh-autosuggestions zsh-completions zsh-history-substring-search \
	zsh-lovers zsh-syntax-highlighting zshdb zssh zsync zurl

# Install top-utilities
brew install iftop dnstop 

# Install DNS Utilities
brew install djbdns dnsmap dnstracer launchdns dnstwist validns

# Development Languages, Environments, & Related Utilities

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


# Slack Development Utilities, Toolkits, Bot SDKs
brew install slackcat



#
# PHP - NOTE - If we're going to run NGINX / Zend Server on VM's or Docker Containers
#
#  The the actual requirements for the local system in terms of PHP and post-config required
#  can be relatively light. I'm currently focusing on essential development tools, utilities,
#  and core language runtimes needed for my IDE & Editors to function properly
#  I am SPECIFICALLY not installing NGINX or Apache via homebrew but rather just the PHP 
#  languages and if needed the php modules.  Will test to verify if I can remove any of 
#  stuff I'm installing once I have Docker and VM's up and running.
# 

echo "Installing PHP Development Language and Supporting Tools & Utilities..."
brew cask install Caskroom/cask/phpstorm

# Fix File System Case-Sensitivity Warning on PHPStorm Startup
cp work/mac-setup/idea.properties  ~/Library/Preferences/PhpStorm2016.1/

# Install local versions of PHP needed for development & testing
# Some of the following cause issues with my customized .bash_profile - need to troubleshoot

brew install phpbrew --ignore-dependencies
phpbrew init
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

phpbrew lookup-prefix homebrew

phpbrew update

phpbrew -d install -j --test 5.5.0 +all
phpbrew -d ext install -j +all

brew install phpbrew behat box brew-php-switcher codeception composer pdepend \
	php-code-sniffer php-cs-fixer php-version phpcpd phpbrew phpdocumentor \
	phpdox phpenv phplint phpmd phpmetrics phpsh phpunit phpunit-skeleton-generator \
	pickle puli sqlformat virtphp phpab mondrian pharcc phan \
        php-plantumlwriter php-session-nginx-module climb envoy igbinary


# Encryption Utilities and Libraries
echo "Installing SSH / SSL / Encryption Utilities..."
brew install autossh ssh-copy-id openssl keybase 
brew cask install Caskroom/cask/ssh-tunnel-manager

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
brew cask install Caskroom/cask/google-chrome Caskroom/cask/google-hangouts Caskroom/cask/google-adwords-editor


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
brew cask install Caskroom/cask/malwarebytes-anti-malware Caskroom/cask/virustotaluploader Caskroom/cask/clamxav
brew install exploitdb flawfinder letsencrypt nmap ncrack wirouter_keyrec wireshark wifi-password zzuf

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
brew cask install Caskroom/cask/kindlepreviewer

echo "Installing Image Processing Libraries & Utilies..."
brew cask install Caskroom/cask/imageoptim 
brew install djvulibre djvu2pdf djview4
brew cask install Caskroom/cask/invisionsync
brew cask install Caskroom/cask/xnconvert Caskroom/cask/xnviewmp Caskroom/cask/xnconvert

# Cloud / Virtualization / Container Stacks & Provisioning System

echo "Installing VirtualBox..."
brew cask install Caskroom/cask/virtualbox
brew cask install Caskroom/cask/virtualbox-extension-pack

echo "Installing VMWare Fusion 8..."
brew cask install Caskroom/cask/vmware-fusion

echo "Installing Docker & Supporting Utilities..."
# Docker + Kitematic + Boot2Docker ???
echo "Installing Docker & Container Managment Utilities..."
brew cask install Caskroom/cask/dockertoolbox
brew install docker-cloud docker-gen docker-swarm dockviz 
brew install docker-completion docker-compose-completion docker-machine-completion

# Vagrant & HashiCorp Apps
echo "Installing Vagrant and other HashiCorp applications /  utilities..."
brew install vagrant packer serf consul consul-template vault terraform terraform-inventory vault nomad otto
brew install vassh						# Vagrant Host-Guest SSH Command Wrapper/Proxy/Forwarder
								#   https://github.com/x-team/vassh
# Install Vagrant VMWare Fusion Provider & Activate  License key from Google Drive Archive
GOOGLE_DRIVE=~/Google\ Drive
vagrant plugin install vagrant-vmware-fusion
vagrant plugin license vagrant-vmware-fusion "$GOOGLE_DRIVE/Software/Vagrant/license.lic"

# Ansible Utilities
echo "Installing Ansible & Ansible CMDB Utilities..."
brew install ansible ansible-cmdb

echo "Installing the yaegashi.blockinfile Ansible role from Ansible galaxy..."
sudo ansible-galaxy install yaegashi.blockinfile

# Install all of the available AWS CLI Tools
echo "Installing all available Amazon Web Services CLI Utilities..."
brew install awscli ec2-ami-tools  ec2-api-tools aws-as aws-cfn-tools \
        aws-elasticache aws-elasticbeanstalk aws-keychain aws-mon aws-shell \
        aws-sns-cli awsebcli rds-command-line-tools elb-tools s3cmd \
	aws-cloudsearch aws-sns-cli amazon-ecs-cli aws-apigateway-importer \ 
	s3sync auto-scaling
brew cask install Caskroom/cask/elasticwolf

# Install Google Compute and Cloud SDK & Utilities
echo "Installing all available Google Compute Engine / Google Cloud Utilities..."
brew cask install Caskroom/cask/google-cloud-sdk Caskroom/cask/googleappengine 
brew install google-sql-tool


# Install Local DataStores
#
# Don't plan on using them for development, per-se, but want to have clients
# installed and have the local server setup to be startable since some of the
# auto-discovery systems in Zend and other Clients run into issues when the 
# client and server are on different hosts.
#
# Redis, Memcache, MySQL (or MariaDB, Percona)?
brew install redis memcached mariadb postgresql percona-toolkit

# Make sure to add the various top-utils that don't conflict
# brew install pg_top innotop		# These were generating errors
brew install memcache-top

echo "Installing MySQL & PostgreSQL Clients..."
brew cask install Caskroom/cask/sequel-pro Caskroom/cask/psequel Caskroom/cask/dbvisualizer

# Install UI Enhancements and Client Apps
echo "Installing Client Apps and configuring UI Enhancements..."

# Installing vim Enhancements
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.eim
brew cask install Caskroom/cask/vimr

# Installing Visual Studio for Mac OS X
brew cask install Caskroom/cask/visual-studio-code


# Install Zend Stack : Zend Server, Z-Ray, Zend Studio
# http://justinhileman.info/article/reinstalling-php-on-mac-os-x/
brew cask install Caskroom/cask/zend-studio

brew install anvil
brew cask install Caskroom/cask/rcenvironment

# Install Video Clients

echo "Installing Local and Online Video Clients..."
brew cask install 4k-video-downloader					# YouTube video downloader
brew cask install Caskroom/vlc/vlc					# Video Lan Client


echo "Install other stuff..."
brew cask install retro-virtual-machine virtual-ii virtualc64		# Emulate old platforms
brew install pipe-viewer 
brew cask install vimediamanager
brew cask install Caskroom/cask/vienna
brew cask install blueservice calcservice wordservice easyfind
brew cask install activity-audit

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
