#!/bin/bash

sudo apt-get install -y \
  fzf \
  rcm \
  silversearcher-ag \
  tmux

# install mcfly
cartridge insert mcfly
ln -sf ~/.data/cartridges/mcfly ~/.mcfly
curl -fsSL https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly

# install neovim
$HOME/dotfiles/machine/spin/install_neovim.sh

# install starship
curl -fsSL https://starship.rs/install.sh | sh -s -- -f
