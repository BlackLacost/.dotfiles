#!/bin/sh

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"

# Default programs:
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="brave"
export READER="zathura"

# Other program settings:
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
