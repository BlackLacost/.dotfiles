#!/bin/bash

# Link directories
ln -sr $HOME/.dotfiles/config/vifm ~/.config -f
ln -sr $HOME/.dotfiles/config/nvim ~/.config -f

# Link files
ln -s $HOME/.dotfiles/wsl/.bashrc ~ -f
ln -s $HOME/.dotfiles/config/npm/.npmrc ~ -f
