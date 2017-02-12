#!/bin/bash
#
# Mac OS X Standard Bash .bashrc Configuration
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
#
#
# Load bash aliases fromn dedicated alias file
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable pip bash completion if installed and configured...
if [ -f "$HOME/bash_completion.d/pip" ] ; then
    . $HOME/bash_completion.d/pip
fi

