#!/bin/bash

if [ $SPIN ]; then
  ./machine/spin.sh
  cp -f gitconfig-spin gitconfig-default
elif hostname | grep -i Shopify &>/dev/null; then
  ./machine/shopify.sh
  cp -f gitconfig-shopify gitconfig-default
else
  ./machine/mac.sh
  cp -f gitconfig-personal gitconfig-default
fi

env RCRC=$HOME/dotfiles/rcrc rcup -f
