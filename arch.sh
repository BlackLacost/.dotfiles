#!/bin/bash

DOTFILES_DIR=$HOME/.dotfiles

source $DOTFILES_DIR/linux/nvm_install.sh

ln -sfr $DOTFILES_DIR/home/.config/bashrc/ ~/.config
if ! grep -qF "source ~/.config/bashrc/basic.sh" ~/.bashrc; then
  echo "source ~/.config/bashrc/basic.sh" >> ~/.bashrc
fi

# Link directories
# ln -sr $HOME/.dotfiles/config/vifm ~/.config -f
ln -sfr $DOTFILES_DIR/config/nvim/ ~/.config
ln -sfr $DOTFILES_DIR/home/.config/alacritty/ ~/.config
ln -sfr $DOTFILES_DIR/home/.config/doom/ ~/.config
if ! grep -qF "source ~/.config/doom/bashrc" ~/.bashrc; then
  echo "source ~/.config/doom/bashrc" >> ~/.bashrc
fi
ln -sfr $DOTFILES_DIR/home/.config/zathura/ ~/.config

# Link files
ln -sf $DOTFILES_DIR/config/vscode/keybindings.json ~/.config/Code/User
ln -sf $DOTFILES_DIR/config/vscode/settings.json ~/.config/Code/User
ln -sf $DOTFILES_DIR/home/.gitconfig ~
# ln -s $HOME/.dotfiles/config/git/.gitconfig ~ -f
# ln -s $HOME/.dotfiles/config/npm/.npmrc ~ -f
# ln -s $HOME/.dotfiles/wsl/.bashrc ~ -f
# ln -s $HOME/.dotfiles/wsl/.inputrc ~ -f

# Link scripts
# ln -s $HOME/.dotfiles/home/.local/bin/gen_pass.sh ~/.local/bin -f

