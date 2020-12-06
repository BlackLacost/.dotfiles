#!/bin/bash

backup_file() {
	file=$1
	if [ -f $file.backup ]; then
		rm $file
	else
		mv $file $file.backup
	fi
}

link_file() {
	target_file=$1
	dest_file=$2
	[ -f $dest_file ] && backup_file $dest_file
	[ -h $dest_file ] && rm $dest_file
	ln $target_file $dest_file
}

link_dirs_in_dir() {
    dir=$1
	for item in $(find $dir | sed '1d'); do
        item_without_root_dir=$(echo $item | sed "s|$dir/||")
		[ -d $item ] && [ ! -d ~/$item_without_root_dir ] && mkdir -p ~/$item_without_root_dir
		[ -f $item ] && link_file $(realpath $item) ~/$item_without_root_dir
	done
    echo "Linked $dir dir"
}

link_dir() {
    dir=$1
    dest_dir=$2
    parent_dir=$(dirname $dir)

	for item in $(find $dir); do
        item_without_parent_dir=$(echo $item | sed "s|$parent_dir/||")
		[ -d $item ] && [ ! -d $dest_dir/$item_without_parent_dir ] && mkdir -p $dest_dir/$item_without_parent_dir
		[ -f $item ] && link_file $(realpath $item) $dest_dir/$item_without_parent_dir
	done
    echo "Linked $dir to $dest_dir"
}

[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.bak
link_dirs_in_dir home
link_dir config/mpv/ ~/.config
