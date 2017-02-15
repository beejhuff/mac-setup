#!/bin/bash
#
# Mac OS X Standard Bash Profile Configuration
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
# TODO - Review all commands setting a PATH and make sure there's no conflicts and that
#       the implementation is idempotent.
#
# TODO - Review Go configuration per messages from homebrew install:
#       As of go 1.2, a valid GOPATH is required to use the `go get` command:
#         https://golang.org/doc/code.html#GOPATH
#
#       You may wish to add the GOROOT-based install location to your PATH:
#         export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Set USER's local bin directory path
export LOCALBIN="$HOME/bin"

# Customize Prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\] \$ "

# Enable Pretty Shell Color Output
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set architecture flags
export ARCHFLAGS="-arch x86_64"


# Configure PATH
# Ensure user-installed binaries take precedence over anything else in the path
export PATH="$LOCALBIN:/usr/local/sbin:/usr/local/bin:/usr/local/opt/openssl/bin:/usr/local/opt/gettext/bin:$HOME/.basher/bin:$PATH"

# Initialize Settings for various programming languages

# Configure Java / jenv settings from Homebrew for PATH, shims & autocomplete if it's installed
if [ -d "/usr/local/var/jenv" ]; then
  export JENV_ROOT="/usr/local/var/jenv"
  eval "$(jenv init -)" 
fi

# Set Go path & add to PATH per : https://golang.org/doc/code.html#GOPATH
if [ which go > /dev/null && -d "$HOME/gocode" ]; then
  export GOPATH="$HOME/gocode"
  export PATH="$PATH:$GOPATH/bin"
fi

# Configure PATH for Virtualenv
# export PATH="/usr/local/lib/python2.7/site-packages:$PATH"
# source /usr/local/bin/virtualenvwrapper_lazy.sh

# Configure Node.js PATH if it's installed...
[ -d "/usr/local/lib/node_modules" ] && export NODE_PATH="/usr/local/lib/node_modules"

# Initialize Ruby Environnments
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


# Customize Bash Options
# If configured, activate bash auto-completion
[ -f $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion

# If configured, activate iTerm2 Shell Integration
[ -f ~/.iterm2_shell_integration.`basename $SHELL`] && source ~/.iterm2_shell_integration.`basename $SHELL`

# If configured, activate the bash-git-prompt add-in
# Need to determine how to customize so we don't lose PS1 details set above
# test -f $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh &&  source $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh


# If they exist, load secret credentials files (GIT ACCESS TOKEN / AWS CREDS, etc...)
[ -f ~/.api_keys ] && source ~/.api_keys

# Configure Google Cloud SDK Path & Auto-Completion (if they exist...)
[ -f '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc' ] && source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
[ -f '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc' ] && source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'

# Configure RedHat OpenShift Client Settings (If they exist...)
[ -f ~/.openshift/bash_autocomplete ] && source ~/.openshift/bash_autocomplete

# Load .bashrc if it exists
[ -f ~/.bashrc ] && source ~/.bashrc

# NOTE - This makes the PS1 customization above irrelvant...
# Load & Configure LiquidPrompt if it's installed
# [ -f /usr/local/share/liquidprompt ] && . /usr/local/share/liquidprompt

