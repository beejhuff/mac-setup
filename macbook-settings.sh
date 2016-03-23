#!/bin/bash
#
# macbook-settings.sh - Utility to configure optimum settings for my MacBook 
#
# Copyright 2016, Bryan R. Hoffpauir, Jr. (BJ Hoffpauir)
#
# References:
#  - SSD Optimizations for MacOS : http://icomputerdenver.com/ssd-optimization-for-mac-os
#  - Optimizing Mac OS X Lion for SSD : http://blog.alutam.com/2012/04/01/optimizing-macos-x-lion-for-ssd  
#  - SSD Optimizations on Mac OS X : http://blog.philippklaus.de/2011/04/ssd-optimizations-on-mac-os-x/
#  - Mac OS X 10.11 El Capitan on Harden the World : http://docs.hardentheworld.org/OS/OSX_10.11_El_Capitan/
#  - Disable SubmitDiagInfo on Ask Different : http://apple.stackexchange.com/questions/66119/disable-submitdiaginfo
#  - JAMF Discussion Thread : https://jamfnation.jamfsoftware.com/discussion.html?id=12075
#  - Disabling the iCloud and Diagnostics pop-up windows in Yosemite : 
#	https://derflounder.wordpress.com/2014/10/16/disabling-the-icloud-and-diagnostics-pop-up-windows-in-yosemite/
#  - GitHub Repo for author of above script : https://github.com/rtrouton/rtrouton_scripts
#  - Stop Apple SubmitDiagInfo Radar Submissions : http://best-mac-tips.com/2011/06/30/stop-apple-submitdiaginfo-radar-submissions/  
#  - How the NSA Snoop-Proofs its Macs : http://www.macworld.com/article/2048160/how-the-nsa-snoop-proofs-its-macs.html
#  - Controlling the diagnostics usage report settings on Yosemite :
#	https://derflounder.wordpress.com/2014/11/21/controlling-the-diagnostics-usage-report-settings-on-yosemite/
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
TIME_ZONE="America/Chicago"	# Default Time Zone Setting
PRIMARY_NTP="192.168.1.1"	# Primary Default Network Time Protocol Server
SECONDARY_NTP="us.pool.ntp.org"	# Secondary Default Network Time Protocol Server
BACKUP_NTP="time.apple.com"     # Backup Default Network Time Protocol Server
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
DESTROY_FV_KEYS=true		# Default to destroying File Vault Keys if entering Standby Mode
DISABLE_METADATA_CREATE=true	# Default to disabling creation of Metadata files where possible
				# NOTE: The reference article only provided examples for disabling creation on USB & Network volumes
				# TODO : Determine if it can be disabled on local volumes and what command is required...
DEFAULT_SEND_DIAGS=false	# Default to disabling the sending of diagnostic information to Apple
DEFAULT_EXT_ACCOUNTS=false	# Default to disabling accounts stored on drives other than the boot drive
DEFAULT_ICLOUD_SAVE=false	# Default to forcing applications to save to disk instead of iCloud by default
DEFAULT_SAVE_STATE=false	# Default to NOT saving window state on user logout

# General System Settings

# Initialize  a few parameters we're going to need later in the script
OS_MAJ_VER=$(sw_vers -productVersion | awk -F. '{print $2}')
CRASHREPORTER_SUPPORT="/Library/Application Support/CrashReporter"

echo "Refreshing Network Adapters..."
networksetup -detectnewhardware

#Default search domains
#SearchDomains="levi.com"

# Set the time zone
systemsetup -settimezone $TIME_ZONE

echo "Setting Hostname..."
systemsetup -setcomputername $HOSTNAME

echo "Configuring Network Time Server Settings..."
if $NETWORK_TIME ; then 
  sudo systemsetup -setnetworktimeserver $PRIMARY_NTP
  echo "server 0.$SECONDARY_NTP" >> /etc/ntp.conf 
  echo "server 1.$SECONDARY_NTP" >> /etc/ntp.conf
  echo "server 2.$SECONDARY_NTP" >> /etc/ntp.conf
  echo "server 3.$SECONDARY_NTP" >> /etc/ntp.conf
  echo "server $BACKUP_NTP" >> /etc/ntp.conf
  systemsetup -setusingnetworktime ON ; 
else
  systemsetup -setusingnetworktime OFF ; 
fi

echo "Configuring external accounts (i.e. accounts stored on drives other than the boot drive)..."
defaults write /Library/Preferences/com.apple.loginwindow EnableExternalAccounts -bool $DEFAULT_EXT_ACCOUNTS

echo "Configuring the save window state at logout..."
defaults write com.apple.loginwindow 'TALLogoutSavesState' -bool $DEFAULT_SAVE_STATE

