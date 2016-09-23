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
#		http://www.darkoperator.com/blog/2011/7/24/my-basic-setup-on-osx-lion.html
#  - Installing Metasploit Framework on OS X El Capitan
#		http://hackerforhire.com.au/installing-metasploit-framework-on-os-x-el-capitan/
#  - How to fix permission issues on Homebrew in OS X El Capitan?
#		http://digitizor.com/fix-homebrew-permissions-osx-el-capitan/
#  - Use Homebrew zsh Instead of the OSX Default
#		http://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
#  - Immutable Infrastructure with AWS and Ansible – Part 1 – Setup
#		http://vcdxpert.com/?p=105
#  - Using the latest SSH from Homebrew on OSX
#   	https://coderwall.com/p/qdwcpg/using-the-latest-ssh-from-homebrew-on-osx

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
  echo "Please accept the confirmation when prompted to continue...";
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

echo "Running brew doctor - halt the script & investigate if you see any errors."
brew doctor

echo "Updating app lists"
brew update
brew cask update
brew upgrade -all

# Update bash & install all of the utilities for it to work nicely
# TODO: Refactor this into an initialization script that runs first and then calls the main setup script only AFTER bash has been updated
echo "Updating bash to latest version & installing related utilities..."
brew install bash

# Update /etc/shells to comment out the system default bash and add an entry to enable the latest version we just installed via homebrew
ed -s /etc/shells <<< $',s?/bin/bash?#/bin/bash?g\n,w'
sudo echo "#Add homebrew bash override as shell option" | sudo tee -a /etc/shells
sudo echo "/usr/local/bin/bash" | sudo tee -a /etc/shells

# TODO: Add support for git cloning and installing bash-it - https://github.com/Bash-it/bash-it
# TODO: bash-powerline: https://github.com/riobard/bash-powerline
# TODO: bashful: https://github.com/jmcantrell/bashful

brew install bash-completion 								# Shouldn't be necessary when bash-it is installed (included in bash-it)
brew cask install Caskroom/cask/go2shell			 		# Go2Shell - http://zipzapmac.com/go2shell

# Install and configure bashub client for archiving all bash commands in the cloud - https://bashhub.com/install
# See Also: https://github.com/rcaloras/bashhub-client
# See Also: https://github.com/rcaloras/bashhub-client/wiki/Security-and-Privacy
# TODO: Review configuration to determine if / which commands to exclude from logging
# TODO: Refactor using https://github.com/niieani/bash-oo-framework
# TODO: Refactor using https://github.com/bpkg/bpkg
# 
# TODO: add logic to close and restart terminal session for this to take affect
# curl -OL https://bashhub.com/setup && bash setup

# Install git & supporting utilities
echo "Installing git & git utility apps..."
brew install git 								# git
brew install git-lfs 								# Git extension for versioning large files
brew install git-standup 							# Git extension to generate reports for standup meetings
brew install github-markdown-toc 						# Easy TOC creation for GitHub README.md
brew install git-secret 							# Bash-tool to store the private data inside a git repo.
brew install git-secrets							# Prevents you from committing sensitive information to a git repo
brew install hub								# Add GitHub support to git on the command-line
alias git=hub									# Recommended per https://hub.github.com/
brew install git-flow								# Extensions to follow Vincent Driessen's branching model "gitflow"
# brew install bash-git-prompt 							# Disabling until configuration can be customized
brew cask install Caskroom/cask/github-desktop					# Github Desktop Client for Mac OS X
brew cask install Caskroom/cask/sourcetree					# Atlassian Git / Mercurial Client for Mac OS X
brew cask install gitup 							# GitUp Visual Git Branching and Repo Management Utility - http://gitup.io

# Configure Git's Global Settings in my Home Directory
echo "Copying global git ignore & config files to home directory..."
cp mac-setup/global.gitignore ~/.gitignore
cp mac-setup/global.gitconfig ~/.gitconfig

