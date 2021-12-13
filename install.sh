#!/bin/bash

if [ $SPIN ]; then
  ./machine/spin.sh
else
  ./machine/mac.sh
fi

env RCRC=$HOME/dotfiles/rcrc rcup -f

exec zsh
