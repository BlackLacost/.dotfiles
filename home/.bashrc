#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ggl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias cdd='cd ~/.dotfiles'
alias cdx='cd ~/.xi'
alias cdc='cd ~/code'

export EDITOR="code"

source /usr/share/git/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# export GIT_PS1_SHOWUPSTREAM="verbose name"
export GIT_PS1_SHOWUPSTREAM="auto"
RED="$(echo -e "\e[31m")"
GREEN="$(echo -e "\e[32m")"
YELLOW="$(echo -e "\e[33m")"
BLUE="$(echo -e "\e[34m")"
MAGENTA="$(echo -e "\e[35m")"
RESET="$(echo -e "\e[00m")"
# PS1='\[\e[35m\][\w]\[\e[00m\] \[\e[34m\]$(__git_ps1 "(%s)")\[\e[00m\] \n\[\e[32m\]\$\u\[\e[00m\] ➡️  '
# PS1='\[${MAGENTA}\][\w]\[${RESET}\] \[${BLUE}\]$(__git_ps1 "(%s)")\[${RESET}\] \n\[${GREEN}\]\$\u\[${RESET}\] ➡️  '
PS1='\[${MAGENTA}\]\W\[${RESET}\]$(__git_ps1 "\[${GREEN}\] (%s)\[${RESET}\]") ➡️  '
PS2='↪️️  '

source /usr/share/nvm/init-nvm.sh
eval "$(pyenv init -)"

# powerline-daemon -q
# POWERLINE_BASH_CONTINUATION=1
# POWERLINE_BASH_SELECT=1
# . /usr/share/powerline/bindings/bash/powerline.sh