# Install & Configure Logitech Drivers and Utilities for associated peripherals in use
echo "Install latest Logitech Utilities, Drivers, and Options Configurators..."
brew cask install logitech-unifying
brew cask install logitech-control-center
brew cask install logitech-options

# Install and configure Encryption Utilities and Libraries
echo "Installing SSH / SSL / VPN Encryption Utilities..."
# brew install openssh --force 							# Commented out because in order to leave OS X functional a lot of additional configuration needs to be completed
# 										# TODO: https://coderwall.com/p/qdwcpg/using-the-latest-ssh-from-homebrew-on-osx
brew install autossh 								# Automatically restart SSH sessions and tunnels - http://www.harding.motd.ca/autossh/
brew install ssh-copy-id 							# Add a public key to a remote machine's authorized_keys file - http://www.openssh.com/
brew install sshrc								# Bring your .bashrc, .vimrc, etc. with you when you SSH - https://github.com/Russell91/sshrc
brew install sshguard								# Protect from brute force attacks against SSH (annd other services) - http://www.sshguard.net/
brew install openssl								# Standard OpenSSL Libraries - https://openssl.org - see comments from brew info openssl if building related utilities
brew install letsencrypt                                                        # Tool to obtain certs from Let's Encrypt and autoenable HTTPS - https://certbot.eff.org/
brew cask install keybase 							# Install keybase full app for managing trusted and verified identities - https://keybase.io 
brew cask install ssh-tunnel-manager						# Native macOS app to manage ssh tunnels - https://www.tynsoe.org/v2/stm/
brew cask install viscosity							# A first class OpenVPN client. 3 day trial. Worth the $9 license - https://www.sparklabs.com/viscosity/
brew cask install tunnelblick							# Tunnelblick is a free, open source graphic user interface for OpenVPN on OS X and macOS - https://www.tunnelblick.net/

echo "Installing GPG & associated libraries and utilities..."
brew cask install Caskroom/cask/gpgtools 					# Requires Password but also installs all gpg apps

# Install Security Utilities and Applications
echo "Installing Security Utilities..."
brew install dnscrypt-proxy --with-plugins                                      # Secure communications between a client and a DNS resolver - https://dnscrypt.org
brew install dependency-check					        	# OWASP Dependency Checker Utility
brew install exploitdb 								# The official Exploit Database - https://www.exploit-db.com/
brew install flawfinder 							# Examines code and reports possible security weaknesses - http://www.dwheeler.com/flawfinder/
brew install nmap 								# Port scanning utility for large networks - https://nmap.org/
brew install ncrack 								# Network authentication cracking tool - https://nmap.org/ncrack/
brew install wirouter_keyrec 							# Recover the default WPA passphrases from supported routers - http://www.salvatorefresta.net/tools/
brew install wireshark 								# Graphical network analyzer and capture tool - https://www.wireshark.org
brew install wifi-password 							# Show the current WiFi network password - https://github.com/rauchg/wifi-password
brew install zzuf								# Transparent application input fuzzer - http://caca.zoy.org/wiki/zzuf
brew cask install Caskroom/cask/integrity					# Integrity - http://peacockmedia.co.uk/integrity/
brew cask install Caskroom/cask/malwarebytes-anti-malware			# Malwarebytes Anti-Malware for Mac, AdwareMedic - https://www.malwarebytes.org/antimalware/mac/
brew cask install Caskroom/cask/virustotaluploader 				# VirusTotalUploader - https://www.virustotal.com/
brew cask install Caskroom/cask/clamxav						# ClamXav - https://www.clamxav.com/

echo "Installing Password Managers..."		
brew cask install Caskroom/cask/1password                                       # 1Password - https://agilebits.com/onepassword
brew cask install Caskroom/cask/lastpass                                        # LastPass - https://lastpass.com/
brew cask install Caskroom/cask/keepassx					# KeePassX - Cross Platform Password Manager - https://www.keepassx.org/ 

