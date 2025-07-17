#!/usr/bin/env bash

# set -Eeo pipefail
# Запрещает переменные без значения.
set -u

readonly NAME=photo
readonly TARGET_RELATION_DIRS=(H.Media/Photo+Video Camera_Uploads)
readonly FULL_BACKUP_EVERY_X_DAYS=7

# DATE="$(date -I)"
# readonly DATE="$(date +"%Y-%m-%d_%H-%M")"
readonly DATE="$(date +"%Y-%m-%d")"
readonly SCRIPT_NAME="$(basename $0)"
readonly SCRIPT_PATH="$(realpath $0)"
readonly SCRIPT_DIR_PATH="$(dirname $SCRIPT_PATH)"
readonly TARGET_DIR=/mnt/m
# Папка куда будет делаться бэкап
readonly BACKUP_DIR="/mnt/b/$NAME"

mkdir -p $BACKUP_DIR

# Options
target_dir_option="--fs-root $TARGET_DIR"
target_relation_dirs_option=$(
	for dir in "${TARGET_RELATION_DIRS[@]}"; do
		echo --go-into $dir
	done
)
created_name_option="--create ${BACKUP_DIR}/${NAME}_${DATE}"
verbose_option="--verbose=treated --verbose=messages"
compression_option="--compression=gzip:9"
exclude_option="--alter=no-case \
								--exclude *.avi \
								--exclude *.mp4 \
								--exclude *.mov \
								--exclude *.mkv"


if [[ ! -d $TARGET_DIR ]]; then
	echo Нет доступа к --fs-root
	exit
fi


for dir in "${TARGET_RELATION_DIRS[@]}"; do
	if [[ $dir == *' '* ]]; then
		echo "Скрипт не поддерживает папки \"$dir\" с пробелами".
		exit
	fi

	relation_dir_path="$TARGET_DIR/$dir"

	if [[ ! -d $relation_dir_path ]]; then
		echo Нет такой директории ${relation_dir_path}.
		exit
	fi
done


# Отсортированные файлы по дате создания, самый последний превый
files=($(ls -t --time=creation $BACKUP_DIR --reverse))

# Количество полных бэкапов за последние указанные дни
count_full_backup_last_x_days=$(find $BACKUP_DIR -type f -mtime -$FULL_BACKUP_EVERY_X_DAYS | grep -c full)

if [[ ${#files[@]} == 0 || $count_full_backup_last_x_days == 0 ]]; then
	dar $target_dir_option \
			$target_relation_dirs_option \
			${created_name_option}_full \
			$verbose_option \
			$exclude_option \
			$compression_option
else
	# Послдений созданный файл без расширения файла man bash Parameter Expansion
	last_created_file=${files[0]%%.*}

	dar $target_dir_option \
			$target_relation_dirs_option \
			${created_name_option}_diff \
			$verbose_option \
			$compression_option \
			$exclude_option \
			--ref $BACKUP_DIR/$last_created_file
fi

# if [[ $# -eq 0 ]]; then
# 	cat <<EOF
# Обязательные опции должна быть выбрана хотябы одна:

# --full, -f - полный
# --diff, -d - инкрементальный

# Примеры использования:

# $SCRIPT_NAME --full - полный бэкап
# $SCRIPT_NAME --diff - инкрементальный бэкап
# EOF
# 	exit
# fi