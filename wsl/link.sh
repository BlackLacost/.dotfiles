#!/bin/bash

# Link directories
ln -sr $HOME/.dotfiles/config/vifm ~/.config -f
ln -sr $HOME/.dotfiles/config/nvim ~/.config -f

# Link files
ln -s $HOME/.dotfiles/config/git/.gitconfig ~ -f
ln -s $HOME/.dotfiles/config/npm/.npmrc ~ -f
ln -s $HOME/.dotfiles/wsl/.bashrc ~ -f
ln -s $HOME/.dotfiles/wsl/.inputrc ~ -f

# Link scripts
ln -s $HOME/.dotfiles/home/.local/bin/gen_pass.sh ~/.local/bin -f