echo "Installing iTerm2 v3 (beta) & tmux..."
brew cask install Caskroom/versions/iterm2-beta
brew install tmux								# tmux requires openssl & libevent which will be installed also

# Configure Shell Integration for iTerm2
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash



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
brew install automake 
brew install autoconf 
brew install curl 
brew install pcre 
brew install re2c 
brew install mhash 
brew install libtool 
brew install icu4c 
brew link icu4c
brew install gettext 
brew install jpeg 
brew install libxml2 
brew install mcrypt 
brew install gmp 
brew install libevent
brew install timedog
brew install parallel
brew cask install etrecheck
brew cask install superduper					# Fantastic disk cloner & supplement to TimeMachine backups. Worth the paid upgrade to get scheduling, scripting and a whole lo more but
								# free version is plenty good to just take bootable image snapshots of your Mac.  http://www.shirt-pocket.com/SuperDuper/
brew cask install dupeguru					# Neat little file duplicate fincder utility for Mac (and other platforms.  Can target specific file types with custom search 
								# logic. From Hardcoded Software: https://www.hardcoded.net/dupeguru/
brew cask install spectacle					# Move and resize windows with ease - https://www.spectacleapp.com/
								# Window control with simple and customizable keyboard shortcuts

# Install Alternative Shells
echo "Installing zsh (Z Shell) and supporting utilities..."	
brew install zsh 						# UNIX shell (command interpreter) - http://www.zsh.org/
brew install zsh-autosuggestions 				# Fish-like fast/unobtrusive autosuggestions for zsh - https://github.com/zsh-users/zsh-autosuggestions
brew install zsh-completions 					# Additional completion definitions for zsh - https://github.com/zsh-users/zsh-completions
brew install zsh-history-substring-search			# Zsh port of Fish shell's history search - https://github.com/zsh-users/zsh-history-substring-search
brew install zsh-lovers 					# Tips, tricks, and examples for zsh - https://grml.org/zsh/#zshlovers
brew install zsh-syntax-highlighting 				# Fish shell like syntax highlighting for zsh - https://github.com/zsh-users/zsh-syntax-highlighting
brew install zshdb 						# Debugger for zsh - https://github.com/rocky/zshdb
brew install zssh 						# Interactive file transfers over SSH - http://zssh.sourceforge.net/
brew install zsync 						# File transfer program - http://zsync.moria.org.uk/

# Install top-utilities
echo "Installing top-based system utilities..."
brew install iftop						# Display an interface's bandwidth usage - http://www.ex-parrot.com/~pdw/iftop/
brew install htop 						# Improved top (interactive process viewer) - https://hisham.hm/htop/
brew install dnstop						# Console tool to analyze DNS traffic - http://dns.measurement-factory.com/tools/dnstop/index.html
brew install jnettop 						# View hosts/ports taking up the most network traffic - http://jnettop.kubs.info/ 

# Install DNS & other networking Utilities
brew install djbdns dnsmap dnstracer launchdns dnstwist validns
brew install iproute2mac

# Development Languages, Environments, & Related Utilities

# Python...
echo "Installing pip, pre-req for virtualenv, enter your password if promptedv..."
sudo easy_install pip

echo "Installing virtualenv & virtualenvwrapper..."
sudo -H pip install virtualenv --upgrade
sudo -H pip install virtualenvwrapper --upgrade --ignore-installed six
source /usr/local/bin/virtualenvwrapper_lazy.sh

# JavaScript, v8m, etc...
echo "Installing Node.js & npm..."
brew install node npm
export NODE_PATH="/usr/local/lib/node_modules"
brew install v8 gjstest flow
brew install jq 						# Lightweight and flexible command-line JSON processor - https://stedolan.github.io/jq/

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
export GOPATH="$HOME/work"
export PATH="$LOCALBIN:$PATH:$GOPATH/bin"
export JAVA_HOME="/usr/bin"

