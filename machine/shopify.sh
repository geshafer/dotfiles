#!/bin/bash

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install expected apps
brew bundle --file=- <<EOF
brew "ffmpeg"
brew "fzf"
brew "kubectl"
brew "kubectx"
brew "mcfly"
brew "mysql"
brew "neovim"
brew "node"
brew "rcm"
brew "ripgrep"
brew "ruby"
brew "starship"
brew "tmux"

cask "font-inconsolata-nerd-font"
cask "hammerspoon"
cask "iterm2"
cask "kitty"
cask "licecap"
cask "logseq"
cask "rectangle"
EOF

brew cleanup

# Setup expected defaults
$HOME/dotfiles/machine/mac/defaults.sh
