#!/bin/bash
#
# Mac OS X Standard Bash .bashrc Configuration
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
#


## Initialize Settings for various programming languages ##
#
# Configure Java / jenv settings from Homebrew for PATH, shims & autocomplete if it's installed
if [ -d "/usr/local/var/jenv" ]; then
  export JENV_ROOT="/usr/local/var/jenv"
  eval "$(jenv init -)"
fi

# Set Go path & add to PATH per : https://golang.org/doc/code.html#GOPATH
if which go > /dev/null && [ -d "$HOME/gocode" ]; then
  export GOPATH="$HOME/gocode"
  export PATH="$PATH:$GOPATH/bin"
fi

# Configure PATH for Virtualenv - Commented out until we determine which env system we need to use
# export PATH="/usr/local/lib/python2.7/site-packages:$PATH"
# source /usr/local/bin/virtualenvwrapper_lazy.sh

# Configure Node.js PATH if it's installed...
[ -d "/usr/local/lib/node_modules" ] && export NODE_PATH="/usr/local/lib/node_modules"

# Initialize Ruby Environnments
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


## Initialize Cloud Environments as needed.....   ##
#
# Configure Google Cloud SDK Path & Auto-Completion (if they exist...)
[ -f "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" ] && source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
[ -f "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ] && source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

# Configure RedHat OpenShift Client Settings (If they exist...)
[ -f "$HOME/.openshift/bash_autocomplete" ] && source "$HOME/.openshift/bash_autocomplete"


# Customize Prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]$(scutil --get HostName):\[\033[33;1m\]\w\[\033[m\] \$ "

## NOTE - I've disabled both of the following since they conflict with both each other and the previous PS1 assignment and would likely
##      be made irrelevant by powerline anyways.
##
# Load & Configure LiquidPrompt if it's installed
# [ -f "/usr/local/share/liquidprompt" ] && source "/usr/local/share/liquidprompt"
#
# If configured, activate the bash-git-prompt add-in
# Need to determine how to customize so we don't lose PS1 details set above
# test -f $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh &&  source $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh



# Customize Bash Options
# If configured, activate bash auto-completion
[ -f "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"

# If installed & configured, activate iTerm2 Shell Integration
[ -f "$HOME/.iterm2_shell_integration.$(basename $SHELL)" ] && source "$HOME/.iterm2_shell_integration.$(basename $SHELL)"

