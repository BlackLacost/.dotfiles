#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh

# Enable vim-mode
set -o vi

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

alias ls='ls --color=auto'

alias g=git
alias ggl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias dokku='$HOME/.dokku/contrib/dokku_client.sh'
alias v='nvim'

eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/star.omp.json)"

