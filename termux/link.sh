#!/bin/bash

# Link directories
ln -sr $HOME/.dotfiles/config/vifm ~/.config -f
ln -sr $HOME/.dotfiles/config/nvim ~/.config -f

# Link files
ln -s $HOME/.dotfiles/termux/.gitconfig ~ -f
ln -s $HOME/.dotfiles/config/npm/.npmrc ~ -f
ln -s $HOME/.dotfiles/termux/.bashrc ~ -f
ln -s $HOME/.dotfiles/termux/.inputrc ~ -f

