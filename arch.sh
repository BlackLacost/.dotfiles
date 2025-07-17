#!/bin/bash

DOTFILES_DIR=$HOME/.dotfiles

#Rclone
ln -sf $DOTFILES_DIR/home/.config/systemd/user/rclone@mailru.service ~/.config/systemd/user

### VS Code
ln -sfr $DOTFILES_DIR/config/vscode/snippets ~/.config/Code/User
ln -sf $DOTFILES_DIR/config/vscode/keybindings.json ~/.config/Code/User
ln -sf $DOTFILES_DIR/config/vscode/settings.json ~/.config/Code/User

### Emacs
# ln -sfr $DOTFILES_DIR/home/.config/doom/ ~/.config
# if ! grep -qF "source ~/.config/doom/bashrc" ~/.bashrc; then
#   echo "source ~/.config/doom/bashrc" >> ~/.bashrc
# fi

# Link directories
# ln -sr $HOME/.dotfiles/config/vifm ~/.config -f
ln -sfr $DOTFILES_DIR/config/nvim/ ~/.config
ln -sfr $DOTFILES_DIR/config/mpv/ ~/.config
ln -sfr $DOTFILES_DIR/config/anki/addons21 ~/.local/share/Anki2
ln -sfr $DOTFILES_DIR/home/.config/alacritty/ ~/.config
ln -sfr $DOTFILES_DIR/home/.config/zathura/ ~/.config

# Link files
ln -sf $DOTFILES_DIR/home/.gitconfig ~
ln -sf $DOTFILES_DIR/home/.bashrc ~
ln -sf $DOTFILES_DIR/home/.inputrc ~
ln -sf $DOTFILES_DIR/home/.xinitrc ~
#ln -sf $DOTFILES_DIR/home/.xprofile ~
#ln -sf $DOTFILES_DIR/config/npm/.npmrc ~

# Link scripts
# ln -s $HOME/.dotfiles/home/.local/bin/gen_pass.sh ~/.local/bin -f
