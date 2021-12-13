#!/bin/bash

brew bundle --file=- <<EOF
brew "fzf"
brew "neovim"
brew "rcm"
brew "the_silver_searcher"
brew "tmux"
EOF

brew cleanup