# Java
# TODO - Verify if JENV can be installed before the latest java cask
# TODO - Verify installation proceedures for alternate versions of Java (if needed)
echo "Installing and configuring all Java versions & jenv..."
brew install jenv
brew cask install Caskroom/cask/java
brew install jvmtop

# TODO - re-work path logic using jenv
export PATH="$JAVA_HOME/bin:$PATH"

# Message Queue Systems
brew install zurl                                               # HTTP and WebSocket client worker with ZeroMQ interface - https://github.com/fanout/zurl

# Slack Development Utilities, Toolkits, Bot SDKs
brew install slackcat



#
# PHP - NOTE - If we're going to run NGINX / Zend Server on VM's or Docker Containers
#
#  The the actual requirements for the local system in terms of PHP and post-config required
#  can be relatively light. I'm currently focusing on essential development tools, utilities,
#  and core language runtimes needed for my IDE & Editors to function properly
#  I am SPECIFICALLY not installing NGINX or Apache via homebrew but rather just the PHP 
#  languages and if needed the php modules.  
#  
#  TODO: Will test to verify if I can remove any of stuff I'm installing once I have Docker and VM's up and running.
#

echo "Tapping php Caskroom for developer tools..."
brew tap homebrew/php

echo "Installing PHP Development Language and Supporting Tools & Utilities..."
brew cask install Caskroom/cask/phpstorm

# Fix File System Case-Sensitivity Warning on PHPStorm Startup
cp work/mac-setup/idea.properties  ~/Library/Preferences/PhpStorm2016.1/

# Install local versions of PHP needed for development & testing
# Some of the following cause issues with my customized .bash_profile - need to troubleshoot

echo "Installing & Configuring PHP Brew to allow for multiple versions of php to be running on the local system..."
brew install phpbrew --ignore-dependencies

phpbrew init
[[ -e ~/.phpbrew/bashrc ]] && source ß~/.phpbrew/bashrc

phpbrew lookup-prefix homebrew

phpbrew update

phpbrew -d install -j --test 5.5.0 +all
phpbrew -d ext install -j +all


# Install PHP Development Utilities
echo "Installing PHP Development Tools & Utilities..."
brew install behat 										# behavior-driven development framework - http://behat.org/
brew install box 										# application for building and managing Phars - https://box-project.github.io/box2/
brew install brew-php-switcher 							# Switch Apache & CLI configs between PHP versions - https://github.com/philcook/php-switcher
brew install codeception 								# Testing Framework designed to work just out of the box - http://codeception.com/quickstart
brew install composer 									# Dependency Manager for PHP - http://getcomposer.org
brew install pdepend									# performs static code analysis - http://pdepend.org/
brew install php-code-sniffer 							# Check coding standards in PHP, JavaScript and CSS - http://pear.php.net/package/PHP_CodeSniffer
brew install php-cs-fixer  								# Tries to fix coding standards issues - http://cs.sensiolabs.org
brew install php-version  								# stupid simple PHP version management - https://github.com/wilmoore/php-version#simple-php-version-switching
brew install phpcpd  									# Copy/Paste Detector (CPD) for PHP code - https://github.com/sebastianbergmann/phpcpd
brew install phpdocumentor 								# Documentation Generator for PHP - http://www.phpdoc.org
brew install phpdox  									# Documentation generator for PHP - https://github.com/theseer/phpdox
brew install phpenv  									# Thin Wrapper around rbenv for PHP version managment - https://github.com/CHH/phpenv
brew install phplint  									# Validator and documentator for PHP 5 and 7 programs - http://www.icosaedro.it/phplint/
brew install phpmd  									# PHP Mess Detector - http://phpmd.org
brew install phpmetrics 								# Static analysis tool for PHP - http://www.phpmetrics.org
brew install phpsh 										# REPL (read-eval-print-loop) for php - http://www.phpsh.org/
brew install phpunit 									# Programmer-oriented testing framework for PHP - http://phpunit.de
brew install phpunit-skeleton-generator					# Generate skeleton test classes - http://phpunit.de/manual/current/en/
brew install pickle 									# Installs PHP extensions easily on all platforms. - https://github.com/FriendsOfPHP/pickle
brew install puli 										# Universal package system for PHP - http://puli.io
brew install sqlformat 									# CLI adaptation of the SqlFormatter library - https://github.com/MattKetmo/sqlformat
brew install virtphp 									# 1 Box, Multiple Elephpants - http://virtphp.org
brew install phpab 										# Lightweight php namespace aware autoload generator - https://github.com/theseer/Autoload
brew install mondrian 									# Analyse and refactor highly coupled classes - https://trismegiste.github.io/Mondrian/
brew install pharcc 									# PHARCC - tool that converts your php project into a .phar file - https://github.com/cbednarski/pharcc
brew install phan										# Static analyzer for PHP - https://github.com/etsy/phan
brew install php-plantumlwriter 						# Create UML diagrams from your PHP source - https://github.com/davidfuhr/php-plantumlwriter
brew install php-session-nginx-module 					# parse php sessions for nginx - https://github.com/replay/ngx_http_php_session
brew install envoy 										# Elegant SSH tasks for PHP - https://github.com/laravel/envoy
brew install igbinary									# Drop in replacement for the standard php serializer. https://pecl.php.net/package/igbinary

