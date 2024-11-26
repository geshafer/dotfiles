#!/bin/bash

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install expected apps
brew bundle --file=- <<EOF
brew "ffmpeg"
brew "fzf"
brew "go"
brew "gopls"
brew "kubebuilder"
brew "kubectl"
brew "kubectx"
brew "mcfly"
brew "neovim"
brew "node"
brew "rcm"
brew "ruby"
brew "starship"
brew "the_silver_searcher"
brew "tmux"

cask "docker"
cask "hammerspoon"
cask "iterm2"
cask "licecap"
cask "logseq"
cask "rectangle"
EOF

brew cleanup

# Install preferred font
cp fonts/Inconsolata\ Nerd\ Font\ Complete\ Mono.otf ~/Library/Fonts/

# Setup expected defaults
$HOME/dotfiles/machine/mac/defaults.sh
