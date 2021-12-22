#!/bin/bash

# Install expected apps
brew bundle --file=- <<EOF
brew "fzf"
brew "mcfly"
brew "neovim"
brew "rcm"
brew "starship"
brew "the_silver_searcher"
brew "tmux"

cask "docker"
cask "iterm2"
EOF

brew cleanup

# Install preferred font
cp fonts/Inconsolata\ Nerd\ Font\ Complete\ Mono.otf ~/Library/Fonts/

# Setup expected defaults
$HOME/dotfiles/machine/mac/defaults.sh
