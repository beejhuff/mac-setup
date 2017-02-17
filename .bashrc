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
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\] \$ "

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

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Load Bash It
source $BASH_IT/bash_it.sh
