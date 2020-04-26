#!/bin/bash

link () {
	target_file=$1
	dest_file=$2

	if [[ -f $dest_file ]]; then
		if [[ -f $dest_file.backup ]]; then
			rm $dest_file
		else
			mv $dest_file $dest_file.backup
		fi
	fi

	if [ -h $dest_file ]; then
		rm $dest_file
	fi

	ln $target_file $dest_file
}

link ~/.dotfiles/.config/i3/config ~/.config/i3/config
link ~/.dotfiles/.config/i3blocks/config ~/.config/i3blocks/config
link ~/.dotfiles/.local/bin/statusbar/volume ~/.local/bin/statusbar/volume

