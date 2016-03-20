#!/bin/sh
#
# macbook-settings.sh - Utility to configure optimum settings for my MacBook 
#
# Copyright 2016, Bryan R. Hoffpauir, Jr. (BJ Hoffpauir)
#
# References:
#  - SSD Optimizations for MacOS : http://icomputerdenver.com/ssd-optimization-for-mac-os
#  - Optimizing Mac OS X Lion for SSD : http://blog.alutam.com/2012/04/01/optimizing-macos-x-lion-for-ssd  
#  - SSD Optimizations on Mac OS X : http://blog.philippklaus.de/2011/04/ssd-optimizations-on-mac-os-x/
#
# Usage:
# 
# 1) Configure the few available script variables
# 2) Run 
#    a) Manually
#      $ chmod +x macbook-settings.sh
#      $ sudo ./macbook-settings.sh
#
#    b) Call from another script
#
# Configurable Settings Variables

HOSTNAME="ignatius"             # Enter the name of your host here
NETWORK_TIME=true               # Default to enabling ntp Network Time Server
REMOTE_EVENTS=false		# Default to blocking remote Apple Events 
REMOTE_LOGINS=true		# Default to enabling remote logins for ssh
SHOW_ALL_FILES=true		# Default to displaying all files, including hidden files
ENABLE_CUT=true 		# Default to enabling Cut functionality in Finder
DISABLE_LOCAL_TM_BACKUP=true    # Default to disabling local Time Machine Backup to Hard Drive
DISABLE_HIBERNATE=true		# Default to disabling hibernate
DISABLE_ATIME=true		# Default to disabling the recording of Access Time for files / dirs
DISABLE_MOTION=true		# Default to disabling the Sudden Motion Sensor for HDD's
DISABLE_DISK_SLEEP=true		# Default to disabling the Auto-Sleep funtion for inactive HDD's
DISABLE_DISPLAY_SLEEP=false	# Default to enabling the Auto-Sleep function for Display (next var sets timeout)
DISPLAY_SLEEP_TIMEOUT=60	# Default time before Display auto-sleeps (in minutes)
WAKE_ON_LAN=true		# Default to enabling Wake On Lan


# General System Settings

echo "Setting Hostname..."
sudo systemsetup -setcomputername $HOSTNAME

echo "Configuring Network Time Server..."
if $NETWORK_TIME ; then sudo systemsetup -setusingnetworktime ON; else sudo systemsetup -setusingnetworktime OFF ; fi 

echo "Configuring Remote Apple Events..."
if $REMOTE_EVENTS ; then then sudo systemsetup -setremoteappleevents ON ; else sudo systemsetup -setremoteappleevents OFF ; fi   

echo "Configuring show all (hidden) files"
if $SHOW_ALL_FILES ; then defaults write com.apple.finder AppleShowAllFiles YES ; else defaults write com.apple.finder AppleShowAllFiles NO ; fi

echo "Configuring Enable / Disable Cut in Finder"
if $DISABLE_LOCAL_TM_BACKUP ; then defaults write com.apple.finder AllowCutForItems YES ; else then defaults write com.apple.finder AllowCutForItems NO ; fi



# Disk Optimizations

echo "Configuring Local Time Machine Backup Storage..."p
if $DISABLE_LOCAL_TM_BACKUP ; then sudo tmutil disablelocal ; else sudo tmutil enablelocal ; fi

echo "Configuring Hibernate..."
if $DISABLE_HIBERNATE ; then sudo pmset -a hibernatemode 0 ; else sudo pmset -a hibernatemode 0 ; fi

echo "Deleting previously created sleep images (if they exist)..."
if $DISABLE_HIBERNATE; then sudo test -f /var/vm/sleepimage && rm /var/vm/sleepimage ; fi

echo "Configuring Access Time Attribute Recording for files and directories..."
if $DISABLE_ATIME ; then 
  sudo cp com.noatime.plist /Library/LaunchDaemons
  sudo chown root:wheel /Library/LaunchDaemons/com.noatime.plist
fi

echo "Configuring Sudden Motion Sensor..."
if $DISABLE_MOTION ; then sudo pmset -a sms 0 ; else sudo pmset -a sms 1 ; fi

echo "Configure HDD Sleep..."
if $DISABLE_DISK_SLEEP ; then sudo systemsetup -setharddisksleep Never ; else sudo systemsetup -setharddisksleep 60 ; fi

echo "Configure Display Sleep..."
if $DISABLE_DISPLAY_SLEEP ; then sudo systemsetup -setdisplaysleep Never ; else sudo systemsetup -setdisplaysleep $DISPLAY_SLEEP_TIMEOUT ; fi

echo "Configuring Wake on Lan..."
if $WAKE_ON_LAN ; then sudo systemsetup -setwakeonnetworkaccess ON ; else sudo systemsetup -setwakeonnetworkaccess OFF ; fi


