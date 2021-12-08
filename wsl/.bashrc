#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh

# Enable vim-mode
set -o vi

alias ls='ls --color=auto'
alias dokku='$HOME/.dokku/contrib/dokku_client.sh'
alias v='nvim'

eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/star.omp.json)"