echo "Configuring Remote Apple Events..."
if $REMOTE_EVENTS ; then systemsetup -setremoteappleevents ON ; else systemsetup -setremoteappleevents OFF ; fi   

echo "Configuring show all (hidden) files"
if $SHOW_ALL_FILES ; then defaults write com.apple.finder AppleShowAllFiles YES ; else defaults write com.apple.finder AppleShowAllFiles NO ; fi

echo "Configuring Enable / Disable Cut in Finder"
if $ENABLE_CUT ; then defaults write com.apple.finder AllowCutForItems YES ; else defaults write com.apple.finder AllowCutForItems NO ; fi

# TODO : These are failing, need to research reason and update to correct failures

# Set Shutdown and Logoff timers to 1 second (No Delay)
#echo "Configuring Shutdown and Logoff Timers to 1 second (No Delay)..."
#defaults write /System/Library/LaunchDaemons/com.apple.coreservices.appleevents ExitTimeOut -int 1
#defaults write /System/Library/LaunchDaemons/com.apple.securityd ExitTimeOut -int 1
#defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder ExitTimeOut -int 1
#defaults write /System/Library/LaunchDaemons/com.apple.diskarbitrationd ExitTimeOut -int 1

echo "Removing the loginwindow delay by loading the com.apple.loginwindow"
launchctl load /System/Library/LaunchDaemons/com.apple.loginwindow.plist


# Security Settings

echo "Configuring File Vault to destroy keys on Standby..."
if $DESTROY_FV_KEYS ; then pmset destroyfvkeyonstandby 1; else pmset destroyfvkeyonstandby 0 ; fi

echo "Configuring settings for the creation of Metadata Files where possible..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool $DISABLE_METADATA_CREATE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool $DISABLE_METADATA_CREATE

echo "Configuring submission of diagnostic details (enabled by default, disabling requires reboot to take effect)..."
# Logic written only functional on OS X 10.10 or greater...
if if [[ ${OS_MAJ_VER} -ge 10 ]]; then
  # Version Number Reqiured to pass changed in El Capitan, so verify which one to use later...
  if [[ ${OS_MAJ_VER} -eq 10 ]]; then
    VERSIONNUMBER=4
  elif [[ ${OS_MAJ_VER} -ge 11 ]]; then
    VERSIONNUMBER=5
  fi

  if [ ! -d "${CRASHREPORTER_SUPPORT}" ]; then
    mkdir "${CRASHREPORTER_SUPPORT}"
    chmod 775 "${CRASHREPORTER_SUPPORT}"
    chown root:admin "${CRASHREPORTER_SUPPORT}"
  fi

  # Set INT Attributes based on above determination
  defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmitVersion -int ${VERSIONNUMBER}
  defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmitVersion -int ${VERSIONNUMBER}

  if $DEFAULT_SEND_DIAGS ; then 
    defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmit -boolean TRUE
    defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmit -boolean TRUE  
  fi
fi

echo "Configuring applications save to disk defaults..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool $DEFAULT_ICLOUD_SAVE 


# Disk Optimizations

echo "Configuring Local Time Machine Backup Storage..."p
if $DISABLE_LOCAL_TM_BACKUP ; then tmutil disablelocal ; else tmutil enablelocal ; fi

echo "Configuring Hibernate..."
if $DISABLE_HIBERNATE ; then 
  pmset -a hibernatemode 0 && pmset -a autopoweroff 0 ; 
else 
  pmset -a hibernatemode 1 && pmset -a autopoweroff 1 ;
fi

echo "Deleting previously created sleep images (if they exist)..."
if $DISABLE_HIBERNATE; then test -f /var/vm/sleepimage && rm /var/vm/sleepimage ; fi

echo "Configuring Access Time Attribute Recording for files and directories..."
if $DISABLE_ATIME ; then 
  cp com.noatime.plist /Library/LaunchDaemons
  chown root:wheel /Library/LaunchDaemons/com.noatime.plist
fi

echo "Configuring Sudden Motion Sensor..."
if $DISABLE_MOTION ; then pmset -a sms 0 ; else pmset -a sms 1 ; fi

echo "Configure HDD Sleep..."
if $DISABLE_DISK_SLEEP ; then systemsetup -setharddisksleep Never ; else systemsetup -setharddisksleep 60 ; fi

echo "Configure Display Sleep..."
if $DISABLE_DISPLAY_SLEEP ; then systemsetup -setdisplaysleep Never ; else systemsetup -setdisplaysleep $DISPLAY_SLEEP_TIMEOUT ; fi

echo "Configuring Wake on Lan..."
if $WAKE_ON_LAN ; then systemsetup -setwakeonnetworkaccess ON ; else systemsetup -setwakeonnetworkaccess OFF ; fi


