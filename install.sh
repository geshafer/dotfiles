#!/bin/bash

if scutil --get ComputerName | grep -i Shopify &>/dev/null; then
  ./machine/shopify.sh
  cp -f gitconfig-shopify gitconfig-default
else
  ./machine/mac.sh
  cp -f gitconfig-personal gitconfig-default
fi

env RCRC=$HOME/dotfiles/rcrc rcup -f
