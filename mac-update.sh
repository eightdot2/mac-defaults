#!/bin/sh

# This file is intended to be run every so often to update MacOS

# Install Homebrew
if test ! $(which brew); then
  echo "   ▶ installing homebrew"
  ruby -e "$(curl -fsSl https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update and upgrade homebrew cask & packages
echo "   ▶ running homebrew and cask update & upgrade"
brew update && brew upgrade
brew cask upgrade && brew cleanup
echo "   ▶ done" '\n'

# Update App Store apps
echo "   ▶ if there are macOS app store updates, they will be listed here below ▼ " '\n'
sudo softwareupdate -l
echo '\n'
read -p "   ▶ if there are updates found, press any key to download and install them, or crtl+c to quit... " -n1 -s
echo '\n'
sudo softwareupdate -i -a --restart

########################################################################
#   STUFF TO ADD? ▼   
########################################################################
# add a multiple choice, i.e. press 1 to continue, any other key to quit
# dotfiles solution - probably using dotbot
