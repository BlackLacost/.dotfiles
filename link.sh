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
	[ -f $dest_file ] && $backup_file $dest_file
	[ -h $dest_file ] && rm $dest_file
	ln $target_file $dest_file
}


link_dir() {
	dir=$1
	for f in $(find $dir); do
		[ -d $f ] && [ ! -d ~/$f ] && mkdir -p ~/$f
		[ -f $f ] && link_file $(realpath $f) ~/$f
	done
}

link_dir .config
link_dir .local

