#!/bin/sh
# 
# Mac OS X Automated Installer Bash Profile Configuration
#
# Copyright 2016 - Bryan R. Hoffpauir, Jr.
#
#  https://github.com/knitschmann/DeviceAutomization/blob/master/OSX/update.sh

fetch(){
    echo "Removing brew cache" 
    rm -rf "$(brew --cache)" 
    echo "Running brew update" 
    brew update 
}

lookup() { 
  for c in $(brew cask list); do 
    brew cask info $c 
  done 
} 

update(){
  var=$( lookup  | grep -B 3 'Not installed' | sed -e '/^http/d;/^Not/d;/:/!d'  | cut -d ":" -f1)
  if [ -n "$var" ]; then
  echo "The following installed casks have updates avilable:"
  echo "$var"
  echo "Install updates now?"
  select yn in "Yes" "No"; do
    case $yn in
      "Yes") echo "updating outdated casks"; break;;
      "No") echo "brew cask upgrade cancelled" ;return;;
      *) echo "Please choose 1 or 2";;
    esac
    done
  for i in $var; do
    echo "Uninstalling $c"; brew cask uninstall --force "$i"; echo "Re-installing $i"; brew cask install "$i"
  done
else
  echo "all casks are up to date"
fi
}

fetch
update
