#!/bin/sh

# This file is intended as a run-once to setup a new machine

echo
echo "   ▶ Set hostname, connect to wifi, clone github mac-defaults repo and then run this script"
echo
read -p "   ▶ Press enter to continue or control+c to cancel"

# Run without downloading:
# curl -LJ0 https://raw.githubusercontent.com/eightdot2/dotfiles/master/mac-build.sh | bash

# Set hostname and timezone, to fiond your local timezone: 'systemsetup -listtimezones'
TIMEZONE="Europe/London" 

# Close all open System Preferences panes before making changes
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password
sudo -v

sudo softwareupdate -i -a

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install xcode to get git installed prior to homebrew
# xcode-select --install

# install homebrew if it's missing
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

# Update homebrew recipes & tap casks
echo
echo "   ▶ Updating homebrew recipes & installing casks"
brew update && brew upgrade
brew cask upgrade
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers

# List of cli apps to install
cliapps=(
  bash-completion
  bat
  git
  iperf
  macvim
  mas
  nmap
  speedtest-cli
  telnet
  wget
  shfmt
  ncdu
  htop
  tldr
  fd
)

echo
echo "   ▶ Installing cli apps with brew"
brew install ${cliapps[@]}

# List of apps to install
apps=(
  alfred 
  brave-browser
  caffeine 
  charles 
  dash 
  docker 
  easyfind 
  firefox 
  gimp 
  github 
  google-backup-and-sync 
  google-chrome 
  google-chrome-canary 
  iterm2 
  java 
  jdownloader 
  little-snitch 
  nordvpn 
  powershell 
  pritunl 
  royal-tsx 
  shimo 
  slack 
  sonos 
  sourcetree 
  swinsian 
  tor-browser 
  visual-studio-code 
  vlc 
  vnc-viewer 
  webstorm 
  wireshark 
  zoom
)

# Install apps to /Applications
# Default is /Users/$user/Applications
echo "   ▶ Installing core apps with Cask"
brew cask install --appdir="/Applications" ${apps[@]}

# cleanup
echo "   ▶ Cleaning up brew"
brew cleanup -v

# install from app store 
mas install 441258766 # magnet

echo "   ▶ Setting the timezone to $TIMEZONE"
systemsetup -settimezone $TIMEZONE > /dev/null

echo "   ▶ Now configuring defaults write settings"
echo '\n'

###############################################################################
# Finder ▼
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: do not show warning when changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: no warning when emptying the bin
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Finder: remove items from the bin after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Finder: show these items on the desktop (everything)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Finder: show full POSIX path as window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Use list view in all Finder windows by default
# Possible view modes: `icnv`, `clmv`, `Flwv`, `Nlsv` (icon, column, coverflow, list)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Dock ▼
###############################################################################

# Dock: automatically hide and show
defaults write com.apple.dock autohide -bool true

# Dock: set icon size of items to 39 pixels
defaults write com.apple.dock tilesize -int 39

# Dock: minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Dock: show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Dock: delete all default app icons from the dock
defaults write com.apple.dock persistent-apps -array

# Dock: don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Dock: do not show recently used apps
defaults write com.apple.dock show-recents -bool FALSE

###############################################################################
# Trackpad and Keyboard ▼
###############################################################################

# Trackpad: setting various behavious
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: Disable the over-sensitive backswipe
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Keyboard: set repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Keyboard: disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Keyboard: disable press-and-hold for keys
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Activity Monitor ▼
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Energy Saving ▼
###############################################################################

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15

# Set machine sleep to 15 minutes on battery
sudo pmset -b sleep 15

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Enable lid wakeup
sudo pmset -a lidwake 1

###############################################################################
# Misc ▼
###############################################################################

# Saving: screenshots to the desktop
defaults write com.apple.screencapture location -string “$HOME/Desktop”

# Saving: screenshots as a PNG file
defaults write com.apple.screencapture type -string “png”

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Password: require immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Scrollbars: set to always show
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Spaces: don’t automatically rearrange based on most recent used
defaults write com.apple.dock mru-spaces -bool false

# Menu: show battery percentage
defaults write com.apple.menuextra.battery ShowPercent YES

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Updates: download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# Printer: automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

# Permanently allow apps downloaded from “anywhere”
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool NO

echo "   ▶ Defaults settings complete, restarting Finder now"
killall -HUP Finder

echo "   ▶ Done - it would be a good idea to reboot now"

######################################################################################################
# Stuff still to do ▼
######################################################################################################
# don't install if already installed
# check if magnet installed first before trying
# Chrome: Install extensions when installing chrome:-  lastpass, instapaper, trello, sprucemarks, chrome downloader, archdaily
# Keyboard: Remap the caps lock to ESC for all keyboards
#######################################################################################################
