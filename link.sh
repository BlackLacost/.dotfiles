#!/bin/bash

backup_file() {
	file=$1
	if [ -f $file.backup ]; then
		rm $dest_file
	else
		mv $dest_file $dest_file.backup
	fi
}

link_file() {
	target_file=$1
	dest_file=$2
	[ -f $dest_file ] && backup_file $dest_file
	[ -h $dest_file ] && rm $dest_file
	ln $target_file $dest_file
}

link_home() {
	for item in $(find home | sed '1d'); do
        item_without_home=$(echo $item | sed 's|home/||')
		[ -d $item ] && [ ! -d ~/$item_without_home ] && mkdir -p ~/$item_without_home
		[ -f $item ] && link_file $(realpath $item) ~/$item_without_home
	done
    echo "Linked home dir"
}

link_home
link_file config/git/.gitconfig ~/.gitconfig