# Install DevOps Platform Components (CI / CD / Test Automation / Testing Plugins)
echo "Installing Jenkins..."
brew install jenkins
echo "Installing Selenium and associated webdrivers..."
brew install selenium-server-standalone
brew install js-test-driver


# Cloud / Virtualization / Container Stacks & Provisioning System
echo "Installing xhyve..."
brew install xhyve
echo "Installing VirtualBox..."
brew cask install Caskroom/cask/virtualbox
brew cask install Caskroom/cask/virtualbox-extension-pack
echo "Installing VMWare Fusion 8..."
brew cask install Caskroom/cask/vmware-fusion
echo "Installing Docker & Supporting Utilities..."
# Docker + Kitematic + Boot2Docker ???
echo "Installing Docker & Container Managment Utilities..."
brew cask install Caskroom/cask/dockertoolbox
brew install docker-cloud docker-gen docker-swarm dockviz docker-clean
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



# Install Red Hat OpenShift Cloud & Container Utilities
echo "Installing & Configuring RedHat Open Shift Utilities..."
brew install openshift-cli
sudo gem install rhc
echo "Initializing OpenShift Client Utilities - you will be prompted for login and ssh key information..."
# TODO: Write script that generates key, uploads to rhc, runs setup with --autocomplete and finally removes default id_rsa
# NOTE: Rough script logic below....ssh/config already updated to use assumptions in following code for paths
#
# mkdir .ssh/rhcloud.com/
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/rhcloud.com/id_rsa
# chmod 600 ~/.ssh/rhcloud.com/id_rsa
# rhc sshkey remove default
# rhc sshkey add default ~/.ssh/rhcloud.com/id_rsa.pub
# cp .ssh/config ~/.ssh/config
# rhc setup --autocomplete
# rm -f .ssh/*id


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

# Install Browsers, Communications Clients

echo "Installing Chrome Browser & Related Apps / Extensions..."
brew cask install Caskroom/cask/google-chrome Caskroom/cask/google-hangouts Caskroom/cask/google-adwords-editor
brew install chromedriver					            # Launcing requires either
	# Launch at Startup : ln -sfv /usr/local/opt/chromedriver/*.plist ~/Library/LaunchAgents
	# Launch on demand : launchctl load ~/Library/LaunchAgents/homebrew.mxcl.chromedriver.plist
brew cask install Caskroom/cask/chrome-devtools			# Run Chrome DevTools as a stand-alone app
brew install chrome-cli						            # Cool CLI Automation for Chrome, see https://github.com/prasmussen/chrome-cli

