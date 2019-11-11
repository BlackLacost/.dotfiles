#!/bin/bash

keybindings_file="$HOME/.config/Code/User/keybindings.json"
settings_file="$HOME/.config/Code/User/settings.json"


if [ -f $keybindings_file ]; then
    mv $keybindings_file $keybindings_file.backup
fi
if [ -h $keybindings_file ]; then
    rm $keybindings_file
fi
ln config/vscode/keybindings.json $keybindings_file

if [ -f $settings_file ]; then
    mv $settings_file $settings_file.backup
fi
if [ -h $settings_file ]; then
    rm $settings_file
fi
ln config/vscode/settings.json $settings_file
