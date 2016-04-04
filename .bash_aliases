#!/bin/bash
#
# Mac OS X Standard Bash Aliases Configuration
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
#
#

## Colorize the ls output, show normal & hidden files and folders and sort alphabetically by default ##
alias ls="ls -GaFlh"
 
## Use a long listing format for display ##
alias ll="ls -la"
 
## Show ONLY hidden files & Directories ##
alias l.="ls -d .*"

## Colorize the grep command output for ease of use (good for log files)##
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Make mount command output pretty and human readable format
alias mount="mount |column -t"

# Time functions
alias nowtime="date +'%T'"
alias nowdate="date +'%d-%m-%Y'"
alias now="nowtime && nowdate"

# Vim stuff
alias vi=vim
alias svi="sudo vi"

# Airport controls the wireless adapter
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# Resume wget by default
alias wget="wget -c"

# visual tree
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'" 

# use hub instead of standard git
alias git="hub"
alias gl="git lg"
alias gs="git status"

# homebrew aliases to speed up researching packages
alias bci="brew cask info "
alias bi="brew info "

