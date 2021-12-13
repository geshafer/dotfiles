#!/bin/bash

brew bundle --file=- <<EOF
brew "fzf"
brew "mcfly"
brew "neovim"
brew "rcm"
brew "starship"
brew "the_silver_searcher"
brew "tmux"
EOF

brew cleanup
