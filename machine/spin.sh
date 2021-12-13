#!/bin/bash

sudo apt-get install -y \
  fzf \
  rcm \
  silversearcher-ag \
  tmux

$HOME/dotfiles/machine/spin/install_neovim.sh

# install starship
curl -fsSL https://starship.rs/install.sh | sh -s -- -f
