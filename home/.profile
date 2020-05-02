#!/bin/sh

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"
