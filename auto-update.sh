#!/bin/sh
# 
# Mac OS X Automated Homebrew Cask Updater for Applications
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
#  http://stackoverflow.com/questions/31968664/upgrade-all-the-casks-installed-via-homebrew-cask

# Option 1 - Just check for updates and blast every cask that needs new updates

# use xargs so that the output of the first command is used as args and not stdin
# brew cask list | xargs brew cask install --force

# Option 2 - Require some review & provide option to exit after gracefully uninstalling packages before installing updates

brew_cask_upgrade() { 

  if [ "$1" != '--continue' ]; then 
    echo "Removing brew cache" 
    rm -rf "$(brew --cache)" 
    echo "Running brew update" 
    brew update 
  fi 
  for c in $(brew cask list); do 
    echo -e "\n\nInstalled versions of $c: " 
    ls /opt/homebrew-cask/Caskroom/$c 
    echo "Cask info for $c" 
    brew cask info $c 
    select ynx in "Yes" "No" "Exit"; do  
      case $ynx in 
        "Yes") echo "Uninstalling $c"; brew cask uninstall --force "$c"; echo "Re-installing $c"; brew cask install "$c"; break;; 
        "No") echo "Skipping $c"; break;; 
        "Exit") echo "Exiting brew-cask-upgrade"; return;; 
      esac 
    done 
  done 
}

# Note - this is commented out, uncomment it to run!

brew_cask_upgrade
