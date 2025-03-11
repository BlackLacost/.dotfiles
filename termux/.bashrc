#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Enable vim-mode
set -o vi
set show-mode-in-prompt on

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

export EDITOR='nvim'

mkcd() { mkdir -p "$@" && cd "$@"; }

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

alias g=git
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glga="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gcmm='git commit -m'
alias gcma='git commit --amend'
alias gsw='git switch'
alias gchb='git checkout -b'
alias gst='git status'
alias gdf='git diff'
alias gdfc='git diff --cached'

alias cdd='cd ~/.dotfiles'
alias cdp='cd ~/code'

alias v='nvim'

