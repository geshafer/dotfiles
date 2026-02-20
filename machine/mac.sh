#!/bin/bash

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install expected apps
brew bundle --upgrade --file=- <<EOF
brew "ffmpeg"
brew "fzf"
brew "git"
brew "go"
brew "gopls"
brew "kubebuilder"
brew "kubectl"
brew "kubectx"
brew "mcfly"
brew "neovim"
brew "node"
brew "rcm"
brew "ripgrep"
brew "ruby"
brew "starship"
brew "tmux"

cask "docker"
cask "font-inconsolata-nerd-font"
cask "hammerspoon"
cask "iterm2"
cask "keymapp"
cask "kitty"
cask "licecap"
cask "logseq"
cask "rectangle"
cask "shortcat"

EOF

brew tap tobi/try https://github.com/tobi/try
brew install try

brew cleanup

# Setup expected defaults
$HOME/dotfiles/machine/mac/defaults.sh
