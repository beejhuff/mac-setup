#!/bin/sh 
#
# My standard macOS user profile script that contains code I want executed on every login
# across all shells (currently tested & using bash and zsh).  It should be sourced
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
##  References: 
##  - How can you export your .bashrc to .zshrc? : 
##	http://stackoverflow.com/questions/764600/how-can-you-export-your-bashrc-to-zshrc
##  - How can zsh and normal shell share environment variables and alias without copy each other : 
##	http://stackoverflow.com/questions/34565843/how-can-zsh-and-normal-shell-share-environment-variables-and-alias-without-copy
##  - Share aliases and PATH setting between zsh and bash : 
##	http://unix.stackexchange.com/questions/3428/share-aliases-and-path-setting-between-zsh-and-bash
##  - Understanding a little more about /etc/profile and /etc/bashrc :
##	http://bencane.com/2013/09/16/understanding-a-little-more-about-etcprofile-and-etcbashrc/
##  - Bash Environment : https://jeremiahgaw.me/2016/03/31/bash-environment/
##  - Zsh/Bash startup files loading order (.bashrc, .zshrc etc.) :
##      - http://stackoverflow.com/questions/34565843/how-can-zsh-and-normal-shell-share-environment-variables-and-alias-without-copy
##  - Choosing between .bashrc, .profile, .bash_profile, etc [duplicate] :
##	- http://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc

# Set Global Enviroinment Variables needed across all shells

# Start with API_KEYS, if it exists
[ -f "$HOME/.api_keys" ] && source "$HOME/.api_keys"

# Load shell aliases fromn dedicated alias file
[ -f ~/aliases-setup ] && source  ~/aliases-setup

# Load Environment Variables
# Set USER's local bin directory path
export LOCALBIN="$HOME/bin"

# Enable Pretty Shell Color Output
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# Configure Default PATH
# Ensure user-installed binaries take precedence over anything else in the path
export PATH="$LOCALBIN:/usr/local/sbin:$PATH"

# Ensure git uses the newer version of ssh we've installed
export GIT_SSH="$(which ssh)"


