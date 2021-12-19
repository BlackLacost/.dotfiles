#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh

# Enable vim-mode
set -o vi
set show-mode-in-prompt on

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

# Add chrome.exe in windows PATH
# Install wslview
export BROWSER='chrome.exe'

export EDITOR='nvim'

mkcd() { mkdir -p "$@" && cd "$@"; }

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

alias g=git
alias ggl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias cdd='cd ~/.dotfiles'
alias cdp='cd ~/code'

alias dokku='$HOME/.dokku/contrib/dokku_client.sh'
alias v='nvim'

eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/star.omp.json)"

