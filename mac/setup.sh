#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
  echo "Not MacOS!"
  exit 0
fi

sudo nvram StartupMute=%01

# Dock
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write com.apple.dock magnification -bool no
defaults write com.apple.dock largesize -int 96
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock orientation -string "right"

# Screenshot
defaults write com.apple.screencapture "disable-shadow" -bool "true"
defaults write com.apple.screencapture location ~/Downloads
defaults write com.apple.screencapture type -string "png"

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder ShowPathbar -bool "true"
defaults write com.apple.finder WarnOnEmptyTrash -bool "false"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FinderSounds -bool no
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Feedback
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
defaults write com.apple.CrashReporter DialogType -string "none"

# .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

# Battery
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"
defaults -currentHost write -g com.apple.mouse.tapBehavior -bool "true"
defaults write -g com.apple.trackpad.scaling 30

# Mouse
defaults write -g com.apple.mouse.scaling -1

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari AutoFillPasswords -bool false

# Others
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool "false"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool "false"
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
