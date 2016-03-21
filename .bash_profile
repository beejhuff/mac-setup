#!/bin/bash
#
# Mac OS X Standard Bash Profile Configuration
# 
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
# TODO - Review all commands setting a PATH and make sure there's no conflicts and that 
#	the implementation is idempotent.
#
# TODO - Review Go configuration per messages from homebrew install:
#	As of go 1.2, a valid GOPATH is required to use the `go get` command:
#	  https://golang.org/doc/code.html#GOPATH
#
#	You may wish to add the GOROOT-based install location to your PATH:
#	  export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Set USER's local bin directory path
export LOCALBIN="$HOME/bin"

# Specify Homebrew defaults for installation directory and Caskroom diurectory in this environment variable
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/opt/homebrew-cask/Caskroom/"

# Customize Prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Enable Pretty Shell Color Output
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set architecture flags
export ARCHFLAGS="-arch x86_64"


# WHAT IS THIS FOR???
# export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:~/bin/pear/bin:~/bin:$(brew --prefix coreutils)/libexec/gnubin:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$(brew --prefix homebrew/php/php55)/bin:$PATH


# Initialize Settings for various programming languages

# Configure Java / jenv settings from Homebrew for PATH, shims & autocomplete
export JENV_ROOT="/usr/local/var/jenv"
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Set Go path per : https://golang.org/doc/code.html#GOPATH
export GOPATH="$HOME/work"
export PATH="$LOCALBIN:$PATH:$GOPATH/bin"

# Configure PATH for Virtualenv
export PATH="/usr/local/lib/python2.7/site-packages:$PATH"
source /usr/local/bin/virtualenvwrapper_lazy.sh

# Configure Node.js PATH
export NODE_PATH="/usr/local/lib/node_modules"

# Initialize Ruby Environnments
eval "$(rbenv init -)"


# Customize Bash Options
# If configured, activate bash auto-completion
test -f $(brew --prefix)/etc/bash_completion && source $(brew --prefix)/etc/bash_completion

# If configured, activate the bash-git-prompt add-in
# Need to determine how to customize so we don't lose PS1 details set above
# test -f $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh &&  source $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh


# If they exist, load secret credentials files (GIT ACCESS TOKEN / AWS CREDS, etc...)
test -f ~/mac-setup/.api_keys && source ~/mac-setup/.api_keys

# Configure PATH
# Ensure user-installed binaries take precedence over anything else in the path
export PATH="/usr/local/bin:$PATH"

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

