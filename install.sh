#!/bin/bash

if [ $SPIN ]; then
  ./machine/spin.sh
else
  ./machine/mac.sh
fi

if [ $SPIN ]; then
  cp -f gitconfig-spin gitconfig-default
elif hostname | grep -i Shopify &>/dev/null; then
  cp -f gitconfig-shopify gitconfig-default
else
  cp -f gitconfig-personal gitconfig-default
fi

env RCRC=$HOME/dotfiles/rcrc rcup -f

exec zsh
