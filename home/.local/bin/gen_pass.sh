#!/bin/sh

# Скрипт генерирует пароль заданной длины через первый аргумент,
# если аргумент не передан, то пароль будет в 32 символа.

if [ "$1" ]; then
  PASSWORD_LENGTH=$1
else
  PASSWORD_LENGTH=32
fi

date +"%Y-%m-%d %T.%N" | md5sum | head -c $PASSWORD_LENGTH | xclip -sel clip