echo "Installing Firefox Browser and Related Apps / Extensions..."
brew cask install Caskroom/cask/firefox

echo "Installing Remote Access Utilities..."
brew cask install Caskroom/cask/teamviewer				# TeamViewer - https://www.teamviewer.com/

echo "Installing Mac OS X System Utilities..."
brew cask install Caskroom/cask/onyx
brew cask install Caskroom/cask/maintenance
brew cask install Caskroom/cask/deeper
brew cask install Caskroom/cask/the-unarchiver
brew cask install Caskroom/cask/daisydisk
brew cask install Caskroom/cask/divvy					# Divvy - Window Size & Placement Management Utility - https://mizage.com/divvy/

echo "Installing Messaging Apps"
brew cask install Caskroom/cask/slack
brew cask install Caskroom/cask/hipchat 
brew cask install Caskroom/cask/skype
brew cask install Caskroom/cask/zoomus

echo "Installing Document Readers"
brew cask install Caskroom/cask/kindle
brew cask install Caskroom/cask/adobe-reader
brew cask install Caskroom/cask/dash 
brew cask install Caskroom/cask/calibre
brew cask install Caskroom/cask/kindlepreviewer

echo "Installing Image Processing Libraries & Utilies..."
brew cask install Caskroom/cask/imageoptim 
brew install djvulibre djvu2pdf djview4 pngcrush
brew cask install Caskroom/cask/invisionsync
brew cask install Caskroom/cask/xnconvert Caskroom/cask/xnviewmp Caskroom/cask/xnconvert

echo "Installing Client Apps, IDE's and configuring UI Enhancements..."

# Installing vim Enhancements
brew install vim --override-system-vi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.eim
brew cask install Caskroom/cask/vimr

# Installing Visual Studio for Mac OS X
brew cask install Caskroom/cask/visual-studio-code

# Install Zend Stack : Zend Server, Z-Ray, Zend Studio
# TODO: http://justinhileman.info/article/reinstalling-php-on-mac-os-x/
# TODO: Add Zend Server via Docker
# TODO: Add Zend Server via Vagrant
# TODO: Add Zend Server via homebrew
# brew cask install Caskroom/cask/zendserver
brew cask install Caskroom/cask/zend-studio

# Install Mac-focused dev utilities
brew install anvil
brew cask install Caskroom/cask/rcenvironment

# Install Video Clients
echo "Installing Local and Online Video Clients..."
brew cask install 4k-video-downloader					            # YouTube video downloader
brew cask install Caskroom/vlc/vlc					                # Video Lan Client
brew cask install Caskroom/cask/airserver							# AirServer - https://www.airserver.com


echo "Install other client applications..."
brew cask install retro-virtual-machine virtual-ii virtualc64		# Emulate old platforms
brew install pipe-viewer
brew cask install Caskroom/cask/vienna
brew cask install blueservice calcservice wordservice easyfind
brew cask install activity-audit

echo "Install Paw HTTP REST / JSON API Development Utility..."
brew install paw 													# Install Lucky Marmots Paw (HTTP & REST Client) https://luckymarmot.com/paw
																	# NOTE: Licensing must occur manually

echo "Install Mac App Store CLI..."
brew install mas 													# Install the Mac App Store Command Line Interface for scripting App Store installations
																	# TODO: Write automation scripts for installing App Store Apps & upgrading apps

# Apps which cannot be installed via Homebrew - needs AppStore installation
# Apple Apps
# - Final Cut Pro 
# - Garage Band
# Buffer by Buffer
# Proxy by WebSecurify
# WebReaver by WebSecurify
# Voila by Global Delight Technologies
# AirMail
# FullContact - note ver 1 is available via Homebrew - testing to see if I can upgrade
# Magnet

# @TODO - Add logic for handling .dotfiles sync here

# Cleanup files downloaded for installations....
brew cleanup
brew cask cleanup
