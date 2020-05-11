#!/bin/sh

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"

# Default programs:
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="chromium"
export READER="zathura"

# fzf
#FD_OPTIONS="--hidden --follow --exclude .git --exclude node_modules"
FD_OPTIONS="--hidden \
            --exclude .git \
            --exclude node_modules \
            --exclude .npm \
            --exclude .nvm"
export FZF_DEFAULT_OPTS='--height 100% --layout=reverse --border'
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"

# Other program settings:
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
